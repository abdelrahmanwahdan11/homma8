import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../data/models.dart';
import 'analytics_service.dart';
import 'shared_prefs_service.dart';

class MockApiException implements Exception {
  const MockApiException(this.message);

  final String message;

  @override
  String toString() => 'MockApiException: $message';
}

class MockApiService {
  MockApiService._(this._prefs);

  final SharedPrefsService _prefs;
  final Map<String, Object> _memoryCache = <String, Object>{};
  final ValueNotifier<bool> connectivityNotifier = ValueNotifier<bool>(true);
  static MockApiService? _instance;

  static void configure(SharedPrefsService prefs) {
    _instance ??= MockApiService._(prefs);
  }

  static MockApiService get instance {
    assert(_instance != null, 'MockApiService.configure must be called before accessing instance.');
    return _instance!;
  }

  Future<T> _simulateCall<T>(Future<T> Function() callback) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!connectivityNotifier.value) {
      throw const MockApiException('offline');
    }
    return callback();
  }

  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    if (!forceRefresh && _memoryCache.containsKey('products')) {
      return (_memoryCache['products'] as List<Product>);
    }

    if (!connectivityNotifier.value && !forceRefresh) {
      final cached = _prefs.getCachedProducts();
      if (cached.isNotEmpty) {
        _memoryCache['products'] = cached;
        return cached;
      }
    }

    return _simulateCall(() async {
      final raw = await rootBundle.loadString('assets/mock/products.json');
      final data = (jsonDecode(raw) as List<dynamic>)
          .map((item) => ProductEncoding.fromJson(item as Map<String, dynamic>))
          .toList();
      _memoryCache['products'] = data;
      unawaited(_prefs.setCachedProducts(data));
      return data;
    });
  }

  Future<List<Product>> fetchOffers({bool forceRefresh = false}) async {
    if (!forceRefresh && _memoryCache.containsKey('offers')) {
      return (_memoryCache['offers'] as List<Product>);
    }

    if (!connectivityNotifier.value && !forceRefresh) {
      final cached = _prefs.getCachedOffers();
      if (cached.isNotEmpty) {
        _memoryCache['offers'] = cached;
        return cached;
      }
    }

    return _simulateCall(() async {
      final raw = await rootBundle.loadString('assets/mock/offers.json');
      final data = (jsonDecode(raw) as List<dynamic>)
          .map((item) => ProductEncoding.fromJson(item as Map<String, dynamic>))
          .toList();
      _memoryCache['offers'] = data;
      unawaited(_prefs.setCachedOffers(data));
      return data;
    });
  }

  Future<UserSession> fetchUserProfile() async {
    if (_memoryCache.containsKey('user_profile')) {
      return _memoryCache['user_profile'] as UserSession;
    }

    if (!connectivityNotifier.value) {
      final cached = _prefs.getSession();
      if (cached != null) {
        _memoryCache['user_profile'] = cached;
        return cached;
      }
    }

    return _simulateCall(() async {
      final raw = await rootBundle.loadString('assets/mock/users.json');
      final data = jsonDecode(raw) as Map<String, dynamic>;
      final session = UserSession(
        id: data['id'] as String,
        name: data['name'] as String,
        email: data['email'] as String,
        avatar: data['avatar'] as String,
        rating: (data['rating'] as num).toDouble(),
      );
      _memoryCache['user_profile'] = session;
      unawaited(_prefs.setSession(session));
      return session;
    });
  }

  Future<List<WantedRequest>> loadWantedItems() async {
    if (_memoryCache.containsKey('wanted')) {
      return (_memoryCache['wanted'] as List<WantedRequest>);
    }

    return _simulateCall(() async {
      final raw = await rootBundle.loadString('assets/mock/wanted.json');
      final data = (jsonDecode(raw) as List<dynamic>)
          .map((item) => WantedRequest.fromJson(item as Map<String, dynamic>))
          .toList();
      _memoryCache['wanted'] = data;
      return data;
    });
  }

  Future<List<Map<String, Object?>>> loadNotifications() async {
    if (_memoryCache.containsKey('notifications')) {
      return (_memoryCache['notifications'] as List<Map<String, Object?>>);
    }

    return _simulateCall(() async {
      final raw = await rootBundle.loadString('assets/mock/notifications.json');
      final data = (jsonDecode(raw) as List<dynamic>)
          .map((item) => (item as Map<String, dynamic>).cast<String, Object?>())
          .toList();
      _memoryCache['notifications'] = data;
      return data;
    });
  }

  Future<Product> postBid({
    required String productId,
    required double amount,
  }) async {
    return _simulateCall(() async {
      final products = await fetchProducts();
      final index = products.indexWhere((element) => element.id == productId);
      if (index == -1) {
        throw MockApiException('Product $productId not found');
      }
      final product = products[index];
      if (amount <= product.priceCurrent) {
        throw MockApiException('Bid must be higher than current price');
      }
      final updated = product.copyWith(
        priceCurrent: amount,
        bidsCount: product.bidsCount + 1,
      );
      final updatedProducts = List<Product>.of(products)..[index] = updated;
      _memoryCache['products'] = updatedProducts;
      unawaited(_prefs.setCachedProducts(updatedProducts));
      AnalyticsService.instance.trackBidPlaced(productId: productId, amount: amount);
      return updated;
    });
  }

  void toggleConnection() {
    connectivityNotifier.value = !connectivityNotifier.value;
  }

  void setConnection(bool value) {
    connectivityNotifier.value = value;
  }

  void clearMemory() => _memoryCache.clear();
}
