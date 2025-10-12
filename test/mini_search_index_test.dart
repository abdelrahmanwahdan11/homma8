import 'package:flutter_test/flutter_test.dart';

import 'package:bentobid/src/features/search/domain/mini_search_index.dart';
import 'package:bentobid/src/models/models.dart';
import 'package:bentobid/src/features/search/domain/relevance_engine.dart';

void main() {
  final index = MiniSearchIndex();
  final items = [
    Item(
      id: '1',
      title: 'Vintage Camera',
      subtitle: 'Camera',
      image: '',
      description: 'Classic film camera',
      category: 'Collectibles',
      condition: 'used',
      locationText: 'Riyadh',
      basePrice: 300,
      endAt: DateTime.now().add(const Duration(days: 5)),
      tags: const ['camera', 'film'],
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Item(
      id: '2',
      title: 'Gaming Laptop',
      subtitle: 'Laptop',
      image: '',
      description: 'High performance laptop',
      category: 'Electronics',
      condition: 'new',
      locationText: 'Jeddah',
      basePrice: 4500,
      endAt: DateTime.now().add(const Duration(days: 3)),
      tags: const ['laptop', 'gaming'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];
  final listings = [
    SellListing(
      id: 'L1',
      itemId: '1',
      sellerId: 'S1',
      askPrice: 350,
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      endAt: DateTime.now().add(const Duration(days: 5)),
      currentBid: 320,
      bidCount: 2,
    ),
    SellListing(
      id: 'L2',
      itemId: '2',
      sellerId: 'S2',
      askPrice: 4800,
      status: 'active',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      endAt: DateTime.now().add(const Duration(days: 3)),
      currentBid: 4700,
      bidCount: 5,
    ),
  ];
  index.rebuild(items: items, listings: listings);
  final snapshot = RelevanceEngine().snapshot(const UserPrefs());

  test('gaming query ranks laptop first', () {
    final result = index.search('gaming laptop', const SearchFilters(), snapshot);
    expect(result.hits.first.item.id, '2');
  });

  test('camera query ranks vintage camera', () {
    final result = index.search('film camera', const SearchFilters(), snapshot);
    expect(result.hits.first.item.id, '1');
  });
}
