import 'dart:async';
import 'dart:math';

import '../../application/engines/pricing_engine.dart';
import '../../core/errors.dart';
import '../../core/result.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import 'mock_data.dart';

class MockProductRepository implements ProductRepository {
  MockProductRepository(this._pricingEngine);

  final PricingEngine _pricingEngine;
  final Map<String, StreamController<Result<Auction>>> _controllers = {};

  List<Product> _products = List<Product>.from(seedProducts);
  final Map<String, Auction> _auctions = Map<String, Auction>.from(seedAuctions);

  @override
  Future<Result<List<Product>>> fetchPage(int page) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    if (page == 1 && _products.length < 8) {
      _products = [..._products, ...generateMoreProducts(3, 10)];
    }
    final start = (page - 1) * 10;
    if (start >= _products.length) {
      return const Success<List<Product>>(<Product>[]);
    }
    final end = min(start + 10, _products.length);
    return Success<List<Product>>(_products.sublist(start, end));
  }

  @override
  Stream<Result<Auction>> watchAuction(String productId) {
    if (!_controllers.containsKey(productId)) {
      final controller = StreamController<Result<Auction>>.broadcast();
      final auction = _auctions[productId];
      if (auction != null) {
        controller.add(Success<Auction>(auction));
        Timer? timer;
        timer = Timer.periodic(const Duration(seconds: 12), (_) {
          if (!controller.hasListener) return;
          final current = _auctions[productId] ?? auction;
          final delta = (Random().nextDouble() * current.minIncrement)
              .clamp(1, current.minIncrement);
          final updated = current.copyWith(
            currentBid: current.currentBid + delta,
            bids: [
              ...current.bids,
              Bid(
                userId: 'auto',
                amount: current.currentBid + delta,
                time: DateTime.now(),
              ),
            ],
          );
          _auctions[productId] = updated;
          controller.add(Success<Auction>(updated));
        });
        controller.onCancel = () {
          timer?.cancel();
        };
      } else {
        controller.add(Failure<Auction>(
          AppError(code: AppErrorCode.validation, message: 'Auction not found'),
        ));
      }
      _controllers[productId] = controller;
    }
    return _controllers[productId]!.stream;
  }

  @override
  Future<Result<void>> placeBid(String productId, double amount) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final auction = _auctions[productId];
    if (auction == null) {
      return Failure<void>(
        AppError(code: AppErrorCode.validation, message: 'Auction not found'),
      );
    }
    if (amount < auction.currentBid + auction.minIncrement) {
      return Failure<void>(
        AppError(code: AppErrorCode.validation, message: 'Bid too low'),
      );
    }
    final updated = auction.copyWith(
      currentBid: amount,
      bids: [
        ...auction.bids,
        Bid(userId: 'demo-user', amount: amount, time: DateTime.now()),
      ],
    );
    _auctions[productId] = updated;
    _controllers[productId]?.add(Success<Auction>(updated));
    return const Success<void>(null);
  }

  Product updateDemand(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) throw ArgumentError('Product not found');
    final product = _products[index];
    final updated = product.copyWith(
      demandCount: product.demandCount + 1,
      watchers: product.watchers + 1,
    );
    final newDiscount = _pricingEngine.compute(updated);
    final finalProduct = updated.copyWith(
      discountPercent: newDiscount,
      currentPrice: updated.basePrice * (1 - newDiscount / 100),
    );
    _products[index] = finalProduct;
    return finalProduct;
  }
}

class MockUserRepository implements UserRepository {
  MockUserRepository(this._productRepository);

  final MockProductRepository _productRepository;
  final List<String> _watchlistIds = [];

  @override
  Future<Result<void>> addToWatchlist(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (!_watchlistIds.contains(productId)) {
      _watchlistIds.add(productId);
    }
    return const Success<void>(null);
  }

  @override
  Future<Result<List<Product>>> getWatchlist() async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final products = _productRepository._products
        .where((product) => _watchlistIds.contains(product.id))
        .toList();
    return Success<List<Product>>(products);
  }

  @override
  Future<Result<void>> setTargetPrice(WantedItem item) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const Success<void>(null);
  }
}

class MockSellRepository implements SellRepository {
  MockSellRepository(this._userRepository);

  final MockUserRepository _userRepository;
  final List<WantedItem> _wanted = [];

  @override
  Future<Result<String>> postListing(Product product) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const Success<String>('listing-created');
  }

  @override
  Future<Result<String>> postWanted(WantedItem wanted) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _wanted.add(wanted);
    return const Success<String>('wanted-created');
  }

  List<WantedItem> get wantedItems => List.unmodifiable(_wanted);
}
