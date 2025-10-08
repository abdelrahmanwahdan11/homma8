import 'package:flutter/material.dart';

class AuctionItem {
  AuctionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required double initialPrice,
    required Duration duration,
  })  : startingPrice = initialPrice,
        priceNotifier = ValueNotifier<double>(initialPrice),
        favoriteNotifier = ValueNotifier<bool>(false),
        hasBidNotifier = ValueNotifier<bool>(false),
        endTime = DateTime.now().add(duration);

  final String id;
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final double startingPrice;
  final ValueNotifier<double> priceNotifier;
  final ValueNotifier<bool> favoriteNotifier;
  final ValueNotifier<bool> hasBidNotifier;
  final DateTime endTime;

  void placeBid(double increment) {
    priceNotifier.value = priceNotifier.value + increment;
    hasBidNotifier.value = true;
  }

  void toggleFavorite() {
    favoriteNotifier.value = !favoriteNotifier.value;
  }

  Duration get remainingTime {
    final now = DateTime.now();
    final remaining = endTime.difference(now);
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  void dispose() {
    priceNotifier.dispose();
    favoriteNotifier.dispose();
    hasBidNotifier.dispose();
  }
}
