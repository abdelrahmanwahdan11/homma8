import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../localization/app_localizations.dart';

class AppState extends ChangeNotifier {
  AppState();

  static const _guestKey = 'sp_guest_session_v1';
  static const _favoritesKey = 'sp_favorites_v1';
  static const _filtersKey = 'sp_filters_v1';
  static const _draftAuctionKey = 'sp_draft_auction_v1';
  static const _draftWantedKey = 'sp_draft_wanted_v1';
  static const _onboardingDoneKey = 'sp_onboarding_done_v1';
  static const _themeModeKey = 'sp_theme_mode_v1';
  static const _lastLanguageKey = 'sp_last_language_v1';

  late SharedPreferences _prefs;
  bool _initialized = false;

  bool _guestSession = false;
  bool _onboardingDone = false;
  ThemeMode _themeMode = ThemeMode.system;
  Locale? _localeOverride;

  final ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(0);
  final ValueNotifier<Set<String>> favoritesNotifier = ValueNotifier<Set<String>>(<String>{});

  bool get isInitialized => _initialized;
  bool get isGuest => _guestSession;
  bool get onboardingDone => _onboardingDone;
  ThemeMode get themeMode => _themeMode;
  Locale? get localeOverride => _localeOverride;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _guestSession = _prefs.getBool(_guestKey) ?? false;
    _onboardingDone = _prefs.getBool(_onboardingDoneKey) ?? false;
    _themeMode = ThemeMode.values[_prefs.getInt(_themeModeKey) ?? ThemeMode.system.index];
    final langCode = _prefs.getString(_lastLanguageKey);
    if (langCode != null) {
      _localeOverride = AppLocalizations.supportedLocales
          .firstWhere((locale) => locale.languageCode == langCode, orElse: () => AppLocalizations.supportedLocales.first);
    }
    final favorites = _prefs.getStringList(_favoritesKey) ?? <String>[];
    favoritesNotifier.value = favorites.toSet();
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _onboardingDone = true;
    await _prefs.setBool(_onboardingDoneKey, true);
    notifyListeners();
  }

  Future<void> signInAsGuest() async {
    _guestSession = true;
    await _prefs.setBool(_guestKey, true);
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final current = favoritesNotifier.value;
    final updated = current.contains(id)
        ? (current..remove(id))
        : (current..add(id));
    favoritesNotifier.value = {...updated};
    await _prefs.setStringList(_favoritesKey, favoritesNotifier.value.toList());
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt(_themeModeKey, mode.index);
    notifyListeners();
  }

  Future<void> updateLocale(Locale? locale) async {
    _localeOverride = locale;
    if (locale == null) {
      await _prefs.remove(_lastLanguageKey);
    } else {
      await _prefs.setString(_lastLanguageKey, locale.languageCode);
    }
    notifyListeners();
  }

  Map<String, dynamic> readDraft(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return <String, dynamic>{};
    return _decode(raw);
  }

  Future<void> saveDraft(String key, Map<String, dynamic> data) async {
    await _prefs.setString(key, _encode(data));
  }

  Future<void> clearDraft(String key) async {
    await _prefs.remove(key);
  }
}

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({required super.notifier, required super.child, super.key});

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    assert(scope != null, 'AppStateScope not found in context');
    return scope!.notifier!;
  }
}

Map<String, dynamic> _decode(String source) {
  if (source.isEmpty) return <String, dynamic>{};
  final result = jsonDecode(source);
  if (result is Map<String, dynamic>) {
    return result;
  }
  return <String, dynamic>{};
}

String _encode(Map<String, dynamic> data) => jsonEncode(data);
