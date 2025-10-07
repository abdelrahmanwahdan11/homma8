class PriceAlert {
  PriceAlert({
    required this.title,
    required this.minPrice,
    required this.maxPrice,
    required this.category,
    required this.location,
    required this.active,
  });

  final String title;
  final double minPrice;
  final double maxPrice;
  final String category;
  final String location;
  final bool active;

  factory PriceAlert.fromJson(Map<String, dynamic> json) => PriceAlert(
        title: json['title'] as String,
        minPrice: (json['minPrice'] as num).toDouble(),
        maxPrice: (json['maxPrice'] as num).toDouble(),
        category: json['category'] as String,
        location: json['location'] as String,
        active: json['active'] as bool? ?? true,
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'minPrice': minPrice,
        'maxPrice': maxPrice,
        'category': category,
        'location': location,
        'active': active,
      };
}
