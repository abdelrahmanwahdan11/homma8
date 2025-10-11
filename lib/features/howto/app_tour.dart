import 'dart:ui';

import 'package:flutter/material.dart';

class TourStep {
  TourStep({required this.key, required this.message});

  final GlobalKey key;
  final String message;
}

class AppTour {
  AppTour({required this.context, required this.steps});

  final BuildContext context;
  final List<TourStep> steps;

  OverlayEntry? _entry;
  int _index = 0;

  void start() {
    if (steps.isEmpty) return;
    _entry = OverlayEntry(builder: (context) {
      final step = steps[_index];
      final renderBox = step.key.currentContext?.findRenderObject() as RenderBox?;
      final offset = renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
      final size = renderBox?.size ?? Size.zero;
      final rect = offset & size;
      return GestureDetector(
        onTap: next,
        child: Material(
          color: Colors.black54,
          child: Stack(
            children: [
              CustomPaint(
                size: MediaQuery.of(context).size,
                painter: _SpotlightPainter(rect),
              ),
              Positioned(
                left: rect.left,
                top: rect.bottom + 16,
                right: 24,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      step.message,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
    Overlay.of(context).insert(_entry!);
  }

  void next() {
    if (_index < steps.length - 1) {
      _index++;
      _entry?.markNeedsBuild();
    } else {
      close();
    }
  }

  void close() {
    _entry?.remove();
    _entry = null;
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter(this.rect);

  final Rect rect;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..blendMode = BlendMode.dstOut;
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(rect.inflate(12), const Radius.circular(20)));
    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.rect != rect;
  }
}
