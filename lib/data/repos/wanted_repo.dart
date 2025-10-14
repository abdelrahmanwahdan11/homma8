import 'dart:math';

import '../mock/delay.dart';
import '../mock/seed.dart';
import '../models/wanted.dart';

class WantedRepository {
  WantedRepository();

  final List<WantedModel> _wanteds = MockSeed.wanteds();

  Future<PagedResult<WantedModel>> fetch({required int pageKey, int pageSize = 12}) async {
    await mockLatency();
    final start = pageKey * pageSize;
    final end = min(start + pageSize, _wanteds.length);
    final slice = _wanteds.sublist(start, end);
    final isLast = end >= _wanteds.length;
    return PagedResult(items: slice, nextKey: isLast ? null : pageKey + 1);
  }

  Future<WantedModel?> byId(String id) async {
    await mockLatency(120);
    return _wanteds.firstWhere((element) => element.id == id, orElse: () => _wanteds.first);
  }

  List<WantedModel> get all => List.unmodifiable(_wanteds);
}

class PagedResult<T> {
  const PagedResult({required this.items, this.nextKey});

  final List<T> items;
  final int? nextKey;
}
