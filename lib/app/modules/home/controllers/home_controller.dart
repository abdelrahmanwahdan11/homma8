import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../data/models/auction_item.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/services/settings_service.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_routes.dart';

class HomeController extends GetxController {
  HomeController(this._dataService, this._settingsService);

  final MockDataService _dataService;
  final SettingsService _settingsService;

  final PagingController<int, AuctionItem> pagingController =
      PagingController(firstPageKey: 0);
  final perPage = 12;

  final searchController = TextEditingController();
  final query = ''.obs;
  final selectedCategory = 'all'.obs;
  final selectedIndex = 0.obs;
  final useSwiper = false.obs;
  final gridDensity = 'comfortable'.obs;

  final Rxn<AuctionItem> highlightedItem = Rxn<AuctionItem>();

  @override
  void onInit() {
    super.onInit();
    pagingController.addPageRequestListener(_fetchPage);
    debounce(query, (_) => refreshItems(), time: const Duration(milliseconds: 350));
  }

  @override
  void onClose() {
    pagingController.dispose();
    searchController.dispose();
    super.onClose();
  }

  void _fetchPage(int pageKey) {
    final filtered = _filteredItems();
    if (pageKey >= filtered.length) {
      pagingController.appendLastPage([]);
      return;
    }
    final endIndex = min(pageKey + perPage, filtered.length);
    final pageItems = filtered.sublist(pageKey, endIndex);
    if (endIndex >= filtered.length) {
      pagingController.appendLastPage(pageItems);
    } else {
      pagingController.appendPage(pageItems, endIndex);
    }
  }

  List<AuctionItem> _filteredItems() {
    final items = _dataService.filter(
      query: query.value,
      category: selectedCategory.value == 'all' ? null : selectedCategory.value,
    );
    items.sort((a, b) => a.endAt.compareTo(b.endAt));
    return items;
  }

  void onSearchChanged(String value) {
    query.value = value;
  }

  void submitSearch(String value) {
    query.value = value;
    _settingsService.addRecentSearch(value);
    refreshItems();
  }

  void refreshItems() {
    pagingController.refresh();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    refreshItems();
  }

  void toggleViewMode() {
    useSwiper.toggle();
  }

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  void toggleFavorite(AuctionItem item) {
    final idx = _dataService.items.indexWhere((element) => element.id == item.id);
    if (idx == -1) return;
    final updated = _dataService.items[idx].copyWith(isFavorite: !item.isFavorite);
    _dataService.items[idx] = updated;
    refreshItems();
  }

  void openDetail(AuctionItem item) {
    highlightedItem.value = item;
    Get.toNamed('${Routes.item}/${item.id}');
  }

  void saveFilterPreset() {
    _settingsService.saveFilterPreset({
      'query': query.value,
      'category': selectedCategory.value,
    });
    Get.snackbar('app_name'.tr, 'home_saved_filters'.tr);
  }
}
