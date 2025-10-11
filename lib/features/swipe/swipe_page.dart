import 'dart:math';

import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/router.dart';
import '../../app/strings.dart';
import '../../application/stores.dart';
import '../../core/design_tokens.dart';
import '../../domain/entities.dart';
import '../details/product_details_page.dart';
import 'widgets/product_card.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({
    required this.swipeKey,
    required this.bidButtonKey,
    required this.discountBadgeKey,
    super.key,
  });

  final GlobalKey swipeKey;
  final GlobalKey bidButtonKey;
  final GlobalKey discountBadgeKey;

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  Offset _dragOffset = Offset.zero;
  double _dragAngle = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scope = AppScope.of(context);
      if (scope.catalogStore.value.products.isEmpty) {
        scope.fetchProducts.call();
      }
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta;
      _dragAngle = (_dragOffset.dx / 300).clamp(-0.3, 0.3);
    });
  }

  void _resetDrag() {
    setState(() {
      _dragOffset = Offset.zero;
      _dragAngle = 0;
    });
  }

  void _handleEnd(Product product, AppScope scope) {
    if (_dragOffset.dx > 120) {
      scope.swipeRight.call(product);
    } else if (_dragOffset.dx < -120) {
      scope.skipLeft.call();
    }
    if (scope.catalogStore.value.swipeIndex >=
        scope.catalogStore.value.products.length - 3) {
      scope.fetchProducts.call();
    }
    _resetDrag();
  }

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final strings = AppStrings.of(context);
    return ValueListenableBuilder<CatalogState>(
      valueListenable: scope.catalogStore,
      builder: (context, state, _) {
        if (state.isLoading && state.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.error != null && state.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.error!.message),
                const SizedBox(height: Spacing.md),
                ElevatedButton(
                  onPressed: () => scope.fetchProducts.call(),
                  child: Text(strings.t('retry')),
                ),
              ],
            ),
          );
        }
        final remaining = state.products.skip(state.swipeIndex).toList();
        if (remaining.isEmpty) {
          return Center(
            child: ElevatedButton(
              onPressed: () => scope.fetchProducts.call(),
              child: Text(strings.t('retry')),
            ),
          );
        }
        return LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = min(constraints.maxWidth, 600.0);
            return Center(
              child: SizedBox(
                key: widget.swipeKey,
                width: maxWidth,
                height: constraints.maxHeight,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    for (var i = 1; i < min(3, remaining.length); i++)
                      Positioned.fill(
                        top: i * 12,
                        child: Transform.scale(
                          scale: 1 - i * 0.05,
                          child: ProductCard(
                            product: remaining[i],
                            discountBadgeKey: null,
                            bidButtonKey: null,
                          ),
                        ),
                      ),
                    Positioned.fill(
                      child: GestureDetector(
                        onPanUpdate: _handleDragUpdate,
                        onPanEnd: (_) => _handleEnd(remaining.first, scope),
                        onPanCancel: _resetDrag,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RouteNames.productDetails,
                            arguments: ProductDetailsArgs(product: remaining.first),
                          );
                        },
                        child: AnimatedContainer(
                          duration: Durations.defaultDuration,
                          transform: Matrix4.identity()
                            ..translate(_dragOffset.dx, _dragOffset.dy)
                            ..rotateZ(_dragAngle),
                          curve: Curves.easeInOut,
                          child: ProductCard(
                            product: remaining.first,
                            discountBadgeKey: widget.discountBadgeKey,
                            bidButtonKey: widget.bidButtonKey,
                          ),
                        ),
                      ),
                    ),
                    if (_dragOffset.dx > 40)
                      Positioned(
                        top: 40,
                        right: 20,
                        child: _SwipeIndicator(
                          label: strings.t('label_watch'),
                          color: Colors.greenAccent,
                        ),
                      ),
                    if (_dragOffset.dx < -40)
                      Positioned(
                        top: 40,
                        left: 20,
                        child: _SwipeIndicator(
                          label: strings.t('label_skip'),
                          color: Colors.redAccent,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _SwipeIndicator extends StatelessWidget {
  const _SwipeIndicator({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: Radii.medium,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.md, vertical: Spacing.sm),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
