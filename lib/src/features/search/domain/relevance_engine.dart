import 'dart:math' as math;

import '../../../models/models.dart';

class RelevanceSnapshot {
  const RelevanceSnapshot({
    required this.favoriteCategories,
    required this.categoryAffinity,
    required this.itemAffinity,
    required this.priceMin,
    required this.priceMax,
    required this.averageBid,
  });

  final Set<String> favoriteCategories;
  final Map<String, double> categoryAffinity;
  final Map<String, double> itemAffinity;
  final double? priceMin;
  final double? priceMax;
  final double? averageBid;

  double categoryScore(String category) {
    final base = favoriteCategories.contains(category) ? 1.0 : 0.0;
    final affinity = categoryAffinity[category] ?? 0;
    return math.min(1.5, base + affinity);
  }

  double interactionScore(String itemId) {
    return math.min(1.0, (itemAffinity[itemId] ?? 0) / 10);
  }
}

class RelevanceEngine {
  final Map<String, double> _categoryAffinity = <String, double>{};
  final Map<String, double> _itemAffinity = <String, double>{};
  double? _averageBid;

  void seed({
    required UserPrefs prefs,
    required Iterable<Favorite> favorites,
    required Iterable<Bid> bids,
    required Iterable<SellListing> listings,
    required Iterable<Item> items,
  }) {
    _categoryAffinity.clear();
    _itemAffinity.clear();
    if (prefs.favCategories.isNotEmpty) {
      for (final category in prefs.favCategories) {
        _categoryAffinity[category] = (_categoryAffinity[category] ?? 0) + 0.6;
      }
    }

    for (final favorite in favorites) {
      final item = items.firstWhere(
        (element) => element.id == favorite.itemId,
        orElse: () => items.first,
      );
      recordFavorite(item);
    }

    if (bids.isNotEmpty) {
      final total = bids.fold<double>(0, (acc, bid) => acc + bid.amount);
      _averageBid = total / bids.length;
      for (final bid in bids) {
        final listing = listings.firstWhere(
          (element) => element.id == bid.listingId,
          orElse: () => listings.isEmpty
              ? SellListing(
                  id: 'placeholder',
                  itemId: items.first.id,
                  sellerId: 'placeholder',
                  askPrice: 0,
                  status: 'active',
                  createdAt: DateTime.now(),
                  endAt: DateTime.now(),
                  currentBid: bid.amount,
                  bidCount: 0,
                )
              : listings.first,
        );
        final item = items.firstWhere(
          (element) => element.id == listing.itemId,
          orElse: () => items.first,
        );
        recordBid(listing, bid.amount, item);
      }
    }
  }

  void recordView(Item item) {
    _categoryAffinity[item.category] = (_categoryAffinity[item.category] ?? 0) + 0.15;
    _itemAffinity[item.id] = (_itemAffinity[item.id] ?? 0) + 0.5;
  }

  void recordFavorite(Item item) {
    _categoryAffinity[item.category] = (_categoryAffinity[item.category] ?? 0) + 0.4;
    _itemAffinity[item.id] = (_itemAffinity[item.id] ?? 0) + 1.5;
  }

  void recordBid(SellListing listing, double amount, Item item) {
    recordView(item);
    _itemAffinity[item.id] = (_itemAffinity[item.id] ?? 0) + 2.0;
    _categoryAffinity[item.category] = (_categoryAffinity[item.category] ?? 0) + 0.8;
    _averageBid = _averageBid == null ? amount : (_averageBid! * 0.7 + amount * 0.3);
  }

  RelevanceSnapshot snapshot(UserPrefs prefs) {
    double? min = prefs.priceMin;
    double? max = prefs.priceMax;
    if (min == null || max == null) {
      if (_averageBid != null) {
        min = _averageBid! * 0.6;
        max = _averageBid! * 1.4;
      }
    }
    return RelevanceSnapshot(
      favoriteCategories: prefs.favCategories.toSet(),
      categoryAffinity: Map<String, double>.from(_categoryAffinity),
      itemAffinity: Map<String, double>.from(_itemAffinity),
      priceMin: min,
      priceMax: max,
      averageBid: _averageBid,
    );
  }
}
