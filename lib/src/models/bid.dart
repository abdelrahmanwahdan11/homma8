import 'package:flutter/foundation.dart';

@immutable
class Bid {
  const Bid({
    required this.id,
    required this.listingId,
    required this.userId,
    required this.amount,
    required this.createdAt,
    required this.status,
  });

  final String id;
  final String listingId;
  final String userId;
  final double amount;
  final DateTime createdAt;
  final String status;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'listingId': listingId,
      'userId': userId,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'status': status,
    };
  }

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'] as String,
      listingId: json['listingId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: json['status'] as String,
    );
  }
}
