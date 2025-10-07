import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/onboarding_step.dart';
import '../../widgets/glass_card.dart';
import '../auth/auth_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  late final ValueNotifier<int> _pageNotifier;
  late final List<OnboardingStep> _steps;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _pageNotifier = ValueNotifier<int>(0);
    _steps = const [
      OnboardingStep(
        icon: Icons.star_rate_rounded,
        titleKey: 'discover_items',
        subtitleKey: 'welcome',
      ),
      OnboardingStep(
        icon: Icons.lock_clock_rounded,
        titleKey: 'secure_payments',
        subtitleKey: 'pull_refresh',
      ),
      OnboardingStep(
        icon: Icons.store_mall_directory_rounded,
        titleKey: 'sell_anything',
        subtitleKey: 'sell_buy',
      ),
    ];
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageNotifier.dispose();
    super.dispose();
  }

  void _goToAuth(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('auction_app')),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => _goToAuth(context),
            child: Text(lang.t('skip')),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => _pageNotifier.value = index,
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final step = _steps[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: GlassCard(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Hero(
                          tag: 'onboarding_${step.titleKey}',
                          child: Icon(
                            step.icon,
                            size: 96,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 32),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            lang.t(step.titleKey),
                            key: ValueKey<String>(step.titleKey + lang.locale.languageCode),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            lang.t(step.subtitleKey),
                            key: ValueKey<String>(
                                '${step.subtitleKey}_${lang.locale.languageCode}'),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<int>(
            valueListenable: _pageNotifier,
            builder: (context, index, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_steps.length, (i) {
                  final isActive = i == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 6),
                    height: 10,
                    width: isActive ? 28 : 12,
                    decoration: BoxDecoration(
                      color: isActive
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: ValueListenableBuilder<int>(
              valueListenable: _pageNotifier,
              builder: (context, index, _) {
                final isLast = index == _steps.length - 1;
                return Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (index > 0) {
                            _controller.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: index == 0
                              ? const SizedBox.shrink()
                              : Text(lang.t('back')),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (isLast) {
                            _goToAuth(context);
                          } else {
                            _controller.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Text(
                            lang.t(isLast ? 'get_started' : 'next'),
                            key: ValueKey<String>('btn_${isLast}_${lang.locale.languageCode}'),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
