import 'package:flutter/material.dart';

import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/refresh/refresh_hub.dart';
import '../../../core/utils/formatters.dart';

class ItemDetailsPage extends StatelessWidget {
  const ItemDetailsPage({super.key, required this.itemId});

  final String itemId;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final item = state.items.firstWhere((element) => element.id == itemId);
    final listing = state.listings.firstWhere((listing) => listing.itemId == item.id);
    return RefreshHub(
      controller: state.refreshHub,
      child: Scaffold(
        appBar: AppBar(title: Text(item.title)),
        body: ListView(
          children: [
            Hero(
              tag: 'item_card_${item.id}',
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.network(item.image, fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Chip(label: Text(item.category)),
                      const SizedBox(width: 8),
                      Chip(label: Text(item.condition)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  RefreshSlot(
                    sectionId: 'listing_${listing.id}',
                    builder: (context) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Formatters.currency(listing.currentBid), style: Theme.of(context).textTheme.headlineMedium),
                        Text('${context.l10n.timeLeft}: ${Formatters.timeLeft(listing.endAt.difference(DateTime.now()))}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      final amount = state.quickBidAmount(listing);
                      state.placeBid(listingId: listing.id, amount: amount);
                    },
                    child: Text(context.l10n.placeBid),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
