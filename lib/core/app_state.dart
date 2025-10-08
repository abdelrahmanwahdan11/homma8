import 'dart:async';

import 'package:flutter/material.dart';

import '../models/auction_item.dart';
import '../models/bid.dart';
import '../models/price_alert.dart';
import 'localization/language_manager.dart';
import 'theme/theme_manager.dart';

class AppState extends StatefulWidget {
  const AppState({required this.child, super.key});

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
  static ThemeMode? _cachedThemeMode;
  static Locale? _cachedLocale;
  static bool _cachedUseSystemTheme = false;
  static String _cachedCurrency = r'$';

  late final ValueNotifier<ThemeMode> _themeNotifier;
  late final ValueNotifier<bool> _useSystemThemeNotifier;
  late final ValueNotifier<Locale> _localeNotifier;
  late final ValueNotifier<String> _currencyNotifier;
  late final ValueNotifier<Set<String>> _favoriteIdsNotifier;
  late final ValueNotifier<List<Bid>> _bidsNotifier;
  late final ValueNotifier<List<PriceAlert>> _alertsNotifier;
  late final ValueNotifier<List<AuctionItem>> _itemsNotifier;
  late final ValueNotifier<int> _navigationIndexNotifier;
  late final ValueNotifier<String> _searchQueryNotifier;
  late final ValueNotifier<RangeValues> _priceFilterNotifier;
  late final ValueNotifier<String?> _bannerMessageNotifier;

  final Map<String, double> _scrollPositions = {};
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _themeNotifier = ValueNotifier(_cachedThemeMode ?? ThemeMode.light);
    _useSystemThemeNotifier = ValueNotifier(_cachedUseSystemTheme);
    _localeNotifier = ValueNotifier(_cachedLocale ?? const Locale('en'));
    _currencyNotifier = ValueNotifier(_cachedCurrency);
    _favoriteIdsNotifier = ValueNotifier(<String>{});
    _bidsNotifier = ValueNotifier(<Bid>[]);
    _alertsNotifier = ValueNotifier(<PriceAlert>[]);
    _itemsNotifier = ValueNotifier(<AuctionItem>[]);
    _navigationIndexNotifier = ValueNotifier<int>(0);
    _searchQueryNotifier = ValueNotifier<String>('');
    _priceFilterNotifier = ValueNotifier<RangeValues>(const RangeValues(0, 20000));
    _bannerMessageNotifier = ValueNotifier<String?>(null);
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    _useSystemThemeNotifier.dispose();
    _localeNotifier.dispose();
    _currencyNotifier.dispose();
    _favoriteIdsNotifier.dispose();
    for (final bid in _bidsNotifier.value) {
      bid.dispose();
    }
    _bidsNotifier.dispose();
    for (final alert in _alertsNotifier.value) {
      alert.dispose();
    }
    _alertsNotifier.dispose();
    for (final item in _itemsNotifier.value) {
      item.dispose();
    }
    _itemsNotifier.dispose();
    _navigationIndexNotifier.dispose();
    _searchQueryNotifier.dispose();
    _priceFilterNotifier.dispose();
    _bannerMessageNotifier.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void toggleTheme() {
    if (_useSystemThemeNotifier.value) {
      _useSystemThemeNotifier.value = false;
    }
    _themeNotifier.value =
        _themeNotifier.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    _cachedThemeMode = _themeNotifier.value;
  }

  void setThemeMode(ThemeMode mode) {
    _themeNotifier.value = mode;
    _cachedThemeMode = mode;
  }

  void setUseSystemTheme(bool value) {
    _useSystemThemeNotifier.value = value;
    _cachedUseSystemTheme = value;
    if (value) {
      final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      setThemeMode(platformBrightness == Brightness.dark ? ThemeMode.dark : ThemeMode.light);
    }
  }

  void switchLanguage() {
    final nextLocale = _localeNotifier.value.languageCode == 'en'
        ? const Locale('ar')
        : const Locale('en');
    setLocale(nextLocale);
  }

  void setLocale(Locale locale) {
    _localeNotifier.value = locale;
    _cachedLocale = locale;
  }

  void toggleCurrency() {
    _currencyNotifier.value = _currencyNotifier.value == r'$' ? '€' : r'$';
    _cachedCurrency = _currencyNotifier.value;
  }

  void registerItems(List<AuctionItem> items) {
    final previous = _itemsNotifier.value;
    for (final item in previous) {
      item.dispose();
    }
    _itemsNotifier.value = List.unmodifiable(items);
  }

  void addMoreItems(List<AuctionItem> items) {
    final updated = List<AuctionItem>.from(_itemsNotifier.value)
      ..addAll(items);
    _itemsNotifier.value = List.unmodifiable(updated);
  }

  void updateFavorite(String itemId, bool isFavorite) {
    final favorites = Set<String>.from(_favoriteIdsNotifier.value);
    if (isFavorite) {
      favorites.add(itemId);
    } else {
      favorites.remove(itemId);
    }
    _favoriteIdsNotifier.value = favorites;
  }

  bool isFavorite(String itemId) => _favoriteIdsNotifier.value.contains(itemId);

