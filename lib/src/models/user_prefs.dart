import 'package:flutter/foundation.dart';

@immutable
class UserPrefs {
  const UserPrefs({
    this.favCategories = const <String>[],
    this.priceMin,
    this.priceMax,
    this.locale = 'ar',
    this.themeMode = 'dark',
  });

  final List<String> favCategories;
  final double? priceMin;
  final double? priceMax;
  final String locale;
  final String themeMode;

  UserPrefs copyWith({
    List<String>? favCategories,
    double? priceMin,
    double? priceMax,
    String? locale,
    String? themeMode,
  }) {
    return UserPrefs(
      favCategories: favCategories ?? this.favCategories,
      priceMin: priceMin ?? this.priceMin,
      priceMax: priceMax ?? this.priceMax,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'favCategories': favCategories,
      'priceMin': priceMin,
      'priceMax': priceMax,
      'locale': locale,
      'themeMode': themeMode,
    };
  }

  factory UserPrefs.fromJson(Map<String, dynamic> json) {
    return UserPrefs(
      favCategories:
          (json['favCategories'] as List<dynamic>?)?.cast<String>() ?? const <String>[],
      priceMin: (json['priceMin'] as num?)?.toDouble(),
      priceMax: (json['priceMax'] as num?)?.toDouble(),
      locale: json['locale'] as String? ?? 'ar',
      themeMode: json['themeMode'] as String? ?? 'dark',
    );
  }
}
