import 'package:flutter/foundation.dart';

@immutable
class WantedModel {
  const WantedModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.specs,
    required this.maxPrice,
    required this.category,
    required this.location,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final String specs;
  final double maxPrice;
  final String category;
  final String location;
  final DateTime createdAt;

  factory WantedModel.fromJson(Map<String, dynamic> json) => WantedModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        title: json['title'] as String,
        specs: json['specs'] as String? ?? '',
        maxPrice: (json['maxPrice'] as num).toDouble(),
        category: json['category'] as String? ?? '',
        location: json['location'] as String? ?? '',
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'specs': specs,
        'maxPrice': maxPrice,
        'category': category,
        'location': location,
        'createdAt': createdAt.toIso8601String(),
      };
}