  void toggleFavorite(AuctionItem item) {
    final isFavorite = !_favoriteIdsNotifier.value.contains(item.id);
    item.favoriteNotifier.value = isFavorite;
    updateFavorite(item.id, isFavorite);
    showBannerMessage(
      LanguageManager.of(context).t(
        isFavorite ? 'added_favorite' : 'removed_favorite',
      ),
    );
  }

  void showBannerMessage(String message) {
    _bannerTimer?.cancel();
    _bannerMessageNotifier.value = message;
    _bannerTimer = Timer(const Duration(seconds: 3), () {
      _bannerMessageNotifier.value = null;
    });
  }

  void addBidForItem(AuctionItem item, double amount) {
    item.priceNotifier.value = item.priceNotifier.value + amount;
    item.hasBidNotifier.value = true;
    if (!_bidsNotifier.value.any((bid) => bid.item.id == item.id)) {
      final bid = Bid(item: item);
      final updated = List<Bid>.from(_bidsNotifier.value)..add(bid);
      _bidsNotifier.value = List.unmodifiable(updated);
    }
    showBannerMessage(LanguageManager.of(context).t('bid_success'));
  }

  void setNavigationIndex(int index) {
    _navigationIndexNotifier.value = index;
  }

  void setSearchQuery(String query) {
    _searchQueryNotifier.value = query;
  }

  void setPriceFilter(RangeValues values) {
    _priceFilterNotifier.value = values;
  }

  void addAlert(PriceAlert alert) {
    final updated = List<PriceAlert>.from(_alertsNotifier.value)..add(alert);
    _alertsNotifier.value = List.unmodifiable(updated);
    showBannerMessage(LanguageManager.of(context).t('add_alert'));
  }

  void removeAlert(PriceAlert alert) {
    final updated = List<PriceAlert>.from(_alertsNotifier.value)..remove(alert);
    _alertsNotifier.value = List.unmodifiable(updated);
  }

  void setScrollPosition(String key, double offset) {
    _scrollPositions[key] = offset;
  }

  double? getScrollPosition(String key) => _scrollPositions[key];

  @override
  Widget build(BuildContext context) {
    return ThemeManager(
      themeNotifier: _themeNotifier,
      useSystemThemeNotifier: _useSystemThemeNotifier,
      child: LanguageManager(
        localeNotifier: _localeNotifier,
        child: _AppStateScope(
          state: this,
          child: widget.child,
        ),
      ),
    );
  }
}

class _AppStateScope extends InheritedWidget {
  const _AppStateScope({required this.state, required super.child});

  final _AppStateState state;

  ValueNotifier<ThemeMode> get themeNotifier => state._themeNotifier;
  ValueNotifier<bool> get useSystemThemeNotifier => state._useSystemThemeNotifier;
  ValueNotifier<Locale> get localeNotifier => state._localeNotifier;
  ValueNotifier<String> get currencyNotifier => state._currencyNotifier;
  ValueNotifier<Set<String>> get favoriteIdsNotifier => state._favoriteIdsNotifier;
  ValueNotifier<List<Bid>> get bidsNotifier => state._bidsNotifier;
  ValueNotifier<List<PriceAlert>> get alertsNotifier => state._alertsNotifier;
  ValueNotifier<List<AuctionItem>> get itemsNotifier => state._itemsNotifier;
  ValueNotifier<int> get navigationIndexNotifier => state._navigationIndexNotifier;
  ValueNotifier<String> get searchQueryNotifier => state._searchQueryNotifier;
  ValueNotifier<RangeValues> get priceFilterNotifier => state._priceFilterNotifier;
  ValueNotifier<String?> get bannerMessageNotifier => state._bannerMessageNotifier;

  void toggleTheme() => state.toggleTheme();
  void setThemeMode(ThemeMode mode) => state.setThemeMode(mode);
  void setUseSystemTheme(bool value) => state.setUseSystemTheme(value);
  void switchLanguage() => state.switchLanguage();
  void setLocale(Locale locale) => state.setLocale(locale);
  void toggleCurrency() => state.toggleCurrency();
  void registerItems(List<AuctionItem> items) => state.registerItems(items);
  void addMoreItems(List<AuctionItem> items) => state.addMoreItems(items);
  void toggleFavorite(AuctionItem item) => state.toggleFavorite(item);
  bool isFavorite(String itemId) => state.isFavorite(itemId);
  void addBidForItem(AuctionItem item, double amount) =>
      state.addBidForItem(item, amount);
  void setNavigationIndex(int index) => state.setNavigationIndex(index);
  void setSearchQuery(String query) => state.setSearchQuery(query);
  void setPriceFilter(RangeValues values) => state.setPriceFilter(values);
  void addAlert(PriceAlert alert) => state.addAlert(alert);
  void removeAlert(PriceAlert alert) => state.removeAlert(alert);
  void showBannerMessage(String message) => state.showBannerMessage(message);
  void setScrollPosition(String key, double offset) =>
      state.setScrollPosition(key, offset);
  double? getScrollPosition(String key) => state.getScrollPosition(key);

  @override
  bool updateShouldNotify(covariant _AppStateScope oldWidget) {
    return oldWidget.state != state;
  }
}
