import 'package:get/get.dart';

import '../../../data/services/settings_service.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SettingsController(Get.find<SettingsService>()));
  }
}
