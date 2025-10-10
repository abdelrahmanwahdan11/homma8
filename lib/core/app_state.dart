import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import '../data/models.dart';
import '../services/analytics_service.dart';
import '../services/shared_prefs_service.dart';

class AppState extends StatefulWidget {
  const AppState({required this.prefs, required this.child, super.key});

  final SharedPrefsService prefs;
  final Widget child;

  static _AppStateScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_AppStateScope>();
    assert(scope != null, 'AppState not found in context');
    return scope!;
  }

  @override
  State<AppState> createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  late final ValueNotifier<ThemeMode> _themeNotifier;
  late final ValueNotifier<Locale> _localeNotifier;
  late final ValueNotifier<UserSession?> _sessionNotifier;
  late final ValueNotifier<Set<String>> _favoritesNotifier;
  late final ValueNotifier<List<WantedRequest>> _wantedNotifier;
  late final ValueNotifier<bool> _notificationsNotifier;
  late final ValueNotifier<String> _homeFilterNotifier;
  late final ValueNotifier<double> _homeScrollOffsetNotifier;
  late final ValueNotifier<String> _lastRouteNotifier;
  late final ValueNotifier<List<String>> _searchHistoryNotifier;
  late final ValueNotifier<bool> _themeAnimationNotifier;
  late final AnalyticsService _analyticsService;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final prefs = widget.prefs;
    _analyticsService = AnalyticsService.instance;
    _themeNotifier = ValueNotifier(prefs.getThemeMode());
    _localeNotifier = ValueNotifier(prefs.getLocale());
    _sessionNotifier = ValueNotifier<UserSession?>(prefs.getSession());
    _favoritesNotifier = ValueNotifier(prefs.getFavorites());
    _wantedNotifier = ValueNotifier(prefs.getWantedRequests());
    _notificationsNotifier = ValueNotifier(prefs.getNotificationsEnabled());
    _homeFilterNotifier = ValueNotifier(prefs.getHomeFilter());
    _homeScrollOffsetNotifier = ValueNotifier(prefs.getHomeScrollOffset());
    _lastRouteNotifier = ValueNotifier(prefs.getLastRoute());
    _searchHistoryNotifier = ValueNotifier(prefs.getSearchHistory());
    _themeAnimationNotifier = ValueNotifier(prefs.getThemeAnimationEnabled());
    _initialized = true;
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _localeNotifier.dispose();
    _sessionNotifier.dispose();
    _favoritesNotifier.dispose();
    _wantedNotifier.dispose();
    _notificationsNotifier.dispose();
    _homeFilterNotifier.dispose();
    _homeScrollOffsetNotifier.dispose();
    _lastRouteNotifier.dispose();
    _searchHistoryNotifier.dispose();
    _themeAnimationNotifier.dispose();
    super.dispose();
  }

  bool get initialized => _initialized;

  ThemeMode get themeMode => _themeNotifier.value;

  Locale get locale => _localeNotifier.value;

  UserSession? get session => _sessionNotifier.value;

  Set<String> get favorites => _favoritesNotifier.value;

  List<WantedRequest> get wantedRequests => List.unmodifiable(_wantedNotifier.value);

  bool get notificationsEnabled => _notificationsNotifier.value;

  String get homeFilter => _homeFilterNotifier.value;

  double get homeScrollOffset => _homeScrollOffsetNotifier.value;

  String get lastRoute => _lastRouteNotifier.value;

  void setThemeMode(ThemeMode mode) {
    if (_themeNotifier.value == mode) return;
    _themeNotifier.value = mode;
    widget.prefs.setThemeMode(mode);
  }

  void setLocale(Locale locale) {
    if (_localeNotifier.value == locale) return;
    _localeNotifier.value = locale;
    widget.prefs.setLocale(locale);
    unawaited(_analyticsService.trackLanguageSwitch());
  }

  void setSession(UserSession? session) {
    _sessionNotifier.value = session;
    widget.prefs.setSession(session);
  }

  void toggleFavorite(String productId) {
    final favorites = SplayTreeSet<String>.from(_favoritesNotifier.value);
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    _favoritesNotifier.value = favorites;
    widget.prefs.setFavorites(favorites);
    unawaited(
        _analyticsService.trackFavoriteToggle(productId: productId));
  }

  bool isFavorite(String productId) => _favoritesNotifier.value.contains(productId);

  void addWantedRequest(WantedRequest request) {
    final updated = [..._wantedNotifier.value, request];
    _wantedNotifier.value = updated;
    widget.prefs.setWantedRequests(updated);
    unawaited(_analyticsService.trackWantedCreated());
  }

  void removeWantedRequest(String id) {
    final updated = _wantedNotifier.value.where((req) => req.id != id).toList();
    _wantedNotifier.value = updated;
    widget.prefs.setWantedRequests(updated);
  }

  void setNotificationsEnabled(bool value) {
    _notificationsNotifier.value = value;
    widget.prefs.setNotificationsEnabled(value);
  }

  void setHomeFilter(String filter) {
    _homeFilterNotifier.value = filter;
    widget.prefs.setHomeFilter(filter);
  }

  void setHomeScrollOffset(double offset) {
    _homeScrollOffsetNotifier.value = offset;
    widget.prefs.setHomeScrollOffset(offset);
  }

  void setLastRoute(String route) {
    _lastRouteNotifier.value = route;
    widget.prefs.setLastRoute(route);
  }

  void addSearchQuery(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    final history = [..._searchHistoryNotifier.value];
    history.remove(trimmed);
    history.insert(0, trimmed);
    if (history.length > 8) {
      history.removeRange(8, history.length);
    }
    _searchHistoryNotifier.value = history;
    widget.prefs.setSearchHistory(history);
  }

  void clearSearchHistory() {
    _searchHistoryNotifier.value = const [];
    widget.prefs.setSearchHistory(const []);
  }

  void setThemeAnimationEnabled(bool value) {
    if (_themeAnimationNotifier.value == value) return;
    _themeAnimationNotifier.value = value;
    widget.prefs.setThemeAnimationEnabled(value);
  }

  @override
  Widget build(BuildContext context) {
    return _AppStateScope(state: this, child: widget.child);
  }
}

