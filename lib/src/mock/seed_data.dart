import 'dart:math';

import '../models/models.dart';

class SeedBundle {
  SeedBundle({
    required this.items,
    required this.listings,
    required this.intents,
    required this.bids,
    required this.favorites,
    required this.notifications,
  });

  final List<Item> items;
  final List<SellListing> listings;
  final List<BuyIntent> intents;
  final List<Bid> bids;
  final List<Favorite> favorites;
  final List<NotificationEntry> notifications;
}

class SeedData {
  const SeedData._();

  static const List<String> _catalogs = <String>[
    'إلكترونيات',
    'موضة',
    'منزل',
    'رياضة',
    'مقتنيات',
    'كتب',
    'سيارات',
  ];

  static const List<String> _conditions = <String>[
    'new',
    'used',
  ];

  static const List<String> _cities = <String>[
    'الرياض',
    'جدة',
    'الدمام',
    'الخبر',
    'مكة',
    'المدينة',
  ];

  static SeedBundle generate({int seed = 42}) {
    final random = Random(seed);
    final List<Item> items = <Item>[];
    final List<SellListing> listings = <SellListing>[];
    final List<BuyIntent> intents = <BuyIntent>[];
    final List<Bid> bids = <Bid>[];
    final List<Favorite> favorites = <Favorite>[];
    final List<NotificationEntry> notifications = <NotificationEntry>[];

    for (int i = 0; i < 64; i++) {
      final catalog = _catalogs[random.nextInt(_catalogs.length)];
      final id = 'item_$i';
      final basePrice = 50 + random.nextInt(2000) + random.nextDouble();
      final createdAt = DateTime.now().toUtc().subtract(Duration(days: random.nextInt(180)));
      final endAt = DateTime.now().toUtc().add(Duration(days: random.nextInt(30) + 1));
      items.add(
        Item(
          id: id,
          title: _titleFor(catalog, i),
          subtitle: _subtitleFor(catalog),
          image: 'https://picsum.photos/seed/$i/800/600',
          description: 'وصف تفصيلي للعنصر رقم $i ضمن فئة $catalog.',
          category: catalog,
          condition: _conditions[random.nextInt(_conditions.length)],
          locationText: _cities[random.nextInt(_cities.length)],
          basePrice: basePrice,
          endAt: endAt,
          tags: <String>['tag$i', catalog, catalog.substring(0, 2)],
          createdAt: createdAt,
        ),
      );
    }

    for (int i = 0; i < 40; i++) {
      final item = items[random.nextInt(items.length)];
      final id = 'listing_$i';
      final ask = (item.basePrice * (1 + random.nextDouble() * 0.4)).roundToDouble();
      final current = ask * (0.7 + random.nextDouble() * 0.2);
      final createdAt = item.createdAt.add(const Duration(days: 2));
      final endAt = item.endAt;
      listings.add(
        SellListing(
          id: id,
          itemId: item.id,
          sellerId: 'seller_${random.nextInt(12)}',
          askPrice: ask,
          status: random.nextBool() ? 'active' : 'closed',
          createdAt: createdAt,
          endAt: endAt,
          currentBid: double.parse(current.toStringAsFixed(2)),
          bidCount: random.nextInt(12) + 1,
        ),
      );
    }

    for (int i = 0; i < 28; i++) {
      final category = _catalogs[random.nextInt(_catalogs.length)];
      final maxPrice = 100 + random.nextInt(1500) + random.nextDouble();
      intents.add(
        BuyIntent(
          id: 'intent_$i',
          buyerId: 'buyer_${random.nextInt(16)}',
          title: 'أبحث عن ${_titleFor(category, random.nextInt(90))}',
          category: category,
          maxPrice: double.parse(maxPrice.toStringAsFixed(2)),
          condition: _conditions[random.nextInt(_conditions.length)],
          notes: 'تفاصيل إضافية عن رغبة الشراء.',
          status: random.nextBool() ? 'active' : 'closed',
          createdAt: DateTime.now().toUtc().subtract(Duration(days: random.nextInt(90))),
        ),
      );
    }

    for (int i = 0; i < 80; i++) {
      final listing = listings[random.nextInt(listings.length)];
      final amount = listing.currentBid + random.nextInt(200) + random.nextDouble();
      bids.add(
        Bid(
          id: 'bid_$i',
          listingId: listing.id,
          userId: 'user_${random.nextInt(10)}',
          amount: double.parse(amount.toStringAsFixed(2)),
          createdAt: DateTime.now().toUtc().subtract(Duration(hours: random.nextInt(240))),
          status: ['placed', 'winning', 'lost'][random.nextInt(3)],
        ),
      );
    }

    for (int i = 0; i < 32; i++) {
      favorites.add(
        Favorite(
          userId: 'user_${random.nextInt(10)}',
          itemId: items[random.nextInt(items.length)].id,
          createdAt: DateTime.now().toUtc().subtract(Duration(days: random.nextInt(100))),
        ),
      );
    }

    notifications.addAll(
      List<NotificationEntry>.generate(12, (index) {
        return NotificationEntry(
          id: 'notif_$index',
          title: 'تنبيه مزايدة #$index',
          body: 'تم تحديث حالة المزايدة الخاصة بك.',
          type: index.isEven ? 'bid' : 'match',
          createdAt: DateTime.now().toUtc().subtract(Duration(hours: index * 4)),
        );
      }),
    );

    return SeedBundle(
      items: items,
      listings: listings,
      intents: intents,
      bids: bids,
      favorites: favorites,
      notifications: notifications,
    );
  }

  static String _titleFor(String catalog, int index) {
    switch (catalog) {
      case 'إلكترونيات':
        return 'جهاز إلكتروني مميز ${index + 1}';
      case 'موضة':
        return 'قطعة موضة ${index + 1}';
      case 'منزل':
        return 'منتج منزلي ${index + 1}';
      case 'رياضة':
        return 'معدات رياضية ${index + 1}';
      case 'مقتنيات':
        return 'قطعة مقتنيات ${index + 1}';
      case 'كتب':
        return 'كتاب مميز ${index + 1}';
      case 'سيارات':
        return 'سيارة خاصة ${index + 1}';
    }
    return 'منتج $catalog ${index + 1}';
  }

  static String _subtitleFor(String catalog) {
    switch (catalog) {
      case 'إلكترونيات':
        return 'أحدث الإصدارات الذكية';
      case 'موضة':
        return 'إطلالات معاصرة';
      case 'منزل':
        return 'راحة وأناقة للمكان';
      case 'رياضة':
        return 'جاهز للتحديات';
      case 'مقتنيات':
        return 'قطع نادرة لهواة الجمع';
      case 'كتب':
        return 'معرفة وإلهام';
      case 'سيارات':
        return 'إصدارات محدودة';
    }
    return 'منتجات مميزة';
  }
}
