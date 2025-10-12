import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MiniCarousel extends StatefulWidget {
  const MiniCarousel({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.height = 220,
    this.viewportFraction = 0.85,
    this.autoPlay = true,
    this.interval = const Duration(seconds: 4),
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double height;
  final double viewportFraction;
  final bool autoPlay;
  final Duration interval;

  @override
  State<MiniCarousel> createState() => _MiniCarouselState();
}

class _MiniCarouselState extends State<MiniCarousel> {
  late final PageController _controller;
  int _index = 0;
  late final Ticker _ticker;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: widget.viewportFraction);
    _ticker = Ticker(_onTick);
    if (widget.autoPlay && widget.itemCount > 1) {
      _ticker.start();
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted) {
      return;
    }
    _elapsed += elapsed;
    if (_elapsed >= widget.interval) {
      _elapsed = Duration.zero;
      _index = (_index + 1) % widget.itemCount;
      _controller.animateToPage(
        _index,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _controller,
        itemCount: widget.itemCount,
        itemBuilder: (context, index) {
          return AnimatedScale(
            scale: _index == index ? 1.0 : 0.94,
            duration: const Duration(milliseconds: 300),
            child: widget.itemBuilder(context, index),
          );
        },
        onPageChanged: (value) {
          setState(() {
            _index = value;
          });
          _elapsed = Duration.zero;
        },
      ),
    );
  }
}
