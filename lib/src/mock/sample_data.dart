import '../models/listing.dart';
import '../models/request_item.dart';

class SampleData {
  static List<Listing> listings() {
    return <Listing>[
      Listing(
        id: 'L1',
        sellerId: 'U10',
        title: 'iPhone 14 - 128GB - أسود',
        description: 'حالة ممتازة، مع علبة وشاحن.',
        category: 'هواتف',
        condition: 'ممتاز',
        city: 'الرياض',
        images: const <String>['https://picsum.photos/seed/1/900/600'],
        startPrice: 350,
        reservePrice: 450,
        buyNow: 520,
        startAt: DateTime.parse('2025-10-01T10:00:00Z'),
        endAt: DateTime.parse('2025-10-31T10:00:00Z'),
        status: 'live',
        currentPrice: 400,
        minIncrement: 10,
        watchersCount: 22,
      ),
      Listing(
        id: 'L2',
        sellerId: 'U30',
        title: 'PlayStation 5 - Digital',
        description: 'كالجديد، مع يد تحكم واحدة.',
        category: 'ألعاب',
        condition: 'جيد جدًا',
        city: 'جدة',
        images: const <String>['https://picsum.photos/seed/2/900/600'],
        startPrice: 250,
        reservePrice: 320,
        buyNow: 389,
        startAt: DateTime.parse('2025-10-05T10:00:00Z'),
        endAt: DateTime.parse('2025-10-28T18:00:00Z'),
        status: 'live',
        currentPrice: 290,
        minIncrement: 5,
        watchersCount: 10,
      ),
    ];
  }

  static List<RequestItem> requests() {
    return <RequestItem>[
      RequestItem(
        id: 'R1',
        buyerId: 'U20',
        title: 'أريد iPhone 14',
        specs: 'لون أسود، حالة ممتازة',
        maxPrice: 500,
        location: 'جدة',
        expiresAt: DateTime.parse('2025-11-30T00:00:00Z'),
        reverseMode: false,
        status: 'open',
      ),
    ];
  }
}
