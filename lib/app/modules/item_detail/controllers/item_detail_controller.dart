import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/models/auction_item.dart';
import '../../../data/models/bid.dart';
import '../../../data/services/mock_data_service.dart';

class ItemDetailController extends GetxController {
  ItemDetailController(this._dataService);

  final MockDataService _dataService;

  final Rxn<AuctionItem> item = Rxn<AuctionItem>();
  final bidController = TextEditingController();
  final bids = <Bid>[].obs;

  late final String itemId;

  @override
  void onInit() {
    super.onInit();
    itemId = Get.parameters['id'] ?? Get.arguments as String? ?? '';
    _load();
  }

  @override
  void onClose() {
    bidController.dispose();
    super.onClose();
  }

  void _load() {
    final found = _dataService.items.firstWhereOrNull((element) => element.id == itemId);
    if (found != null) {
      item.value = found;
      bids.assignAll(_dataService.bids.where((b) => b.itemId == itemId));
    }
  }

  void addStep(double percent) {
    final itemData = item.value;
    if (itemData == null) return;
    final next = itemData.currentBid * (1 + percent);
    bidController.text = next.toStringAsFixed(0);
  }

  void placeBid() {
    final itemData = item.value;
    if (itemData == null) return;
    final amount = double.tryParse(bidController.text);
    if (amount == null) {
      Get.snackbar('app_name'.tr, 'validation_required'.tr);
      return;
    }
    if (amount <= itemData.currentBid || amount > itemData.currentBid * 1.25) {
      Get.snackbar('app_name'.tr, 'validation_price_range'.tr);
      return;
    }
    final updated = itemData.copyWith(currentBid: amount);
    final index = _dataService.items.indexWhere((element) => element.id == itemData.id);
    if (index != -1) {
      _dataService.items[index] = updated;
      item.value = updated;
    }
    final bid = Bid(
      itemId: itemId,
      amount: amount,
      time: DateTime.now(),
      status: 'pending',
    );
    _dataService.bids.add(bid);
    bids.insert(0, bid);
    Get.snackbar('app_name'.tr, 'bid_confirm'.tr);
  }
}
