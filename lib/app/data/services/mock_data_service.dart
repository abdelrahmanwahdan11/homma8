import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../models/auction_item.dart';
import '../models/bid.dart';
import '../models/price_alert.dart';

class MockDataService extends GetxService {
  final items = <AuctionItem>[].obs;
  final bids = <Bid>[].obs;
  final alerts = <PriceAlert>[].obs;

  Future<MockDataService> init() async {
    final itemsData = await rootBundle.loadString('assets/mock/items.json');
    final bidsData = await rootBundle.loadString('assets/mock/bids.json');
    final alertsData = await rootBundle.loadString('assets/mock/alerts.json');

    items.assignAll(
      (jsonDecode(itemsData) as List<dynamic>)
          .map((e) => AuctionItem.fromJson(e as Map<String, dynamic>)),
    );
    bids.assignAll(
      (jsonDecode(bidsData) as List<dynamic>)
          .map((e) => Bid.fromJson(e as Map<String, dynamic>)),
    );
    alerts.assignAll(
      (jsonDecode(alertsData) as List<dynamic>)
          .map((e) => PriceAlert.fromJson(e as Map<String, dynamic>)),
    );
    return this;
  }

  List<AuctionItem> filter({
    String query = '',
    String? category,
  }) {
    final normalized = query.toLowerCase();
    return items.where((item) {
      final matchesQuery = normalized.isEmpty ||
          item.title.toLowerCase().contains(normalized) ||
          item.description.toLowerCase().contains(normalized) ||
          item.specs.values
              .any((element) => element.toLowerCase().contains(normalized));
      final matchesCategory = category == null || category == 'all'
          ? true
          : item.category == category;
      return matchesQuery && matchesCategory;
    }).toList();
  }
}
