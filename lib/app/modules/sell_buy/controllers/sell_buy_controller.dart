import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/form_validators.dart';

class SellBuyController extends GetxController {
  final sellFormKey = GlobalKey<FormState>();
  final wantFormKey = GlobalKey<FormState>();

  final sellTitle = TextEditingController();
  final sellCategory = ''.obs;
  final sellLocation = TextEditingController();
  final sellStartPrice = TextEditingController();
  final sellBuyNowPrice = TextEditingController();

  final wantTitle = TextEditingController();
  final wantCategory = ''.obs;
  final wantMinPrice = TextEditingController();
  final wantMaxPrice = TextEditingController();
  final wantLocation = TextEditingController();

  @override
  void onClose() {
    sellTitle.dispose();
    sellLocation.dispose();
    sellStartPrice.dispose();
    sellBuyNowPrice.dispose();
    wantTitle.dispose();
    wantMinPrice.dispose();
    wantMaxPrice.dispose();
    wantLocation.dispose();
    super.onClose();
  }

  void submitSell() {
    if (sellFormKey.currentState?.validate() ?? false) {
      Get.snackbar('app_name'.tr, 'nav_sell_buy'.tr);
    }
  }

  void submitWant() {
    if (!(wantFormKey.currentState?.validate() ?? false)) return;
    final min = double.tryParse(wantMinPrice.text) ?? 0;
    final max = double.tryParse(wantMaxPrice.text) ?? 0;
    final error = FormValidators.priceRange(min, max);
    if (error != null) {
      Get.snackbar('app_name'.tr, error.tr);
      return;
    }
    Get.snackbar('app_name'.tr, 'nav_sell_buy'.tr);
  }
}
