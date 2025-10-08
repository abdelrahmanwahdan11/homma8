import 'package:flutter/material.dart';

import '../core/theme/theme_manager.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    this.useSurface = false,
    this.padding,
    super.key,
  });

  final Widget child;
  final bool useSurface;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final gradients = Theme.of(context).extension<AppGradients>();
    final gradient = useSurface ? gradients?.surface : gradients?.background;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: gradient ?? const LinearGradient(colors: [Colors.black, Colors.black]),
      ),
      child: padding == null ? child : Padding(padding: padding!, child: child),
    );
  }
}
