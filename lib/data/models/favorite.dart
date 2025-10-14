import 'package:flutter/foundation.dart';

@immutable
class FavoriteModel {
  const FavoriteModel({
    required this.id,
    required this.type,
    required this.refId,
    required this.userId,
  });

  final String id;
  final String type;
  final String refId;
  final String userId;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
        id: json['id'] as String,
        type: json['type'] as String,
        refId: json['refId'] as String,
        userId: json['userId'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'refId': refId,
        'userId': userId,
      };
}
