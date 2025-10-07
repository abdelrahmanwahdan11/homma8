import 'package:get/get.dart';

import '../../../data/services/mock_data_service.dart';
import '../controllers/bids_controller.dart';

class BidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BidsController(Get.find<MockDataService>()));
  }
}
