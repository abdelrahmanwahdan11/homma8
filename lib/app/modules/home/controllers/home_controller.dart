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
  final spotlightPageController = PageController(viewportFraction: 0.82);
  final query = ''.obs;
  final selectedCategory = 'all'.obs;
  final selectedIndex = 0.obs;
  final useSwiper = false.obs;
  final gridDensity = 'comfortable'.obs;
  final statusFilter = 'all'.obs;
  final sortOption = 'endingSoon'.obs;
  final compareSelection = <String>[].obs;
  final recentlyViewed = <AuctionItem>[].obs;

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
    spotlightPageController.dispose();
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
    final filteredByStatus = items.where((item) {
      return switch (statusFilter.value) {
        'live' => item.isLive,
        'upcoming' => item.isUpcoming,
        'ended' => item.isEnded,
        _ => true,
      };
    }).toList();

    filteredByStatus.sort((a, b) {
      switch (sortOption.value) {
        case 'nearest':
          return a.distanceKm.compareTo(b.distanceKm);
        case 'priceLowHigh':
          return a.currentBid.compareTo(b.currentBid);
        case 'priceHighLow':
          return b.currentBid.compareTo(a.currentBid);
        case 'mostViewed':
          return b.views.compareTo(a.views);
        default:
          return a.endAt.compareTo(b.endAt);
      }
    });
    return filteredByStatus;
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

  void changeStatus(String status) {
    statusFilter.value = status;
    refreshItems();
  }

  void changeSort(String option) {
    sortOption.value = option;
    refreshItems();
  }

  void changeDensity(String density) {
    gridDensity.value = density;
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

  void toggleWatching(AuctionItem item) {
    final idx = _dataService.items.indexWhere((element) => element.id == item.id);
    if (idx == -1) return;
    final updated = _dataService.items[idx].copyWith(watching: !item.watching);
    _dataService.items[idx] = updated;
    refreshItems();
  }

  void openDetail(AuctionItem item) {
    highlightedItem.value = item;
    recentlyViewed.removeWhere((element) => element.id == item.id);
    recentlyViewed.insert(0, item);
    if (recentlyViewed.length > 10) {
      recentlyViewed.removeRange(10, recentlyViewed.length);
    }
    Get.toNamed('${Routes.item}/${item.id}');
  }

  void saveFilterPreset() {
    _settingsService.saveFilterPreset({
      'query': query.value,
      'category': selectedCategory.value,
    });
    Get.snackbar('app_name'.tr, 'home_saved_filters'.tr);
  }

  void toggleCompare(AuctionItem item) {
    if (compareSelection.contains(item.id)) {
      compareSelection.remove(item.id);
    } else if (compareSelection.length < 3) {
      compareSelection.add(item.id);
    }
  }

  List<AuctionItem> get selectedComparisons => compareSelection
      .map((id) => _dataService.items.firstWhere((element) => element.id == id))
      .toList();

  void clearComparisons() => compareSelection.clear();

  void scheduleReminder(AuctionItem item) {
    final minutes = item.endAt.difference(DateTime.now()).inMinutes;
    final safeMinutes = minutes.clamp(1, 1440).toInt();
    Get.snackbar(
      'app_name'.tr,
      'reminder_scheduled'.trParams({
        'title': item.title,
        'minutes': safeMinutes.toString(),
      }),
    );
  }
}
