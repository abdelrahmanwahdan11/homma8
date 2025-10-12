import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../features/matching/domain/match_engine.dart';
import '../features/notifications/data/local_notification_center.dart';
import '../features/search/domain/mini_search_index.dart';
import '../features/search/domain/relevance_engine.dart';
import '../mock/seed_data.dart';
import '../models/models.dart';
import 'app_prefs.dart';
import 'refresh/refresh_hub.dart';

class AppState extends ChangeNotifier {
  AppState({
    required AppPrefs prefs,
    required MiniSearchIndex searchIndex,
    required RelevanceEngine relevanceEngine,
    required MatchEngine matchEngine,
    required LocalNotificationCenter notificationCenter,
    required RefreshHubController refreshHub,
    required SeedBundle seed,
  })  : _prefs = prefs,
        _searchIndex = searchIndex,
        _relevanceEngine = relevanceEngine,
        _matchEngine = matchEngine,
        notifications = notificationCenter,
        refreshHub = refreshHub {
    _loadSeed(seed);
  }

  final AppPrefs _prefs;
  final MiniSearchIndex _searchIndex;
  final RelevanceEngine _relevanceEngine;
  final MatchEngine _matchEngine;
  final Map<String, Item> _itemsById = <String, Item>{};

  final LocalNotificationCenter notifications;
  final RefreshHubController refreshHub;

  late User _user;
  late List<Item> _items;
  late List<SellListing> _listings;
  late List<BuyIntent> _intents;
  late List<Bid> _bids;
  late MatchSnapshot _matches;
  late Set<String> _favoriteItemIds;

  bool get onboardingSeen => _prefs.onboardingSeen;
  bool get isLoggedIn => _prefs.hasSession;

  ThemeMode get themeMode {
    switch (_prefs.theme) {
      case 'light':
        return ThemeMode.light;
      case 'system':
        return ThemeMode.system;
      default:
        return ThemeMode.dark;
    }
  }

  Locale get locale => Locale(_prefs.locale);

  User get user => _user;

  List<Item> get items => List<Item>.unmodifiable(_items);
  List<SellListing> get listings => List<SellListing>.unmodifiable(_listings);
  List<BuyIntent> get intents => List<BuyIntent>.unmodifiable(_intents);
  List<Bid> get bids => List<Bid>.unmodifiable(_bids);

  List<Bid> get myBids => _bids.where((bid) => bid.userId == _user.id).toList();

  List<SellListing> get favoriteListings =>
      _listings.where((listing) => _favoriteItemIds.contains(listing.itemId)).toList();

  bool isFavorite(String itemId) => _favoriteItemIds.contains(itemId);

  void toggleFavorite(String itemId) {
    if (_favoriteItemIds.contains(itemId)) {
      _favoriteItemIds.remove(itemId);
    } else {
      _favoriteItemIds.add(itemId);
      final item = _itemsById[itemId];
      if (item != null) {
        _relevanceEngine.recordFavorite(item);
      }
    }
    _persistFavorites();
    notifyListeners();
    refreshHub.broadcast('favorites');
  }

  void markOnboardingSeen() {
    _prefs.onboardingSeen = true;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    _prefs.theme = mode.name;
    notifyListeners();
  }

  void setLocale(Locale locale) {
    _prefs.locale = locale.languageCode;
    notifyListeners();
  }

  bool login(String email, String password) {
    if (email.isEmpty || password.length < 8) {
      return false;
    }
    _prefs.hasSession = true;
    notifyListeners();
    return true;
  }

  void logout() {
    _prefs.hasSession = false;
    notifyListeners();
  }

  String get referralCode => ensureReferralCode();

  void updatePreferences(UserPrefs prefs) {
    _user = _user.copyWith(prefs: prefs);
    _prefs.saveUserPrefs(prefs);
    _reseedRelevance();
    notifyListeners();
  }

  String ensureReferralCode() {
    if (_prefs.referralCode != null) {
      return _prefs.referralCode!;
    }
    final code = _generateReferral();
    _prefs.referralCode = code;
    return code;
  }

  void registerReferral(String code) {
    _prefs.referredBy = code;
    notifyListeners();
  }

  void incrementReferralCount() {
    _prefs.referralCount = _prefs.referralCount + 1;
    notifyListeners();
  }

  void addListing({
    required Item item,
    required SellListing listing,
  }) {
    _items.insert(0, item);
    _itemsById[item.id] = item;
    _listings.insert(0, listing);
    _searchIndex.rebuild(items: _items, listings: _listings);
    _matches = _matchEngine.compute(listings: _listings, intents: _intents, items: _items);
    refreshHub.broadcast('listings');
    refreshHub.broadcast('matches');
    _persistItems();
    _persistListings();
    notifyListeners();
  }

  void addIntent(BuyIntent intent) {
    _intents.insert(0, intent);
    _matches = _matchEngine.compute(listings: _listings, intents: _intents, items: _items);
    refreshHub.broadcast('intents');
    refreshHub.broadcast('matches');
    _persistIntents();
    notifyListeners();
  }

