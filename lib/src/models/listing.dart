import 'package:flutter/foundation.dart';

@immutable
class Listing {
  const Listing({
    required this.id,
    required this.sellerId,
    required this.title,
    required this.description,
    required this.category,
    required this.condition,
    required this.city,
    required this.images,
    required this.startPrice,
    required this.reservePrice,
    required this.buyNow,
    required this.startAt,
    required this.endAt,
    required this.status,
    required this.currentPrice,
    required this.minIncrement,
    required this.watchersCount,
  });

  final String id;
  final String sellerId;
  final String title;
  final String description;
  final String category;
  final String condition;
  final String city;
  final List<String> images;
  final double startPrice;
  final double? reservePrice;
  final double? buyNow;
  final DateTime startAt;
  final DateTime endAt;
  final String status;
  final double currentPrice;
  final double minIncrement;
  final int watchersCount;

  Listing copyWith({
    double? currentPrice,
    DateTime? endAt,
  }) {
    return Listing(
      id: id,
      sellerId: sellerId,
      title: title,
      description: description,
      category: category,
      condition: condition,
      city: city,
      images: images,
      startPrice: startPrice,
      reservePrice: reservePrice,
      buyNow: buyNow,
      startAt: startAt,
      endAt: endAt ?? this.endAt,
      status: status,
      currentPrice: currentPrice ?? this.currentPrice,
      minIncrement: minIncrement,
      watchersCount: watchersCount,
    );
  }
}
