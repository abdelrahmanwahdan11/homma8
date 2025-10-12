import 'package:flutter/foundation.dart';

@immutable
class BuyIntent {
  const BuyIntent({
    required this.id,
    required this.buyerId,
    required this.title,
    required this.category,
    required this.maxPrice,
    required this.condition,
    required this.notes,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String buyerId;
  final String title;
  final String category;
  final double maxPrice;
  final String condition;
  final String notes;
  final String status;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'buyerId': buyerId,
      'title': title,
      'category': category,
      'maxPrice': maxPrice,
      'condition': condition,
      'notes': notes,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory BuyIntent.fromJson(Map<String, dynamic> json) {
    return BuyIntent(
      id: json['id'] as String,
      buyerId: json['buyerId'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      maxPrice: (json['maxPrice'] as num).toDouble(),
      condition: json['condition'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
