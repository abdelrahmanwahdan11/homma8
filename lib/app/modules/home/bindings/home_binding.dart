import 'package:get/get.dart';

import '../../../data/services/mock_data_service.dart';
import '../../../data/services/settings_service.dart';
import '../../alerts/controllers/alerts_controller.dart';
import '../../bids/controllers/bids_controller.dart';
import '../../favorites/controllers/favorites_controller.dart';
import '../../sell_buy/controllers/sell_buy_controller.dart';
import '../../settings/controllers/settings_controller.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(Get.find<MockDataService>(), Get.find<SettingsService>()),
      fenix: true,
    );
  }
}
