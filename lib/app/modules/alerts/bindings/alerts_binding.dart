import 'package:get/get.dart';

import '../../../data/services/mock_data_service.dart';
import '../controllers/alerts_controller.dart';

class AlertsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AlertsController(Get.find<MockDataService>()));
  }
}
