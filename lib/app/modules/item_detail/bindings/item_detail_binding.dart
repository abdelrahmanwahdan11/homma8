import 'package:get/get.dart';

import '../../../data/services/mock_data_service.dart';
import '../controllers/item_detail_controller.dart';

class ItemDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemDetailController(Get.find<MockDataService>()));
  }
}
