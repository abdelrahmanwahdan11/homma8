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

  final SharedPreferences _prefs;

  final themeMode = ThemeMode.system.obs;
  final locale = const Locale('en').obs;
  final isFirstRun = true.obs;
  final recentSearches = <String>[].obs;
  final savedFilters = <Map<String, dynamic>>[].obs;

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

  Future<void> saveFilterPreset(Map<String, dynamic> preset) async {
    savedFilters.add(preset);
    final serialized = savedFilters
        .map((e) => GetUtils.jsonEncode(e))
        .toList(growable: false);
    await _prefs.setStringList(_savedFiltersKey, serialized);
  }
}
