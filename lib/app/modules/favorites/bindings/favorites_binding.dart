import 'package:get/get.dart';

import '../../../data/services/mock_data_service.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FavoritesController(Get.find<MockDataService>()));
  }
}
