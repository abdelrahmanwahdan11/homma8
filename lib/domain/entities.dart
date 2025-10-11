import 'package:flutter/material.dart';

enum ProductStatus { active, sold, paused, draft }

enum Condition { newCondition, likeNew, good, fair }

Condition conditionFromString(String value) {
  switch (value) {
    case 'new':
      return Condition.newCondition;
    case 'likeNew':
      return Condition.likeNew;
    case 'good':
      return Condition.good;
    case 'fair':
      return Condition.fair;
    default:
      return Condition.good;
  }
}

String conditionLabel(Condition condition, Map<String, String> labels) {
  switch (condition) {
    case Condition.newCondition:
      return labels['new'] ?? 'New';
    case Condition.likeNew:
      return labels['likeNew'] ?? 'Like new';
    case Condition.good:
      return labels['good'] ?? 'Good';
    case Condition.fair:
      return labels['fair'] ?? 'Fair';
  }
}

class Product {
  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.images,
    required this.category,
    required this.condition,
    required this.isAuction,
    required this.basePrice,
    required this.currentPrice,
    required this.discountPercent,
    required this.demandCount,
    required this.watchers,
    required this.sellerId,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final List<String> images;
  final String category;
  final Condition condition;
  final bool isAuction;
  final double basePrice;
  final double currentPrice;
  final double discountPercent;
  final int demandCount;
  final int watchers;
  final String sellerId;
  final DateTime createdAt;
  final ProductStatus status;

  Product copyWith({
    double? currentPrice,
    double? discountPercent,
    int? demandCount,
    int? watchers,
  }) {
    return Product(
      id: id,
      title: title,
      description: description,
      images: images,
      category: category,
      condition: condition,
      isAuction: isAuction,
      basePrice: basePrice,
      currentPrice: currentPrice ?? this.currentPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      demandCount: demandCount ?? this.demandCount,
      watchers: watchers ?? this.watchers,
      sellerId: sellerId,
      createdAt: createdAt,
      status: status,
    );
  }
}

class Bid {
  const Bid({required this.userId, required this.amount, required this.time});

  final String userId;
  final double amount;
  final DateTime time;
}

class Auction {
  Auction({
    required this.productId,
    required this.currentBid,
    required this.minIncrement,
    required this.endsAt,
    required this.bids,
  });

  final String productId;
  final double currentBid;
  final double minIncrement;
  final DateTime endsAt;
  final List<Bid> bids;

  Auction copyWith({double? currentBid, List<Bid>? bids}) {
    return Auction(
      productId: productId,
      currentBid: currentBid ?? this.currentBid,
      minIncrement: minIncrement,
      endsAt: endsAt,
      bids: bids ?? this.bids,
    );
  }
}

class WantedItem {
  WantedItem({
    required this.id,
    required this.title,
    required this.category,
    required this.targetPrice,
    required this.notes,
  });

  final String id;
  final String title;
  final String category;
  final double targetPrice;
  final String notes;
}

class PriceAlert {
  PriceAlert({
    required this.wantedId,
    required this.productId,
    required this.matchedAt,
  });

  final String wantedId;
  final String productId;
  final DateTime matchedAt;
}
