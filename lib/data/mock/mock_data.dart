import 'dart:math';

import '../../domain/entities.dart';

final List<Product> seedProducts = [
  Product(
    id: 'p1',
    title: 'Wireless Headphones',
    description: 'Over-ear, noise cancelling',
    images: const ['Wireless Headphones', 'Noise Cancelling'],
    category: 'Electronics',
    condition: Condition.likeNew,
    isAuction: false,
    basePrice: 120.0,
    currentPrice: 120.0,
    discountPercent: 0,
    demandCount: 14,
    watchers: 22,
    sellerId: 'u1',
    createdAt: DateTime.parse('2025-10-01T12:00:00Z'),
    status: ProductStatus.active,
  ),
  Product(
    id: 'p2',
    title: 'Vintage Camera',
    description: 'Film camera with 50mm lens',
    images: const ['Vintage Camera'],
    category: 'Photography',
    condition: Condition.good,
    isAuction: true,
    basePrice: 80.0,
    currentPrice: 96.0,
    discountPercent: 0,
    demandCount: 5,
    watchers: 15,
    sellerId: 'u2',
    createdAt: DateTime.parse('2025-10-02T10:00:00Z'),
    status: ProductStatus.active,
  ),
];

final Map<String, Auction> seedAuctions = {
  'p2': Auction(
    productId: 'p2',
    currentBid: 96.0,
    minIncrement: 4.0,
    endsAt: DateTime.now().add(const Duration(minutes: 45)),
    bids: [
      Bid(userId: 'u3', amount: 92.0, time: DateTime.now().subtract(const Duration(minutes: 30))),
      Bid(userId: 'u4', amount: 94.0, time: DateTime.now().subtract(const Duration(minutes: 20))),
      Bid(userId: 'u2', amount: 96.0, time: DateTime.now().subtract(const Duration(minutes: 5))),
    ],
  ),
};

List<Product> generateMoreProducts(int start, int count) {
  return List.generate(count, (index) {
    final i = start + index;
    final isAuction = i % 3 == 0;
    return Product(
      id: 'px$i',
      title: 'Demo Item $i',
      description: 'Generated product for browsing and swipe demo.',
      images: ['Demo Item $i'],
      category: isAuction ? 'Collectibles' : 'Lifestyle',
      condition: Condition.values[i % Condition.values.length],
      isAuction: isAuction,
      basePrice: 40 + i * 3.0,
      currentPrice: 40 + i * 3.0,
      discountPercent: 0,
      demandCount: Random().nextInt(30),
      watchers: 10 + Random().nextInt(25),
      sellerId: 'ux$i',
      createdAt: DateTime.now().subtract(Duration(days: i)),
      status: ProductStatus.active,
    );
  });
}
