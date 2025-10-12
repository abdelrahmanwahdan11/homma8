import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = AppScope.of(context);
      final router = AppRouterDelegate.of(context);
      Future<void>.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        if (!state.onboardingSeen) {
          router.go('/onboarding');
        } else if (!state.isLoggedIn) {
          router.go('/auth/login');
        } else {
          router.go('/swipe');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'logo_hero',
                child: Icon(Icons.diamond, size: 96, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Text(context.l10n.appTitle, style: theme.textTheme.headlineMedium),
            ],
          ),
        ),
      ),
    );
  }
}
