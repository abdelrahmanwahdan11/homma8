import 'package:flutter/material.dart';

class OnboardingStep {
  const OnboardingStep({
    required this.icon,
    required this.titleKey,
    required this.subtitleKey,
  });

  final IconData icon;
  final String titleKey;
  final String subtitleKey;
}
