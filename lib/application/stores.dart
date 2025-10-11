import 'dart:async';

import 'package:flutter/material.dart';

import '../core/errors.dart';
import '../core/result.dart';
import '../domain/entities.dart';

class AppStateData {
  const AppStateData({
    required this.locale,
    required this.themeMode,
    required this.isFirstRun,
  });

  final Locale locale;
  final ThemeMode themeMode;
  final bool isFirstRun;

  AppStateData copyWith({Locale? locale, ThemeMode? themeMode, bool? isFirstRun}) {
    return AppStateData(
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
      isFirstRun: isFirstRun ?? this.isFirstRun,
    );
  }
}

class CatalogState {
  const CatalogState({
    required this.products,
    required this.page,
    required this.isLoading,
    required this.error,
    required this.swipeIndex,
  });

  final List<Product> products;
  final int page;
  final bool isLoading;
  final AppError? error;
  final int swipeIndex;

  CatalogState copyWith({
    List<Product>? products,
    int? page,
    bool? isLoading,
    AppError? error,
    int? swipeIndex,
  }) {
    return CatalogState(
      products: products ?? this.products,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      swipeIndex: swipeIndex ?? this.swipeIndex,
    );
  }
}

class AuctionState {
  const AuctionState({
    required this.streams,
    required this.placingBid,
    required this.error,
  });

  final Map<String, StreamSubscription<Result<Auction>>> streams;
  final bool placingBid;
  final AppError? error;

  AuctionState copyWith({
    Map<String, StreamSubscription<Result<Auction>>>? streams,
    bool? placingBid,
    AppError? error,
  }) {
    return AuctionState(
      streams: streams ?? this.streams,
      placingBid: placingBid ?? this.placingBid,
      error: error,
    );
  }
}

class UserState {
  const UserState({
    required this.userId,
    required this.watchlist,
    required this.wanted,
    required this.alerts,
  });

  final String userId;
  final List<Product> watchlist;
  final List<WantedItem> wanted;
  final List<PriceAlert> alerts;

  UserState copyWith({
    List<Product>? watchlist,
    List<WantedItem>? wanted,
    List<PriceAlert>? alerts,
  }) {
    return UserState(
      userId: userId,
      watchlist: watchlist ?? this.watchlist,
      wanted: wanted ?? this.wanted,
      alerts: alerts ?? this.alerts,
    );
  }
}

class AppStore extends ValueNotifier<AppStateData> {
  AppStore()
      : super(const AppStateData(
          locale: Locale('ar'),
          themeMode: ThemeMode.system,
          isFirstRun: true,
        ));

  void setLocale(Locale locale) => value = value.copyWith(locale: locale);
  void setThemeMode(ThemeMode mode) => value = value.copyWith(themeMode: mode);
  void setFirstRun(bool flag) => value = value.copyWith(isFirstRun: flag);
}

class CatalogStore extends ValueNotifier<CatalogState> {
  CatalogStore()
      : super(const CatalogState(
          products: [],
          page: 1,
          isLoading: false,
          error: null,
          swipeIndex: 0,
        ));

  void startLoading() {
    value = value.copyWith(isLoading: true, error: null);
  }

  void setProducts(List<Product> products, {bool append = false}) {
    final updated = append ? [...value.products, ...products] : products;
    value = value.copyWith(
      products: updated,
      isLoading: false,
      error: null,
      page: value.page + 1,
    );
  }

  void replaceProducts(List<Product> products) {
    value = value.copyWith(
      products: products,
      isLoading: false,
      error: null,
    );
  }

  void setError(AppError error) {
    value = value.copyWith(isLoading: false, error: error);
  }

  void setSwipeIndex(int index) {
    value = value.copyWith(swipeIndex: index);
  }

  void updateProduct(Product product) {
    final index = value.products.indexWhere((p) => p.id == product.id);
    if (index == -1) return;
    final list = [...value.products]..[index] = product;
    value = value.copyWith(products: list);
  }
}

class AuctionStore extends ValueNotifier<AuctionState> {
  AuctionStore()
      : super(const AuctionState(
          streams: {},
          placingBid: false,
          error: null,
        ));

  void setPlacingBid(bool flag) {
    value = value.copyWith(placingBid: flag);
  }

  void setError(AppError? error) {
    value = value.copyWith(error: error);
  }

  void addStream(String id, StreamSubscription<Result<Auction>> sub) {
    final map = {...value.streams};
    map[id] = sub;
    value = value.copyWith(streams: map);
  }

  void removeStream(String id) {
    final map = {...value.streams};
    map.remove(id);
    value = value.copyWith(streams: map);
  }

  @override
  void dispose() {
    for (final sub in value.streams.values) {
      sub.cancel();
    }
    super.dispose();
  }
}

class UserStore extends ValueNotifier<UserState> {
  UserStore()
      : super(const UserState(
          userId: 'demo-user',
          watchlist: [],
          wanted: [],
          alerts: [],
        ));

  void setWatchlist(List<Product> products) {
    value = value.copyWith(watchlist: products);
  }

  void addToWatchlist(Product product) {
    final list = [...value.watchlist];
    if (!list.any((p) => p.id == product.id)) {
      list.add(product);
      value = value.copyWith(watchlist: list);
    }
  }

  void addWanted(WantedItem item) {
    value = value.copyWith(wanted: [...value.wanted, item]);
  }

  void addAlert(PriceAlert alert) {
    value = value.copyWith(alerts: [...value.alerts, alert]);
  }
}
