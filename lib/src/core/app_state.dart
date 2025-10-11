import 'dart:async';

import 'package:flutter/material.dart';

import '../mock/sample_data.dart';
import '../models/listing.dart';
import '../models/request_item.dart';
import 'app_prefs.dart';

class AppState extends ChangeNotifier {
  AppState(this._prefs) {
    _listings = SampleData.listings();
    _requests = SampleData.requests();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  final AppPrefs _prefs;
  late Timer _ticker;
  late List<Listing> _listings;
  late List<RequestItem> _requests;
  final Set<String> _watchlist = <String>{};

  ThemeMode get themeMode {
    switch (_prefs.theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.theme = mode.name;
    notifyListeners();
  }

  Locale? get locale {
    final code = _prefs.locale;
    if (code == 'system') {
      return null;
    }
    return Locale(code);
  }

  void setLocale(Locale? locale) {
    _prefs.locale = locale?.languageCode ?? 'system';
    notifyListeners();
  }

  bool get isLoggedIn => _prefs.loggedIn;

  void login({required String identity, required String password}) {
    if (identity.isNotEmpty && password.length >= 6) {
      _prefs.loggedIn = true;
      notifyListeners();
    }
  }

  void logout() {
    _prefs.loggedIn = false;
    notifyListeners();
  }

  bool get splashShown => _prefs.splashShown;

  void markSplashShown() {
    _prefs.splashShown = true;
  }

  List<Listing> get listings => List<Listing>.unmodifiable(_listings);

  List<RequestItem> get requests => List<RequestItem>.unmodifiable(_requests);

  bool isWatched(String id) => _watchlist.contains(id);

  void toggleWatch(String id) {
    if (_watchlist.contains(id)) {
      _watchlist.remove(id);
    } else {
      _watchlist.add(id);
    }
    notifyListeners();
  }

  List<Listing> get watchlistItems =>
      _listings.where((listing) => _watchlist.contains(listing.id)).toList();

  Duration timeLeft(Listing listing) {
    final now = DateTime.now().toUtc();
    final left = listing.endAt.difference(now);
    if (left.isNegative) {
      return Duration.zero;
    }
    return left;
  }

  double minIncrement(double currentPrice) {
    if (currentPrice < 100) {
      return 1;
    }
    if (currentPrice < 500) {
      return 5;
    }
    if (currentPrice < 1000) {
      return 10;
    }
    if (currentPrice < 5000) {
      return 25;
    }
    return 50;
  }

  void placeBid({required String listingId, required double amount}) {
    final index = _listings.indexWhere((listing) => listing.id == listingId);
    if (index == -1) {
      return;
    }
    final listing = _listings[index];
    final left = timeLeft(listing);
    if (left == Duration.zero) {
      return;
    }

    final increment = minIncrement(listing.currentPrice);
    final minAcceptable = listing.currentPrice + increment;
    if (amount < minAcceptable) {
      return;
    }

    final updated = listing.copyWith(currentPrice: amount);
    if (left.inSeconds <= 60) {
      final extendedEnd = updated.endAt.add(const Duration(seconds: 120));
      _listings[index] = updated.copyWith(endAt: extendedEnd);
    } else {
      _listings[index] = updated;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _ticker.cancel();
    super.dispose();
  }
}
