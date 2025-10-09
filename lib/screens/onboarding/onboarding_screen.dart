import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<_Slide> _slides = const [
    _Slide('onboarding_title_1', 'onboarding_sub_1'),
    _Slide('onboarding_title_2', 'onboarding_sub_2'),
    _Slide('onboarding_title_3', 'onboarding_sub_3'),
  ];
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentIndex < _slides.length - 1) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        timer.cancel();
        _complete();
      }
    });
  }

  void _complete() {
    Navigator.of(context).pushReplacementNamed(AppRoutes.auth);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _complete,
                    child: Text(lang.t('start_now')),
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 600),
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: _slides.length,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                        if (index == _slides.length - 1) {
                          _timer?.cancel();
                          _timer = Timer(const Duration(seconds: 3), _complete);
                        }
                      },
                      itemBuilder: (context, index) {
                        final slide = _slides[index];
                        return AnimatedBuilder(
                          animation: _pageController,
                          builder: (context, child) {
                            double value = 1;
                            if (_pageController.position.haveDimensions) {
                              value = (_pageController.page ?? 0) - index;
                              value = (1 - (value.abs() * 0.2)).clamp(0.8, 1.0);
                            }
                            return Transform.scale(
                              scale: value,
                              child: child,
                            );
                          },
                          child: _OnboardingSlide(slide: slide),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                PageIndicator(length: _slides.length, currentIndex: _currentIndex),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _timer?.cancel();
                    if (_currentIndex < _slides.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _complete();
                    }
                  },
                  child: Text(
                    _currentIndex == _slides.length - 1
                        ? lang.t('start_now')
                        : lang.t('next'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  const _OnboardingSlide({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'app_logo',
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.6),
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
              child: Text(
                'SB',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 48),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: Text(
            lang.t(slide.titleKey),
            key: ValueKey(slide.titleKey),
            textAlign: TextAlign.center,
            style: theme.textTheme.displayLarge,
          ),
        ),
        const SizedBox(height: 16),
        AnimatedOpacity(
          opacity: 1,
          duration: const Duration(milliseconds: 500),
          child: Text(
            lang.t(slide.subtitleKey),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }
}

class _Slide {
  const _Slide(this.titleKey, this.subtitleKey);

  final String titleKey;
  final String subtitleKey;
}