class _AppStateScope extends InheritedWidget {
  const _AppStateScope({required this.state, required super.child});

  final _AppStateState state;

  ValueNotifier<ThemeMode> get themeNotifier => state._themeNotifier;

  ValueNotifier<Locale> get localeNotifier => state._localeNotifier;

  ValueNotifier<UserSession?> get sessionNotifier => state._sessionNotifier;

  ValueNotifier<Set<String>> get favoritesNotifier => state._favoritesNotifier;

  ValueNotifier<List<WantedRequest>> get wantedNotifier => state._wantedNotifier;

  ValueNotifier<bool> get notificationsNotifier => state._notificationsNotifier;

  ValueNotifier<String> get homeFilterNotifier => state._homeFilterNotifier;

  ValueNotifier<double> get homeScrollOffsetNotifier => state._homeScrollOffsetNotifier;

  ValueNotifier<String> get lastRouteNotifier => state._lastRouteNotifier;

  ValueNotifier<List<String>> get searchHistoryNotifier =>
      state._searchHistoryNotifier;

  ValueNotifier<bool> get themeAnimationNotifier =>
      state._themeAnimationNotifier;

  AnalyticsService get analytics => state._analyticsService;

  bool get initialized => state.initialized;

  void setThemeMode(ThemeMode mode) => state.setThemeMode(mode);

  void setLocale(Locale locale) => state.setLocale(locale);

  void setSession(UserSession? session) => state.setSession(session);

  void toggleFavorite(String productId) => state.toggleFavorite(productId);

  bool isFavorite(String productId) => state.isFavorite(productId);

  void addWantedRequest(WantedRequest request) => state.addWantedRequest(request);

  void removeWantedRequest(String id) => state.removeWantedRequest(id);

  void setNotificationsEnabled(bool value) => state.setNotificationsEnabled(value);

  void setHomeFilter(String filter) => state.setHomeFilter(filter);

  void setHomeScrollOffset(double offset) => state.setHomeScrollOffset(offset);

  void setLastRoute(String route) => state.setLastRoute(route);

  void addSearchQuery(String query) => state.addSearchQuery(query);

  void clearSearchHistory() => state.clearSearchHistory();

  void setThemeAnimationEnabled(bool value) =>
      state.setThemeAnimationEnabled(value);

  SharedPrefsService get prefs => state.widget.prefs;

  @override
  bool updateShouldNotify(covariant _AppStateScope oldWidget) {
    return oldWidget.state != state;
  }
}

class AppRoutes {
  static const onboarding = '/onboarding';
  static const auth = '/auth';
  static const home = '/home';
  static const productDetails = '/product_details';
  static const offers = '/offers';
  static const wanted = '/wanted';
  static const profile = '/profile';
}
