import 'package:flutter/foundation.dart';

@immutable
class BidModel {
  const BidModel({
    required this.id,
    required this.auctionId,
    required this.userId,
    required this.amount,
    required this.timestamp,
  });

  final String id;
  final String auctionId;
  final String userId;
  final double amount;
  final DateTime timestamp;

  factory BidModel.fromJson(Map<String, dynamic> json) => BidModel(
        id: json['id'] as String,
        auctionId: json['auctionId'] as String,
        userId: json['userId'] as String,
        amount: (json['amount'] as num).toDouble(),
        timestamp: DateTime.parse(json['timestamp'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'auctionId': auctionId,
        'userId': userId,
        'amount': amount,
        'timestamp': timestamp.toIso8601String(),
      };
}
