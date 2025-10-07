import 'dart:convert';

class AuctionItem {
  AuctionItem({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    required this.images,
    required this.location,
    required this.distanceKm,
    required this.currentBid,
    required this.startPrice,
    this.buyNowPrice,
    required this.currency,
    required this.startAt,
    required this.endAt,
    required this.specs,
    required this.isFavorite,
    required this.watching,
    required this.views,
    required this.aiSummary,
  });

  final String id;
  final String category;
  final String title;
  final String description;
  final List<String> images;
  final String location;
  final double distanceKm;
  final double currentBid;
  final double startPrice;
  final double? buyNowPrice;
  final String currency;
  final DateTime startAt;
  final DateTime endAt;
  final Map<String, String> specs;
  final bool isFavorite;
  final bool watching;
  final int views;
  final String aiSummary;

  bool get isLive {
    final now = DateTime.now();
    return now.isAfter(startAt) && now.isBefore(endAt);
  }

  bool get isUpcoming => DateTime.now().isBefore(startAt);

  bool get isEnded => DateTime.now().isAfter(endAt);

  Duration get timeRemaining => endAt.difference(DateTime.now());

  factory AuctionItem.fromJson(Map<String, dynamic> json) => AuctionItem(
        id: json['id'] as String,
        category: json['category'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        images: (json['images'] as List<dynamic>).cast<String>(),
        location: json['location'] as String,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        currentBid: (json['currentBid'] as num).toDouble(),
        startPrice: (json['startPrice'] as num).toDouble(),
        buyNowPrice: json['buyNowPrice'] == null
            ? null
            : (json['buyNowPrice'] as num).toDouble(),
        currency: json['currency'] as String,
        startAt: DateTime.parse(json['startAt'] as String),
        endAt: DateTime.parse(json['endAt'] as String),
        specs: (json['specs'] as Map<String, dynamic>)
            .map((key, value) => MapEntry(key, value as String)),
        isFavorite: json['isFavorite'] as bool? ?? false,
        watching: json['watching'] as bool? ?? false,
        views: json['views'] as int? ?? 0,
        aiSummary: json['aiSummary'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'description': description,
        'images': images,
        'location': location,
        'distanceKm': distanceKm,
        'currentBid': currentBid,
        'startPrice': startPrice,
        'buyNowPrice': buyNowPrice,
        'currency': currency,
        'startAt': startAt.toIso8601String(),
        'endAt': endAt.toIso8601String(),
        'specs': specs,
        'isFavorite': isFavorite,
        'watching': watching,
        'views': views,
        'aiSummary': aiSummary,
      };

  static List<AuctionItem> listFromJson(String data) {
    final decoded = jsonDecode(data) as List<dynamic>;
    return decoded.map((e) => AuctionItem.fromJson(e as Map<String, dynamic>)).toList();
  }

  AuctionItem copyWith({
    double? currentBid,
    bool? isFavorite,
    bool? watching,
  }) {
    return AuctionItem(
      id: id,
      category: category,
      title: title,
      description: description,
      images: images,
      location: location,
      distanceKm: distanceKm,
      currentBid: currentBid ?? this.currentBid,
      startPrice: startPrice,
      buyNowPrice: buyNowPrice,
      currency: currency,
      startAt: startAt,
      endAt: endAt,
      specs: specs,
      isFavorite: isFavorite ?? this.isFavorite,
      watching: watching ?? this.watching,
      views: views,
      aiSummary: aiSummary,
    );
  }
}
