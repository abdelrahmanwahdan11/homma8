import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final slides = [
      _OnboardingSlide(
        gradient: [
          theme.colorScheme.primary,
          theme.colorScheme.secondary,
        ],
        icon: Icons.travel_explore_rounded,
        title: 'onboarding_1_title'.tr,
        caption: 'onboarding_1_caption'.tr,
      ),
      _OnboardingSlide(
        gradient: [
          theme.colorScheme.secondary,
          theme.colorScheme.tertiary,
        ],
        icon: Icons.gavel_rounded,
        title: 'onboarding_2_title'.tr,
        caption: 'onboarding_2_caption'.tr,
      ),
      _OnboardingSlide(
        gradient: [
          theme.colorScheme.primary,
          theme.colorScheme.tertiary,
        ],
        icon: Icons.auto_awesome_rounded,
        title: 'onboarding_3_title'.tr,
        caption: 'onboarding_3_caption'.tr,
      ),
    ];
    final glassBase = theme.colorScheme.surface.withOpacity(0.72);
    final glassStroke = theme.colorScheme.onSurface.withOpacity(0.08);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: controller.pageController,
            itemCount: slides.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              final slide = slides[index];
              return DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: slide.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -80,
                      top: -20,
                      child: Icon(
                        slide.icon,
                        size: MediaQuery.of(context).size.shortestSide * 1.2,
                        color: theme.colorScheme.onPrimary.withOpacity(0.08),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                            child: Container(
                              padding: const EdgeInsets.all(28),
                              decoration: BoxDecoration(
                                color: glassBase,
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: glassStroke),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    slide.icon,
                                    color: theme.colorScheme.primary,
                                    size: 32,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    slide.title,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    slide.caption,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurface.withOpacity(0.72),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var i = 0; i < slides.length; i++)
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: controller.pageIndex.value == i ? 18 : 8,
                      decoration: BoxDecoration(
                        color: controller.pageIndex.value == i
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onPrimary.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: controller.skip,
                    child: Text('action_skip'.tr),
                  ),
                  const Spacer(),
                  Obx(
                    () => FilledButton(
                      onPressed: controller.pageIndex.value == slides.length - 1
                          ? controller.complete
                          : () => controller.goToNext(slides.length),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.onPrimary,
                        foregroundColor: theme.colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Text(
                        controller.pageIndex.value == slides.length - 1
                            ? 'action_get_started'.tr
                            : 'action_next'.tr,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.gradient,
    required this.icon,
    required this.title,
    required this.caption,
  });

  final List<Color> gradient;
  final IconData icon;
  final String title;
  final String caption;
}