  void placeBid({required String listingId, required double amount}) {
    final index = _listings.indexWhere((listing) => listing.id == listingId);
    if (index == -1) {
      return;
    }
    final listing = _listings[index];
    final minIncrement = _minIncrement(listing.currentBid);
    if (amount < listing.currentBid + minIncrement) {
      return;
    }
    var updated = listing.copyWith(
      currentBid: amount,
      bidCount: listing.bidCount + 1,
    );
    final secondsLeft = listing.endAt.difference(DateTime.now()).inSeconds;
    if (secondsLeft > 0 && secondsLeft < 60) {
      updated = updated.copyWith(endAt: listing.endAt.add(const Duration(minutes: 2)));
    }
    _listings[index] = updated;
    final bid = Bid(
      id: 'bid_${_bids.length + 1}',
      listingId: listingId,
      userId: _user.id,
      amount: amount,
      createdAt: DateTime.now().toUtc(),
      status: 'placed',
    );
    _bids.add(bid);
    final item = _itemsById[listing.itemId];
    if (item != null) {
      _relevanceEngine.recordBid(updated, amount, item);
    }
    _searchIndex.rebuild(items: _items, listings: _listings);
    _matches = _matchEngine.compute(listings: _listings, intents: _intents, items: _items);
    refreshHub.broadcast('listing_$listingId');
    refreshHub.broadcast('matches');
    refreshHub.broadcast('bids');
    _persistListings();
    _persistBids();
    notifications.push(
      NotificationEntry(
        id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
        title: 'تم تسجيل مزايدة',
        body: 'تم تحديث عرضك على ${item?.title ?? listingId}',
        type: 'bid',
        createdAt: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  MatchSnapshot get matches => _matches;

  SearchResult search(String query, SearchFilters filters) {
    return _searchIndex.search(query, filters, _relevanceEngine.snapshot(_user.prefs));
  }

  void recordView(String itemId) {
    final item = _itemsById[itemId];
    if (item == null) {
      return;
    }
    _relevanceEngine.recordView(item);
  }

  void _loadSeed(SeedBundle seed) {
    _user = User(
      id: 'user_0',
      name: 'أنت',
      email: 'user0@bentobid.local',
      referralCode: _prefs.referralCode ?? _generateReferral(),
      referredBy: _prefs.referredBy,
      prefs: _prefs.loadUserPrefs(),
    );
    _prefs.referralCode = _user.referralCode;
    _items = _loadItems(seed.items);
    _listings = _loadListings(seed.listings);
    _intents = _loadIntents(seed.intents);
    _bids = _loadBids(seed.bids);
    _itemsById.addEntries(_items.map((item) => MapEntry(item.id, item)));
    _favoriteItemIds = _loadFavorites(seed.favorites);
    _searchIndex.rebuild(items: _items, listings: _listings);
    _reseedRelevance();
    _matches = _matchEngine.compute(listings: _listings, intents: _intents, items: _items);
  }

  void _reseedRelevance() {
    final favorites = _favoriteItemIds
        .map(
          (id) => Favorite(userId: _user.id, itemId: id, createdAt: DateTime.now()),
        )
        .toList();
    final myBids = _bids.where((bid) => bid.userId == _user.id);
    _relevanceEngine.seed(
      prefs: _user.prefs,
      favorites: favorites,
      bids: myBids,
      listings: _listings,
      items: _items,
    );
  }

  List<Item> _loadItems(List<Item> seed) {
    final blob = _prefs.itemsBlob;
    if (blob == null) {
      return List<Item>.from(seed);
    }
    final data = (jsonDecode(blob) as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(Item.fromJson).toList();
  }

  List<SellListing> _loadListings(List<SellListing> seed) {
    final blob = _prefs.listingsBlob;
    if (blob == null) {
      return List<SellListing>.from(seed);
    }
    final data = (jsonDecode(blob) as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(SellListing.fromJson).toList();
  }

  List<BuyIntent> _loadIntents(List<BuyIntent> seed) {
    final blob = _prefs.intentsBlob;
    if (blob == null) {
      return List<BuyIntent>.from(seed);
    }
    final data = (jsonDecode(blob) as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(BuyIntent.fromJson).toList();
  }

  List<Bid> _loadBids(List<Bid> seed) {
    final blob = _prefs.bidsBlob;
    if (blob == null) {
      return List<Bid>.from(seed);
    }
    final data = (jsonDecode(blob) as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(Bid.fromJson).toList();
  }

  Set<String> _loadFavorites(List<Favorite> seed) {
    final blob = _prefs.favoritesBlob;
    if (blob == null) {
      return seed.where((favorite) => favorite.userId == _user.id).map((favorite) => favorite.itemId).toSet();
    }
    final data = (jsonDecode(blob) as List<dynamic>).cast<Map<String, dynamic>>();
    return data.map(Favorite.fromJson).where((favorite) => favorite.userId == _user.id).map((favorite) => favorite.itemId).toSet();
  }

  void _persistItems() {
    _prefs.itemsBlob = jsonEncode(_items.map((item) => item.toJson()).toList());
  }

  void _persistListings() {
    _prefs.listingsBlob = jsonEncode(_listings.map((listing) => listing.toJson()).toList());
  }

  void _persistIntents() {
    _prefs.intentsBlob = jsonEncode(_intents.map((intent) => intent.toJson()).toList());
  }

  void _persistBids() {
    _prefs.bidsBlob = jsonEncode(_bids.map((bid) => bid.toJson()).toList());
  }

  void _persistFavorites() {
    final favorites = _favoriteItemIds
        .map(
          (itemId) => Favorite(userId: _user.id, itemId: itemId, createdAt: DateTime.now()),
        )
        .toList();
    _prefs.favoritesBlob = jsonEncode(favorites.map((favorite) => favorite.toJson()).toList());
  }

  double quickBidAmount(SellListing listing) {
    return listing.currentBid + _minIncrement(listing.currentBid);
  }

  Item? itemForListing(SellListing listing) => _itemsById[listing.itemId];

  double _minIncrement(double value) {
    if (value < 100) {
      return 5;
    }
    if (value < 500) {
      return 10;
    }
    if (value < 1000) {
      return 25;
    }
    if (value < 5000) {
      return 50;
    }
    return 100;
  }

  String _generateReferral() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List<String>.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
