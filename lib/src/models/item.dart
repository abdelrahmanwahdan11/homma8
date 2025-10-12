import 'package:flutter/foundation.dart';

@immutable
class Item {
  const Item({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.description,
    required this.category,
    required this.condition,
    required this.locationText,
    required this.basePrice,
    required this.endAt,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String subtitle;
  final String image;
  final String description;
  final String category;
  final String condition;
  final String locationText;
  final double basePrice;
  final DateTime endAt;
  final List<String> tags;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image': image,
      'description': description,
      'category': category,
      'condition': condition,
      'locationText': locationText,
      'basePrice': basePrice,
      'endAt': endAt.toIso8601String(),
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      image: json['image'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      condition: json['condition'] as String,
      locationText: json['locationText'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      endAt: DateTime.parse(json['endAt'] as String),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
