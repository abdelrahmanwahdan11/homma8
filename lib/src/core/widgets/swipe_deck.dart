import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/l10n_extensions.dart';

enum SwipeDeckAction { like, pass, open, quickBid }

typedef SwipeDeckActionCallback = void Function(SwipeDeckAction action, int index);

typedef SwipeDeckCardBuilder = Widget Function(BuildContext context, int index);

class SwipeDeckController extends ChangeNotifier {
  int _currentIndex = 0;
  int _itemCount = 0;
  void Function(SwipeDeckAction action)? _handler;

  int get currentIndex => _currentIndex;
  int get itemCount => _itemCount;
  int get remaining => math.max(0, _itemCount - _currentIndex);

  void act(SwipeDeckAction action) {
    _handler?.call(action);
  }

  void _bind({required int currentIndex, required int itemCount, required void Function(SwipeDeckAction action) handler}) {
    _currentIndex = currentIndex;
    _itemCount = itemCount;
    _handler = handler;
  }

  void _update(int index, int count) {
    _currentIndex = index;
    _itemCount = count;
    notifyListeners();
  }

  void detach() {
    _handler = null;
  }
}

class SwipeDeck extends StatefulWidget {
  const SwipeDeck({
    super.key,
    required this.itemCount,
    required this.cardBuilder,
    required this.controller,
    this.onAction,
    this.onIndexChanged,
    this.visibleCards = 3,
  });

  final int itemCount;
  final SwipeDeckCardBuilder cardBuilder;
  final SwipeDeckController controller;
  final SwipeDeckActionCallback? onAction;
  final ValueChanged<int>? onIndexChanged;
  final int visibleCards;

  @override
  State<SwipeDeck> createState() => _SwipeDeckState();
}

class _SwipeDeckState extends State<SwipeDeck> with SingleTickerProviderStateMixin {
  static const double _threshold = 120;

  late int _index;
  double _dx = 0;
  double _dy = 0;
  late AnimationController _controller;
  Animation<Offset>? _resetAnimation;

  @override
  void initState() {
    super.initState();
    _index = widget.controller.currentIndex;
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 240))
      ..addStatusListener(_handleAnimationStatus);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bind(currentIndex: _index, itemCount: widget.itemCount, handler: _onControllerAction);
  }

  @override
  void didUpdateWidget(covariant SwipeDeck oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.detach();
      widget.controller._bind(currentIndex: _index, itemCount: widget.itemCount, handler: _onControllerAction);
    } else {
      widget.controller._bind(currentIndex: _index, itemCount: widget.itemCount, handler: _onControllerAction);
    }
  }

  @override
  void dispose() {
    widget.controller.detach();
    _controller.dispose();
    super.dispose();
  }

  void _onControllerAction(SwipeDeckAction action) {
    _triggerAction(action, byController: true);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _controller.reset();
      setState(() {
        _dx = 0;
        _dy = 0;
        _resetAnimation = null;
      });
    }
  }

  void _triggerAction(SwipeDeckAction action, {bool byController = false}) {
    if (_index >= widget.itemCount) {
      return;
    }
    widget.onAction?.call(action, _index);
    setState(() {
      _index += 1;
      _dx = 0;
      _dy = 0;
      _resetAnimation = null;
    });
    widget.controller._update(_index, widget.itemCount);
    widget.onIndexChanged?.call(_index);
    if (!byController) {
      HapticFeedback.mediumImpact();
    }
  }

  void _animateBack() {
    _resetAnimation = Tween<Offset>(begin: Offset(_dx, _dy), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_index >= widget.itemCount) {
      return Center(
        child: Text(
          context.l10n.swipeDeckEmpty,
          style: theme.textTheme.labelLarge,
        ),
      );
    }
    final visible = math.min(widget.visibleCards, widget.itemCount - _index);
    final cards = <Widget>[];
    for (int i = 0; i < visible; i++) {
      final cardIndex = _index + (visible - i - 1);
      final depth = cardIndex - _index;
      final scale = 1 - depth * 0.05;
      final offsetY = depth * 18.0;
      final card = Positioned.fill(
        child: Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: depth == 0 ? 1.0 : scale,
            alignment: Alignment.topCenter,
            child: depth == 0 ? _buildTopCard(cardIndex) : _buildCard(cardIndex),
          ),
        ),
      );
      cards.add(card);
    }
    return Stack(children: cards);
  }

  Widget _buildCard(int index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: widget.cardBuilder(context, index),
    );
  }

  Widget _buildTopCard(int index) {
    final child = _buildCard(index);
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final offset = _resetAnimation?.value ?? Offset(_dx, _dy);
        final rotation = (_resetAnimation == null ? _dx : offset.dx) / 320;
        return Transform.translate(
          offset: offset,
          child: Transform.rotate(
            angle: rotation,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  _dx += details.delta.dx;
                  _dy += details.delta.dy;
                });
              },
              onPanEnd: (_) => _resolveGesture(),
              onDoubleTap: () => _triggerAction(SwipeDeckAction.quickBid),
              child: child,
            ),
          ),
        );
      },
    );
  }

  void _resolveGesture() {
    final dx = _dx;
    final dy = _dy;
    if (dx > _threshold) {
      _triggerAction(SwipeDeckAction.like);
      return;
    }
    if (dx < -_threshold) {
      _triggerAction(SwipeDeckAction.pass);
      return;
    }
    if (dy < -_threshold) {
      _triggerAction(SwipeDeckAction.open);
      return;
    }
    if (dy > _threshold) {
      _triggerAction(SwipeDeckAction.quickBid);
      return;
    }
    _animateBack();
  }
}
