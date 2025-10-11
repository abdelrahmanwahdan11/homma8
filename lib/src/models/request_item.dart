import 'package:flutter/foundation.dart';

@immutable
class RequestItem {
  const RequestItem({
    required this.id,
    required this.buyerId,
    required this.title,
    required this.specs,
    required this.maxPrice,
    required this.location,
    required this.expiresAt,
    required this.reverseMode,
    required this.status,
  });

  final String id;
  final String buyerId;
  final String title;
  final String specs;
  final double maxPrice;
  final String location;
  final DateTime expiresAt;
  final bool reverseMode;
  final String status;
}
