import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../models/listing.dart';

class AuctionDetailsPage extends StatelessWidget {
  const AuctionDetailsPage({super.key, required this.listing});

  final Listing listing;

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final remaining = app.timeLeft(listing);
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل المزاد')),
      body: ListView(
        children: <Widget>[
          SizedBox(
            height: 280,
            child: PageView(
              children: listing.images
                  .map(
                    (url) => Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(listing.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(listing.description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('السعر الحالي: ${listing.currentPrice}'),
                    Text('الوقت: ${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}'),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('رجوع'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
