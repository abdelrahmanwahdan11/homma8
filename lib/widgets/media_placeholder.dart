import 'dart:math';

import 'package:flutter/material.dart';

/// A deterministic gradient-based placeholder used instead of binary image assets.
///
/// The placeholder derives its colors from the current [ColorScheme] and a seed
/// string so the same seed always yields the same visual treatment. This allows
/// the mock marketplace to present varied imagery without shipping binary
/// assets, which keeps the repository fully text-based for portability.
class MediaPlaceholder extends StatelessWidget {
  const MediaPlaceholder({
    super.key,
    required this.seed,
    this.aspectRatio,
    this.borderRadius = const BorderRadius.all(Radius.circular(0)),
    this.icon = Icons.inventory_2_outlined,
    this.child,
  });

  /// Text seed used to deterministically pick gradient stops.
  final String seed;

  /// Optional aspect ratio wrapper for the rendered placeholder.
  final double? aspectRatio;

  /// Corner radius applied to the painted surface.
  final BorderRadius borderRadius;

  /// Fallback icon rendered when [child] is not supplied.
  final IconData icon;

  /// Optional child widget painted on top of the placeholder.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final gradient = _resolveGradient(scheme, seed);
    final overlay = _resolveOverlay(scheme, seed);

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: overlay.withOpacity(0.28)),
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _DiagonalPatternPainter(color: overlay.withOpacity(0.12)),
            ),
            Center(
              child: child ??
                  Icon(
                    icon,
                    size: min(72.0, MediaQuery.of(context).size.width * 0.18),
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.82),
                  ),
            ),
          ],
        ),
      ),
    );

    if (aspectRatio != null) {
      content = AspectRatio(aspectRatio: aspectRatio!, child: content);
    }
    return content;
  }

  List<Color> _resolveGradient(ColorScheme scheme, String seed) {
    final hash = seed.hashCode;
    final primaryMix = Color.lerp(scheme.primary, scheme.background, 0.2 + (hash % 30) / 100) ?? scheme.primary;
    final accentMix = Color.lerp(scheme.secondary, scheme.surface, 0.4 + (hash % 20) / 80) ?? scheme.secondary;
    final variantHue = (hash % 360).toDouble();
    final accent = HSLColor.fromColor(primaryMix).withHue((variantHue + 40) % 360).withLightness(0.55).toColor();
    return [primaryMix, accent, accentMix];
  }

  Color _resolveOverlay(ColorScheme scheme, String seed) {
    final hash = seed.hashCode;
    final luminanceShift = ((hash >> 4) & 0xFF) / 255;
    return Color.lerp(scheme.secondary, scheme.primary, luminanceShift) ?? scheme.secondary;
  }
}

class _DiagonalPatternPainter extends CustomPainter {
  const _DiagonalPatternPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.2;
    const spacing = 18.0;
    for (double x = -size.height; x < size.width + size.height; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
