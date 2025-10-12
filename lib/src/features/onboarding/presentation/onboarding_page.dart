import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/widgets/mini_carousel.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final slides = <_OnboardingSlide>[
      _OnboardingSlide(
        title: context.l10n.appTitle,
        description: context.l10n.swipeToExplore,
        asset: 'assets/onboarding_swipe.png',
      ),
      _OnboardingSlide(
        title: context.l10n.createListing,
        description: context.l10n.createIntent,
        asset: 'assets/onboarding_bento.png',
      ),
      _OnboardingSlide(
        title: context.l10n.placeBid,
        description: 'Boost your chances with quick bids and smart matches.',
        asset: 'assets/onboarding_bid.png',
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final hasCarousel = _hasCarouselView();
                    if (hasCarousel) {
                      return CarouselView(
                        padding: EdgeInsets.zero,
                        itemExtent: constraints.maxWidth,
                        children: slides
                            .map((slide) => _OnboardingCard(slide: slide))
                            .toList(),
                      );
                    }
                    return MiniCarousel(
                      itemCount: slides.length,
                      itemBuilder: (context, index) => _OnboardingCard(slide: slides[index]),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  state.markOnboardingSeen();
                  final router = AppRouterDelegate.of(context);
                  if (state.isLoggedIn) {
                    router.go('/swipe');
                  } else {
                    router.go('/auth/login');
                  }
                },
                child: Text(context.l10n.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasCarouselView() {
    try {
      CarouselView? view;
      view = const CarouselView(children: []);
      return view != null;
    } catch (_) {
      return false;
    }
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({required this.title, required this.description, required this.asset});

  final String title;
  final String description;
  final String asset;
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Center(
                child: Icon(Icons.grid_view_rounded, size: 120, color: theme.colorScheme.primary),
              ),
            ),
            const SizedBox(height: 16),
            Text(slide.title, style: theme.textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              slide.description,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
