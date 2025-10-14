import 'dart:math';

import '../mock/delay.dart';
import '../mock/seed.dart';
import '../models/auction.dart';

class AuctionRepository {
  AuctionRepository();

  final List<AuctionModel> _auctions = MockSeed.auctions();

  Future<PagedResult<AuctionModel>> fetchAuctions({required int pageKey, int pageSize = 12}) async {
    await mockLatency();
    final start = pageKey * pageSize;
    final end = min(start + pageSize, _auctions.length);
    final slice = _auctions.sublist(start, end);
    final isLastPage = end >= _auctions.length;
    return PagedResult(items: slice, nextKey: isLastPage ? null : pageKey + 1);
  }

  Future<AuctionModel?> getAuction(String id) async {
    await mockLatency(120);
    return _auctions.firstWhere((auction) => auction.id == id, orElse: () => _auctions.first);
  }

  List<AuctionModel> get all => List.unmodifiable(_auctions);
}

class PagedResult<T> {
  const PagedResult({required this.items, this.nextKey});

  final List<T> items;
  final int? nextKey;
}
