import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  const UserModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isGuest,
    required this.prefs,
  });

  final String id;
  final String name;
  final String avatar;
  final bool isGuest;
  final Map<String, dynamic> prefs;

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    bool? isGuest,
    Map<String, dynamic>? prefs,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      isGuest: isGuest ?? this.isGuest,
      prefs: prefs ?? this.prefs,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String? ?? '',
      isGuest: json['isGuest'] as bool? ?? false,
      prefs: Map<String, dynamic>.from(json['prefs'] as Map? ?? <String, dynamic>{}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'isGuest': isGuest,
      'prefs': prefs,
    };
  }
}
