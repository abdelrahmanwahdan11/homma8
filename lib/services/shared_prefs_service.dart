import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models.dart';
import '../core/app_state.dart';

class SharedPrefsService {
  SharedPrefsService._(this._prefs);

  final SharedPreferences _prefs;

  static SharedPrefsService? _instance;

  static Future<SharedPrefsService> getInstance() async {
    if (_instance != null) {
      return _instance!;
    }
    final prefs = await SharedPreferences.getInstance();
    _instance = SharedPrefsService._(prefs);
    return _instance!;
  }

  ThemeMode getThemeMode() {
    final value = _prefs.getString('theme_mode');
    switch (value) {
      case 'dark':
        return ThemeMode.dark;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.light;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) =>
      _prefs.setString('theme_mode', mode.name);

  Locale getLocale() {
    final code = _prefs.getString('app_language') ?? 'ar';
    return Locale(code);
  }

  Future<void> setLocale(Locale locale) =>
      _prefs.setString('app_language', locale.languageCode);

  UserSession? getSession() {
    final raw = _prefs.getString('user_session');
    if (raw == null || raw.isEmpty) return null;
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return UserSession.fromJson(data);
  }

  Future<void> setSession(UserSession? session) {
    if (session == null) {
      return _prefs.remove('user_session');
    }
    return _prefs.setString('user_session', jsonEncode(session.toJson()));
  }

  Set<String> getFavorites() {
    final items = _prefs.getStringList('favorites') ?? <String>[];
    return items.toSet();
  }

  Future<void> setFavorites(Set<String> favorites) =>
      _prefs.setStringList('favorites', favorites.toList());

  List<WantedRequest> getWantedRequests() {
    final raw = _prefs.getStringList('wanted_requests') ?? <String>[];
    return raw
        .map((item) => WantedRequest.fromJson(
            jsonDecode(item) as Map<String, dynamic>))
        .toList();
  }

  Future<void> setWantedRequests(List<WantedRequest> requests) {
    final encoded =
        requests.map((item) => jsonEncode(item.toJson())).toList();
    return _prefs.setStringList('wanted_requests', encoded);
  }

  bool getNotificationsEnabled() =>
      _prefs.getBool('notifications') ?? true;

  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool('notifications', value);

  String getHomeFilter() =>
      _prefs.getString('home_filter') ?? 'nearest';

  Future<void> setHomeFilter(String filter) =>
      _prefs.setString('home_filter', filter);

  double getHomeScrollOffset() =>
      _prefs.getDouble('home_scroll_offset') ?? 0;

  Future<void> setHomeScrollOffset(double offset) =>
      _prefs.setDouble('home_scroll_offset', offset);

  String getLastRoute() =>
      _prefs.getString('last_route') ?? AppRoutes.onboarding;

  Future<void> setLastRoute(String route) =>
      _prefs.setString('last_route', route);
}
