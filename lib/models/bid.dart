import 'dart:async';

import 'package:flutter/material.dart';

import 'auction_item.dart';

class Bid {
  Bid({required this.item}) {
    timeLeftNotifier = ValueNotifier<Duration>(item.remainingTime);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = item.remainingTime;
      timeLeftNotifier.value = remaining;
      if (remaining == Duration.zero) {
        timer.cancel();
      }
    });
  }

  final AuctionItem item;
  late final ValueNotifier<Duration> timeLeftNotifier;
  Timer? _ticker;

  void dispose() {
    _ticker?.cancel();
    timeLeftNotifier.dispose();
  }
}
