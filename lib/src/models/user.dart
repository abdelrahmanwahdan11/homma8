import 'package:flutter/foundation.dart';

import 'user_prefs.dart';

@immutable
class User {
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.referralCode,
    required this.prefs,
    this.referredBy,
  });

  final String id;
  final String name;
  final String email;
  final String referralCode;
  final String? referredBy;
  final UserPrefs prefs;

  User copyWith({
    String? name,
    String? email,
    String? referralCode,
    String? referredBy,
    UserPrefs? prefs,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      referralCode: referralCode ?? this.referralCode,
      referredBy: referredBy ?? this.referredBy,
      prefs: prefs ?? this.prefs,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'email': email,
      'referralCode': referralCode,
      'referredBy': referredBy,
      'prefs': prefs.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      referralCode: json['referralCode'] as String,
      referredBy: json['referredBy'] as String?,
      prefs: UserPrefs.fromJson(json['prefs'] as Map<String, dynamic>),
    );
  }
}
