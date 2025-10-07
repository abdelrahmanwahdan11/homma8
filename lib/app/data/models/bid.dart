class Bid {
  Bid({
    required this.itemId,
    required this.amount,
    required this.time,
    required this.status,
  });

  final String itemId;
  final double amount;
  final DateTime time;
  final String status;

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
        itemId: json['itemId'] as String,
        amount: (json['amount'] as num).toDouble(),
        time: DateTime.parse(json['time'] as String),
        status: json['status'] as String,
      );

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'amount': amount,
        'time': time.toIso8601String(),
        'status': status,
      };
}
