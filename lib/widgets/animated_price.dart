import 'package:flutter/material.dart';

class AnimatedPrice extends StatelessWidget {
  const AnimatedPrice({
    required this.priceNotifier,
    required this.currency,
    super.key,
  });

  final ValueListenable<double> priceNotifier;
  final String currency;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: priceNotifier,
      builder: (context, value, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.25),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
          child: Text(
            '$currency${value.toStringAsFixed(0)}',
            key: ValueKey<double>(value),
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        );
      },
    );
  }
}
