import 'package:flutter/foundation.dart';

@immutable
class Favorite {
  const Favorite({
    required this.userId,
    required this.itemId,
    required this.createdAt,
  });

  final String userId;
  final String itemId;
  final DateTime createdAt;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'itemId': itemId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Favorite.fromJson(Map<String, dynamic> json) {
    return Favorite(
      userId: json['userId'] as String,
      itemId: json['itemId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
