import 'package:flutter/foundation.dart';

@immutable
class AuctionModel {
  const AuctionModel({
    required this.id,
    required this.title,
    required this.desc,
    required this.images,
    required this.category,
    required this.priceStart,
    required this.priceNow,
    required this.endsAt,
    required this.location,
    required this.sellerId,
    required this.stats,
  });

  final String id;
  final String title;
  final String desc;
  final List<String> images;
  final String category;
  final double priceStart;
  final double priceNow;
  final DateTime endsAt;
  final String location;
  final String sellerId;
  final Map<String, dynamic> stats;

  AuctionModel copyWith({
    String? id,
    String? title,
    String? desc,
    List<String>? images,
    String? category,
    double? priceStart,
    double? priceNow,
    DateTime? endsAt,
    String? location,
    String? sellerId,
    Map<String, dynamic>? stats,
  }) {
    return AuctionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      images: images ?? this.images,
      category: category ?? this.category,
      priceStart: priceStart ?? this.priceStart,
      priceNow: priceNow ?? this.priceNow,
      endsAt: endsAt ?? this.endsAt,
      location: location ?? this.location,
      sellerId: sellerId ?? this.sellerId,
      stats: stats ?? this.stats,
    );
  }

  factory AuctionModel.fromJson(Map<String, dynamic> json) {
    return AuctionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      desc: json['desc'] as String,
      images: List<String>.from(json['images'] as List? ?? <String>[]),
      category: json['category'] as String? ?? '',
      priceStart: (json['priceStart'] as num?)?.toDouble() ?? 0,
      priceNow: (json['priceNow'] as num?)?.toDouble() ?? 0,
      endsAt: DateTime.parse(json['endsAt'] as String),
      location: json['location'] as String? ?? '',
      sellerId: json['sellerId'] as String? ?? '',
      stats: Map<String, dynamic>.from(json['stats'] as Map? ?? <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'images': images,
        'category': category,
        'priceStart': priceStart,
        'priceNow': priceNow,
        'endsAt': endsAt.toIso8601String(),
        'location': location,
        'sellerId': sellerId,
        'stats': stats,
      };
}
