import 'package:flutter/material.dart';

class PriceAlert {
  PriceAlert({
    required this.title,
    required this.minPrice,
    required this.maxPrice,
  }) : activeNotifier = ValueNotifier<bool>(true);

  final String title;
  final double minPrice;
  final double maxPrice;
  final ValueNotifier<bool> activeNotifier;

  void toggle() {
    activeNotifier.value = !activeNotifier.value;
  }

  void dispose() {
    activeNotifier.dispose();
  }
}
