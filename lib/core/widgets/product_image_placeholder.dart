import 'package:flutter/material.dart';

class ProductImagePlaceholder extends StatelessWidget {
  const ProductImagePlaceholder({
    required this.label,
    this.borderRadius,
    this.aspectRatio,
    super.key,
  });

  final String label;
  final BorderRadius? borderRadius;
  final double? aspectRatio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = _colorsFromLabel(label);
    final content = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _displayLabel(label),
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );

    final widget = borderRadius == null
        ? content
        : ClipRRect(
            borderRadius: borderRadius,
            child: content,
          );

    if (aspectRatio != null) {
      return AspectRatio(
        aspectRatio: aspectRatio!,
        child: widget,
      );
    }
    return widget;
  }

  List<Color> _colorsFromLabel(String value) {
    final seed = value.hashCode;
    final hue = (seed.abs() % 360).toDouble();
    final secondaryHue = (hue + 36) % 360;
    final primary = HSLColor.fromAHSL(1, hue, 0.45, 0.55).toColor();
    final secondary = HSLColor.fromAHSL(1, secondaryHue, 0.5, 0.4).toColor();
    return [primary, secondary];
  }

  String _displayLabel(String value) {
    final cleaned = value
        .replaceAll(RegExp(r'[_\-/]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (cleaned.isEmpty) {
      return 'SwipeBid';
    }
    final words = cleaned.split(' ');
    if (words.length == 1) {
      return cleaned;
    }
    final subset = words.take(3).join(' ');
    return subset;
  }
}
