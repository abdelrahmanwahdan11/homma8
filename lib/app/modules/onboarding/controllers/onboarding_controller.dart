import 'package:card_swiper/card_swiper.dart';
import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';
import '../../../routes/app_routes.dart';

class OnboardingController extends GetxController {
  final swiperController = SwiperController();
  final pageIndex = 0.obs;

  void onPageChanged(int index) => pageIndex.value = index;

  void goToNext(int total) {
    if (pageIndex.value >= total - 1) {
      complete();
      return;
    }
    swiperController.next(animation: true);
  }

  Future<void> complete() async {
    final settings = Get.find<SettingsService>();
    await settings.setFirstRun(false);
    Get.offAllNamed(Routes.auth);
  }

  void skip() => complete();

  @override
  void onClose() {
    swiperController.dispose();
    super.onClose();
  }
}
