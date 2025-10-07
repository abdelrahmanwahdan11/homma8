import 'package:get/get.dart';

import '../controllers/sell_buy_controller.dart';

class SellBuyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(SellBuyController.new);
  }
}
