import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/theme_manager.dart';

class GlassCard extends StatelessWidget {
  const GlassCard({
    required this.child,
    this.padding,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final gradients = Theme.of(context).extension<AppGradients>();
    final surfaceGradient = gradients?.surface;
    final colorScheme = Theme.of(context).colorScheme;
    final card = ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          decoration: BoxDecoration(
            gradient: surfaceGradient,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: colorScheme.primary.withOpacity(0.22),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.18),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          padding: padding ?? const EdgeInsets.all(24),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return card;
    }
    return InkWell(
      borderRadius: BorderRadius.circular(28),
      onTap: onTap,
      child: card,
    );
  }
}
