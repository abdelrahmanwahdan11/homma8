import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final pageIndex = 0.obs;

  void onPageChanged(int index) => pageIndex.value = index;

  void goToNext(int total) {
    if (pageIndex.value >= total - 1) {
      complete();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> complete() async {
    final settings = Get.find<SettingsService>();
    await settings.setFirstRun(false);
    Get.offAllNamed(Routes.auth);
  }

  void skip() => complete();

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
