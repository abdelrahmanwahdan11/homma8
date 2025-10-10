import 'dart:math';

import 'models.dart';

class MockData {
  static final _random = Random(42);

  static List<Product> products() {
    final now = DateTime.now();
    return List.generate(12, (index) {
      final id = 'product_$index';
      return Product(
        id: id,
        title: 'Concept ${index + 1}',
        images: [
          'https://picsum.photos/seed/${index + 1}/800/600',
          'https://picsum.photos/seed/${index + 11}/800/600',
          'https://picsum.photos/seed/${index + 21}/800/600',
        ],
        priceCurrent: 150 + _random.nextDouble() * 450,
        endTime: now.add(Duration(hours: 6 + index * 2)),
        seller: 'SouqBid Studio',
        bidsCount: 10 + index * 3,
        discount: 5 + _random.nextInt(30),
        tags: ['design', 'limited', 'mock'],
      );
    });
  }

  static List<Product> offers() {
    return products().map((product) {
      final discount = product.discount + 10;
      return product.copyWith(
        priceCurrent: product.priceCurrent * (1 - discount / 100),
      );
    }).toList();
  }
}
