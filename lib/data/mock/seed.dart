import 'dart:math';

import '../models/auction.dart';
import '../models/match_score.dart';
import '../models/user.dart';
import '../models/wanted.dart';

class MockSeed {
  MockSeed._();

  static final Random _random = Random(42);

  static List<UserModel> users() {
    return List<UserModel>.generate(8, (index) {
      final id = 'u_${index + 1}';
      return UserModel(
        id: id,
        name: 'User $index',
        avatar: 'https://i.pravatar.cc/150?img=${index + 10}',
        isGuest: false,
        prefs: {
          'categories': ['phones', 'laptops', 'collectibles'][index % 3],
        },
      );
    });
  }

  static List<AuctionModel> auctions() {
    final base = <AuctionModel>[];
    base.add(
      AuctionModel(
        id: 'a_1001',
        title: 'iPhone 14 Pro 256GB',
        desc: 'Mint condition, includes box',
        images: List<String>.generate(2, (index) => 'auction_a_1001_$index'),
        category: 'phones',
        priceStart: 450,
        priceNow: 612,
        endsAt: DateTime.parse('2025-12-31T23:59:00Z'),
        location: 'Ramallah',
        sellerId: 'u_2',
        stats: const {'views': 320, 'favorites': 27, 'bids': 12},
      ),
    );

    for (var i = 0; i < 35; i++) {
      final id = 'a_${1100 + i}';
      final category = ['phones', 'laptops', 'cameras', 'collectibles'][i % 4];
      base.add(
        AuctionModel(
          id: id,
          title: '${category[0].toUpperCase()}${category.substring(1)} lot #$i',
          desc: 'Industrial minimal piece number $i with lime accent details.',
          images: List<String>.generate(2, (img) => 'auction_$id_${img + 1}'),
          category: category,
          priceStart: 100 + _random.nextInt(200).toDouble(),
          priceNow: 150 + _random.nextInt(400).toDouble(),
          endsAt: DateTime.now().add(Duration(days: _random.nextInt(14) + 1, hours: _random.nextInt(20))),
          location: ['Ramallah', 'Jerusalem', 'Nablus', 'Hebron'][i % 4],
          sellerId: 'u_${(i % 7) + 1}',
          stats: {
            'views': 50 + _random.nextInt(300),
            'favorites': 5 + _random.nextInt(30),
            'bids': 1 + _random.nextInt(15),
          },
        ),
      );
    }
    return base;
  }

  static List<WantedModel> wanteds() {
    final base = <WantedModel>[];
    base.add(
      WantedModel(
        id: 'w_2001',
        userId: 'u_5',
        title: 'MacBook Air M2',
        specs: '8/256, Arabic keyboard preferred',
        maxPrice: 850,
        category: 'laptops',
        location: 'Jerusalem',
        createdAt: DateTime.parse('2025-10-01T10:00:00Z'),
      ),
    );
    for (var i = 0; i < 23; i++) {
      final id = 'w_${2100 + i}';
      final category = ['phones', 'laptops', 'gaming', 'collectibles'][i % 4];
      base.add(
        WantedModel(
          id: id,
          userId: 'u_${(i % 7) + 1}',
          title: 'Wanted $category #$i',
          specs: 'Looking for $category with lime-accented condition details.',
          maxPrice: 200 + _random.nextInt(600).toDouble(),
          category: category,
          location: ['Ramallah', 'Jenin', 'Bethlehem'][i % 3],
          createdAt: DateTime.now().subtract(Duration(days: i)),
        ),
      );
    }
    return base;
  }

  static List<MatchScoreModel> matchesForAuction(String auctionId) {
    return List<MatchScoreModel>.generate(6, (index) {
      return MatchScoreModel(
        sourceId: auctionId,
        targetId: 'u_${index + 1}',
        score: 0.6 + _random.nextDouble() * 0.4,
        reason: 'Interested in ${index % 2 == 0 ? 'premium' : 'budget'} gear near lime districts.',
      );
    });
  }
}
