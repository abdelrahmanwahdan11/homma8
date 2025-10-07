import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: const [Color(0xFFE8B2D8), Color(0xFFF4C77B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.gavel_rounded, color: Colors.white, size: 42),
                const Spacer(),
                Text('splash_title'.tr,
                    style: theme.textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                    )),
                const SizedBox(height: 32),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(3, (index) {
                      return Obx(
                        () => AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: controller.progress.value > index * 0.33 ? 1 : 0.4,
                          child: Container(
                            height: 12,
                            width: 32,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(999),
                              color: theme.colorScheme.onPrimary.withOpacity(0.9),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton.icon(
                  onPressed: () => controller.progress.value = 1,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.9),
                    foregroundColor: theme.colorScheme.onPrimary,
                  ),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: Text('action_start'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
