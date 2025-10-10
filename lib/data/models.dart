import 'dart:convert';

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.images,
    required this.priceCurrent,
    required this.endTime,
    required this.seller,
    required this.bidsCount,
    required this.discount,
    required this.tags,
  });

  final String id;
  final String title;
  final List<String> images;
  final double priceCurrent;
  final DateTime endTime;
  final String seller;
  final int bidsCount;
  final double discount;
  final List<String> tags;

  Duration get timeLeft => endTime.difference(DateTime.now());

  Product copyWith({
    double? priceCurrent,
    DateTime? endTime,
    int? bidsCount,
  }) {
    return Product(
      id: id,
      title: title,
      images: images,
      priceCurrent: priceCurrent ?? this.priceCurrent,
      endTime: endTime ?? this.endTime,
      seller: seller,
      bidsCount: bidsCount ?? this.bidsCount,
      discount: discount,
      tags: tags,
    );
  }
}

class Bid {
  const Bid({
    required this.id,
    required this.productId,
    required this.userId,
    required this.amount,
    required this.time,
  });

  final String id;
  final String productId;
  final String userId;
  final double amount;
  final DateTime time;
}

class UserSession {
  const UserSession({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.rating,
    this.isGuest = false,
  });

  final String id;
  final String name;
  final String email;
  final String avatar;
  final double rating;
  final bool isGuest;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'avatar': avatar,
        'rating': rating,
        'isGuest': isGuest,
      };

  factory UserSession.fromJson(Map<String, dynamic> json) {
    return UserSession(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      rating: (json['rating'] as num).toDouble(),
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }
}

class WantedRequest {
  const WantedRequest({
    required this.id,
    required this.title,
    required this.targetPrice,
    required this.description,
    required this.city,
    required this.expiresAt,
  });

  final String id;
  final String title;
  final double targetPrice;
  final String description;
  final String city;
  final DateTime? expiresAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'targetPrice': targetPrice,
        'description': description,
        'city': city,
        'expiresAt': expiresAt?.toIso8601String(),
      };

  factory WantedRequest.fromJson(Map<String, dynamic> json) {
    return WantedRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      targetPrice: (json['targetPrice'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      city: json['city'] as String? ?? '',
      expiresAt: (json['expiresAt'] as String?) != null
          ? DateTime.tryParse(json['expiresAt'] as String)
          : null,
    );
  }

  String get formattedExpiry {
    if (expiresAt == null) return '';
    return '${expiresAt!.day}/${expiresAt!.month}/${expiresAt!.year}';
  }
}

extension ProductEncoding on Product {
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'images': images,
        'priceCurrent': priceCurrent,
        'endTime': endTime.toIso8601String(),
        'seller': seller,
        'bidsCount': bidsCount,
        'discount': discount,
        'tags': tags,
      };

  static Product fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      images: (json['images'] as List<dynamic>).cast<String>(),
      priceCurrent: (json['priceCurrent'] as num).toDouble(),
      endTime: DateTime.parse(json['endTime'] as String),
      seller: json['seller'] as String,
      bidsCount: json['bidsCount'] as int,
      discount: (json['discount'] as num).toDouble(),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
    );
  }
}

String encodeProducts(List<Product> products) =>
    jsonEncode(products.map((e) => e.toJson()).toList());

List<Product> decodeProducts(String source) {
  final data = jsonDecode(source) as List<dynamic>;
  return data.map((item) => ProductEncoding.fromJson(item as Map<String, dynamic>)).toList();
}

class AnalyticsSummary {
  const AnalyticsSummary({
    this.pageViews = const <String, int>{},
    this.secondsPerPage = const <String, int>{},
    this.bidsPlaced = 0,
    this.totalBidAmount = 0,
    this.favoriteToggles = 0,
    this.wantedCreated = 0,
    this.languageSwitches = 0,
  });

  final Map<String, int> pageViews;
  final Map<String, int> secondsPerPage;
  final int bidsPlaced;
  final double totalBidAmount;
  final int favoriteToggles;
  final int wantedCreated;
  final int languageSwitches;

  factory AnalyticsSummary.fromJson(Map<String, dynamic> json) {
    return AnalyticsSummary(
      pageViews: (json['pageViews'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry(key, (value as num).toInt())),
      secondsPerPage: (json['secondsPerPage'] as Map<String, dynamic>? ?? const {})
          .map((key, value) => MapEntry(key, (value as num).toInt())),
      bidsPlaced: (json['bidsPlaced'] as num?)?.toInt() ?? 0,
      totalBidAmount: (json['totalBidAmount'] as num?)?.toDouble() ?? 0,
      favoriteToggles: (json['favoriteToggles'] as num?)?.toInt() ?? 0,
      wantedCreated: (json['wantedCreated'] as num?)?.toInt() ?? 0,
      languageSwitches: (json['languageSwitches'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'pageViews': pageViews,
        'secondsPerPage': secondsPerPage,
        'bidsPlaced': bidsPlaced,
        'totalBidAmount': totalBidAmount,
        'favoriteToggles': favoriteToggles,
        'wantedCreated': wantedCreated,
        'languageSwitches': languageSwitches,
      };

  AnalyticsSummary copyWith({
    Map<String, int>? pageViews,
    Map<String, int>? secondsPerPage,
    int? bidsPlaced,
    double? totalBidAmount,
    int? favoriteToggles,
    int? wantedCreated,
    int? languageSwitches,
  }) {
    return AnalyticsSummary(
      pageViews: pageViews ?? this.pageViews,
      secondsPerPage: secondsPerPage ?? this.secondsPerPage,
      bidsPlaced: bidsPlaced ?? this.bidsPlaced,
      totalBidAmount: totalBidAmount ?? this.totalBidAmount,
      favoriteToggles: favoriteToggles ?? this.favoriteToggles,
      wantedCreated: wantedCreated ?? this.wantedCreated,
      languageSwitches: languageSwitches ?? this.languageSwitches,
    );
  }

  AnalyticsSummary recordPageView(String pageId) {
    final views = Map<String, int>.from(pageViews);
    views[pageId] = (views[pageId] ?? 0) + 1;
    return copyWith(pageViews: views);
  }

  AnalyticsSummary recordTimeSpent({required String pageId, required Duration duration}) {
    final seconds = duration.inSeconds;
    if (seconds <= 0) {
      return this;
    }
    final map = Map<String, int>.from(secondsPerPage);
    map[pageId] = (map[pageId] ?? 0) + seconds;
    return copyWith(secondsPerPage: map);
  }

  AnalyticsSummary recordBid({required String productId, required double amount}) {
    return copyWith(
      bidsPlaced: bidsPlaced + 1,
      totalBidAmount: totalBidAmount + amount,
    );
  }

  AnalyticsSummary recordFavorite(String productId) {
    return copyWith(favoriteToggles: favoriteToggles + 1);
  }

  AnalyticsSummary recordWanted() {
    return copyWith(wantedCreated: wantedCreated + 1);
  }

  AnalyticsSummary recordLanguageSwitch() {
    return copyWith(languageSwitches: languageSwitches + 1);
  }
}
