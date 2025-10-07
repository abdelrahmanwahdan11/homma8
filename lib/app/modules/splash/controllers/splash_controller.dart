import 'dart:async';

import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  final progress = 0.0.obs;

  late final Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(const Duration(milliseconds: 120), (timer) {
      progress.value = (progress.value + 0.2).clamp(0, 1);
    });
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    final settings = Get.find<SettingsService>();
    if (settings.isFirstRun.value) {
      Get.offAllNamed(Routes.onboarding);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  @override
  void onClose() {
    _timer.cancel();
    super.onClose();
  }
}
