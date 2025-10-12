import 'package:flutter_test/flutter_test.dart';

import 'package:bentobid/src/features/matching/domain/match_engine.dart';
import 'package:bentobid/src/models/models.dart';

void main() {
  test('match engine links listings and intents', () {
    final listings = [
      SellListing(
        id: 'L1',
        itemId: 'I1',
        sellerId: 'S1',
        askPrice: 500,
        status: 'active',
        createdAt: DateTime.now(),
        endAt: DateTime.now().add(const Duration(days: 3)),
        currentBid: 480,
        bidCount: 2,
      ),
    ];
    final intents = [
      BuyIntent(
        id: 'B1',
        buyerId: 'U1',
        title: 'Looking for vintage camera',
        category: 'Collectibles',
        maxPrice: 550,
        condition: 'used',
        notes: '',
        status: 'active',
        createdAt: DateTime.now(),
      ),
    ];
    final items = [
      Item(
        id: 'I1',
        title: 'Vintage Camera',
        subtitle: '',
        image: '',
        description: '',
        category: 'Collectibles',
        condition: 'used',
        locationText: '',
        basePrice: 450,
        endAt: DateTime.now().add(const Duration(days: 3)),
        tags: const ['camera', 'vintage'],
        createdAt: DateTime.now(),
      ),
    ];
    final engine = MatchEngine();
    final snapshot = engine.compute(listings: listings, intents: intents, items: items);
    expect(snapshot.sellerMatches['L1'], isNotEmpty);
    expect(snapshot.buyerMatches['B1'], isNotEmpty);
  });
}
