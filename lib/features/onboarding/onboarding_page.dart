import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../widgets/media_placeholder.dart';
import 'onboarding_vm.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});

  final Future<void> Function() onDone;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final OnboardingViewModel viewModel;

  String _titleForSlide(AppLocalizations l10n, OnboardingSlide slide) {
    switch (slide.titleKey) {
      case 'onboardingIndustrial':
        return l10n.onboardingIndustrial;
      case 'onboardingSell':
        return l10n.onboardingSell;
      case 'onboardingFind':
        return l10n.onboardingFind;
      case 'onboardingAi':
        return l10n.onboardingAi;
      default:
        return slide.titleKey;
    }
  }

  @override
  void initState() {
    super.initState();
    viewModel = OnboardingViewModel();
  }

  @override
  void dispose() {
    viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: viewModel,
          builder: (context, _) {
            return Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: viewModel.controller,
                    itemCount: viewModel.slides.length,
                    onPageChanged: viewModel.onPageChanged,
                    itemBuilder: (context, index) {
                      final slide = viewModel.slides[index];
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: MediaPlaceholder(
                                  seed: slide.seed,
                                  borderRadius: BorderRadius.circular(24),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        slide.icon,
                                        size: 96,
                                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.9),
                                      ),
                                      const SizedBox(height: 24),
                                      Text(
                                        _titleForSlide(l10n, slide),
                                        style: Theme.of(context).textTheme.displayLarge,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(viewModel.slides.length, (index) {
                    final active = index == viewModel.currentIndex;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: active ? 24 : 8,
                      decoration: BoxDecoration(
                        color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      TextButton(onPressed: widget.onDone, child: Text(l10n.skip)),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: viewModel.isLast ? widget.onDone : viewModel.next,
                        child: Text(viewModel.isLast ? l10n.done : l10n.next),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
