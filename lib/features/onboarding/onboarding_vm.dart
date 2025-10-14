import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel();

  final PageController controller = PageController();
  int currentIndex = 0;

  final List<OnboardingSlide> slides = const [
    OnboardingSlide(title: 'Industrial introductions', seed: 'onboarding_industrial', icon: Icons.factory_outlined),
    OnboardingSlide(title: 'Sell with auctions', seed: 'onboarding_auctions', icon: Icons.gavel_outlined),
    OnboardingSlide(title: 'Find wanted buyers', seed: 'onboarding_wanted', icon: Icons.search_rounded),
    OnboardingSlide(title: 'AI ready insights', seed: 'onboarding_ai', icon: Icons.auto_awesome_outlined),
  ];

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void next() {
    if (currentIndex < slides.length - 1) {
      controller.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  bool get isLast => currentIndex == slides.length - 1;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class OnboardingSlide {
  const OnboardingSlide({required this.title, required this.seed, required this.icon});

  final String title;
  final String seed;
  final IconData icon;
}
