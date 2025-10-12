import 'package:flutter/foundation.dart';

@immutable
class SellListing {
  const SellListing({
    required this.id,
    required this.itemId,
    required this.sellerId,
    required this.askPrice,
    required this.status,
    required this.createdAt,
    required this.endAt,
    required this.currentBid,
    required this.bidCount,
  });

  final String id;
  final String itemId;
  final String sellerId;
  final double askPrice;
  final String status;
  final DateTime createdAt;
  final DateTime endAt;
  final double currentBid;
  final int bidCount;

  SellListing copyWith({
    double? currentBid,
    DateTime? endAt,
    int? bidCount,
    String? status,
  }) {
    return SellListing(
      id: id,
      itemId: itemId,
      sellerId: sellerId,
      askPrice: askPrice,
      status: status ?? this.status,
      createdAt: createdAt,
      endAt: endAt ?? this.endAt,
      currentBid: currentBid ?? this.currentBid,
      bidCount: bidCount ?? this.bidCount,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'itemId': itemId,
      'sellerId': sellerId,
      'askPrice': askPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'endAt': endAt.toIso8601String(),
      'currentBid': currentBid,
      'bidCount': bidCount,
    };
  }

  factory SellListing.fromJson(Map<String, dynamic> json) {
    return SellListing(
      id: json['id'] as String,
      itemId: json['itemId'] as String,
      sellerId: json['sellerId'] as String,
      askPrice: (json['askPrice'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      endAt: DateTime.parse(json['endAt'] as String),
      currentBid: (json['currentBid'] as num).toDouble(),
      bidCount: json['bidCount'] as int,
    );
  }
}
