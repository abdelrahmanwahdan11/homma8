import 'dart:async';

import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';
import '../core/theme/theme_manager.dart';
import '../widgets/gradient_background.dart';
import 'onboarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeManager = ThemeManager.of(context);
    final lang = LanguageManager.of(context);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: ValueListenableBuilder<ThemeMode>(
          valueListenable: themeManager.themeNotifier,
          builder: (context, mode, _) {
            return FloatingActionButton(
              onPressed: themeManager.toggleTheme,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Icon(
                  mode == ThemeMode.dark
                      ? Icons.wb_sunny_rounded
                      : Icons.dark_mode_rounded,
                  key: ValueKey<ThemeMode>(mode),
                ),
              ),
            );
          },
        ),
        body: Center(
          child: FadeTransition(
            opacity: _opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Hero(
                  tag: 'app_logo',
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient:
                          Theme.of(context).extension<AppGradients>()?.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.35),
                          blurRadius: 28,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      size: 68,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  lang.t('auction_app'),
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 18),
                TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 2),
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, _) {
                    return SizedBox(
                      width: 140,
                      child: LinearProgressIndicator(
                        value: value,
                        minHeight: 6,
                        borderRadius: BorderRadius.circular(20),
                        valueColor: AlwaysStoppedAnimation(
                          Theme.of(context).colorScheme.primary,
                        ),
                        backgroundColor:
                            Theme.of(context).colorScheme.primary.withOpacity(0.15),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
