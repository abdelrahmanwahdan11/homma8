import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SplashSoonPage extends StatefulWidget {
  const SplashSoonPage({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  State<SplashSoonPage> createState() => _SplashSoonPageState();
}

class _SplashSoonPageState extends State<SplashSoonPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    Future<void>.delayed(const Duration(milliseconds: 2200), () {
      if (mounted) {
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final size = MediaQuery.sizeOf(context);
    final fontSize = (size.shortestSide * 0.12).clamp(24.0, 48.0);
    return Scaffold(
      body: Center(
        child: Semantics(
          label: l10n.comingSoonSemantics,
          child: FadeTransition(
            opacity: _fade,
            child: Text(
              l10n.comingSoon,
              style: Theme.of(context)
                  .textTheme
                  .displayMedium
                  ?.copyWith(fontSize: fontSize, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
