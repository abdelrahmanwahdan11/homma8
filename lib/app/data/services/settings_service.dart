import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService extends GetxService {
  SettingsService(this._prefs);

  static const _themeKey = 'theme';
  static const _localeKey = 'locale';
  static const _firstRunKey = 'firstRun';
  static const _recentSearchesKey = 'recentSearches';
  static const _savedFiltersKey = 'savedFilters';
  static const _distanceUnitKey = 'distanceUnit';
  static const _currencyKey = 'currency';
  static const _featureFlagsKey = 'featureFlags';

  static const Map<String, bool> _defaultFeatureFlags = {
    'feature_recently_viewed': true,
    'feature_compare_items': true,
    'feature_hot_badges': true,
    'feature_ai_insights_modes': true,
    'feature_watchlist_banner': true,
    'feature_price_projection': false,
    'feature_distance_unit_toggle': true,
    'feature_currency_conversion': true,
    'feature_grid_density': true,
    'feature_status_filters': true,
    'feature_quick_bid_steps': true,
    'feature_bid_confirmation_sheet': true,
    'feature_outbid_alert': true,
    'feature_saved_filters': true,
    'feature_recent_searches': true,
    'feature_keyboard_shortcuts': false,
    'feature_reminder_scheduler': true,
    'feature_safety_tips': true,
    'feature_screenshot_card': false,
    'feature_split_view': true,
  };

  static const Map<String, double> _currencyRates = {
    'AED': 1.0,
    'USD': 0.27,
    'EUR': 0.25,
  };

  final SharedPreferences _prefs;

  final themeMode = ThemeMode.system.obs;
  final locale = const Locale('en').obs;
  final isFirstRun = true.obs;
  final recentSearches = <String>[].obs;
  final savedFilters = <Map<String, dynamic>>[].obs;
  final distanceUnit = 'km'.obs;
  final currency = 'AED'.obs;
  final featureToggles = <String, bool>{}.obs;

  Future<SettingsService> init() async {
    final themeString = _prefs.getString(_themeKey);
    switch (themeString) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }

    final localeCode = _prefs.getString(_localeKey);
    if (localeCode != null) {
      final pieces = localeCode.split('_');
      locale.value = Locale(pieces.first, pieces.length > 1 ? pieces[1] : null);
    }

    isFirstRun.value = _prefs.getBool(_firstRunKey) ?? true;
    recentSearches.assignAll(_prefs.getStringList(_recentSearchesKey) ?? []);
    final rawSaved = _prefs.getStringList(_savedFiltersKey) ?? [];
    savedFilters.assignAll(rawSaved.map((e) => Map<String, dynamic>.from(GetUtils.jsonDecode(e))));

    distanceUnit.value = _prefs.getString(_distanceUnitKey) ?? 'km';
    currency.value = _prefs.getString(_currencyKey) ?? 'AED';

    final rawFeatures = _prefs.getString(_featureFlagsKey);
    final decoded = rawFeatures == null
        ? <String, dynamic>{}
        : Map<String, dynamic>.from(jsonDecode(rawFeatures) as Map<String, dynamic>);
    final merged = Map<String, bool>.from(_defaultFeatureFlags);
    for (final entry in decoded.entries) {
      merged[entry.key] = entry.value as bool;
    }
    featureToggles.assignAll(merged);
    return this;
  }

  Future<void> setFirstRun(bool value) async {
    isFirstRun.value = value;
    await _prefs.setBool(_firstRunKey, value);
  }

  Future<void> updateTheme(ThemeMode mode) async {
    themeMode.value = mode;
    final serialized = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await _prefs.setString(_themeKey, serialized);
  }

  Future<void> updateLocale(Locale locale) async {
    this.locale.value = locale;
    await _prefs.setString(
      _localeKey,
      [locale.languageCode, if (locale.countryCode != null) locale.countryCode!]
          .join('_'),
    );
  }

  Future<void> addRecentSearch(String query) async {
    if (query.isEmpty) return;
    recentSearches.remove(query);
    recentSearches.insert(0, query);
    if (recentSearches.length > 10) {
      recentSearches.removeRange(10, recentSearches.length);
    }
    await _prefs.setStringList(_recentSearchesKey, recentSearches);
  }

  Future<void> clearRecentSearches() async {
    recentSearches.clear();
    await _prefs.remove(_recentSearchesKey);
  }

  Future<void> removeRecentSearch(String query) async {
    recentSearches.remove(query);
    await _prefs.setStringList(_recentSearchesKey, recentSearches);
  }

  Future<void> saveFilterPreset(Map<String, dynamic> preset) async {
    savedFilters.add(preset);
    final serialized = savedFilters
        .map((e) => GetUtils.jsonEncode(e))
        .toList(growable: false);
    await _prefs.setStringList(_savedFiltersKey, serialized);
  }

  Future<void> updateDistanceUnit(String unit) async {
    distanceUnit.value = unit;
    await _prefs.setString(_distanceUnitKey, unit);
  }

  Future<void> updateCurrency(String value) async {
    currency.value = value;
    await _prefs.setString(_currencyKey, value);
  }

  Future<void> toggleFeature(String key, bool enabled) async {
    featureToggles[key] = enabled;
    final encoded = jsonEncode(featureToggles);
    await _prefs.setString(_featureFlagsKey, encoded);
  }

  String formatDistance(double km) {
    if (distanceUnit.value == 'mi') {
      final miles = km * 0.621371;
      return '${miles.toStringAsFixed(1)} mi';
    }
    return '${km.toStringAsFixed(1)} km';
  }

  String formatPrice(double amount, String itemCurrency) {
    final target = currency.value;
    final baseRate = _currencyRates[itemCurrency] ?? 1.0;
    final targetRate = _currencyRates[target] ?? 1.0;
    final converted = amount * targetRate / baseRate;
    return '$target ${converted.toStringAsFixed(0)}';
  }
}
