import 'package:flutter/material.dart';

import '../../app/app.dart';
import '../../app/router.dart';
import '../../app/strings.dart';
import '../../core/design_tokens.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _controller;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _complete() {
    final scope = AppScope.of(context);
    scope.appStore.setFirstRun(false);
    Navigator.of(context).pushReplacementNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final theme = Theme.of(context);
    final items = [
      (
        strings.t('onboarding_1_title'),
        strings.t('onboarding_1_sub'),
      ),
      (
        strings.t('onboarding_2_title'),
        strings.t('onboarding_2_sub'),
      ),
      (
        strings.t('onboarding_3_title'),
        strings.t('onboarding_3_sub'),
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: _complete,
                child: Text(strings.t('cta_get_started')),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (value) {
                  setState(() => _index = value);
                },
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _OnboardingSlide(
                    title: item.$1,
                    subtitle: item.$2,
                    index: index,
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                items.length,
                (i) => AnimatedContainer(
                  duration: Durations.defaultDuration,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _index
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                    borderRadius: Radii.medium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
              child: ElevatedButton(
                onPressed: () {
                  if (_index < items.length - 1) {
                    _controller.nextPage(
                      duration: Durations.defaultDuration,
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _complete();
                  }
                },
                child: Text(strings.t('cta_get_started')),
              ),
            ),
            const SizedBox(height: Spacing.lg),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.index,
  });

  final String title;
  final String subtitle;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.lg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(
            tag: 'onboarding_icon',
            child: AnimatedContainer(
              duration: Durations.defaultDuration,
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withOpacity(0.4),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Center(
                child: AnimatedScale(
                  duration: Durations.defaultDuration,
                  scale: 1 + index * 0.02,
                  child: Icon(
                    index == 0
                        ? Icons.swipe
                        : index == 1
                            ? Icons.percent
                            : Icons.gavel,
                    size: 72,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge,
          ),
          const SizedBox(height: Spacing.md),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
