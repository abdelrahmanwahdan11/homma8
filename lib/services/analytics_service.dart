import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/models.dart';
import 'shared_prefs_service.dart';

class AnalyticsService {
  AnalyticsService._(this._prefs)
      : summaryNotifier =
            ValueNotifier<AnalyticsSummary>(_prefs.getAnalyticsSummary());

  final SharedPrefsService _prefs;
  final ValueNotifier<AnalyticsSummary> summaryNotifier;

  static AnalyticsService? _instance;

  static void configure(SharedPrefsService prefs) {
    _instance ??= AnalyticsService._(prefs);
  }

  static AnalyticsService get instance {
    assert(_instance != null, 'AnalyticsService.configure must be called before accessing instance.');
    return _instance!;
  }

  Future<void> trackPageView(String pageId) async {
    final updated = summaryNotifier.value.recordPageView(pageId);
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }

  Future<void> trackTimeSpent({required String pageId, required Duration duration}) async {
    final updated = summaryNotifier.value.recordTimeSpent(pageId: pageId, duration: duration);
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }

  Future<void> trackBidPlaced({required String productId, required double amount}) async {
    final updated = summaryNotifier.value.recordBid(productId: productId, amount: amount);
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }

  Future<void> trackFavoriteToggle({required String productId}) async {
    final updated = summaryNotifier.value.recordFavorite(productId);
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }

  Future<void> trackWantedCreated() async {
    final updated = summaryNotifier.value.recordWanted();
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }

  Future<void> trackLanguageSwitch() async {
    final updated = summaryNotifier.value.recordLanguageSwitch();
    summaryNotifier.value = updated;
    await _prefs.setAnalyticsSummary(updated);
  }
}
