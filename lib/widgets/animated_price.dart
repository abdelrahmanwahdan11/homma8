import 'package:flutter/material.dart';

import '../core/theme/theme_manager.dart';

class AnimatedPrice extends StatefulWidget {
  const AnimatedPrice({
    required this.priceNotifier,
    required this.currency,
    super.key,
  });

  final ValueListenable<double> priceNotifier;
  final String currency;

  @override
  State<AnimatedPrice> createState() => _AnimatedPriceState();
}

class _AnimatedPriceState extends State<AnimatedPrice>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.priceNotifier.value;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    widget.priceNotifier.addListener(_handlePriceChange);
  }

  @override
  void didUpdateWidget(covariant AnimatedPrice oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.priceNotifier != widget.priceNotifier) {
      oldWidget.priceNotifier.removeListener(_handlePriceChange);
      _currentValue = widget.priceNotifier.value;
      widget.priceNotifier.addListener(_handlePriceChange);
    }
  }

  void _handlePriceChange() {
    final newValue = widget.priceNotifier.value;
    if (newValue == _currentValue) return;
    setState(() {
      _currentValue = newValue;
      _controller.forward(from: 0);
    });
  }

  @override
  void dispose() {
    widget.priceNotifier.removeListener(_handlePriceChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradients = Theme.of(context).extension<AppGradients>();
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final pulse = Curves.easeOutBack.transform(1 - _controller.value);
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: gradients?.accent,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.25 * pulse),
                blurRadius: 22 + (10 * pulse),
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Text(
            '${widget.currency}${_currentValue.toStringAsFixed(0)}',
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w800, color: Colors.black87),
          ),
        );
      },
    );
  }
}
