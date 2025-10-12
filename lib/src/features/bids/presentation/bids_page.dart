import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/formatters.dart';

class BidsPage extends StatelessWidget {
  const BidsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final bids = state.myBids;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.bids)),
      body: bids.isEmpty
          ? Center(child: Text(context.l10n.noResults))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bids.length,
              itemBuilder: (context, index) {
                final bid = bids[index];
                final matches = state.listings.where((listing) => listing.id == bid.listingId).toList();
                if (matches.isEmpty) {
                  return const SizedBox.shrink();
                }
                final listing = matches.first;
                final item = state.itemForListing(listing);
                if (item == null) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text('${Formatters.currency(bid.amount)} • ${bid.status}'),
                    trailing: Text(Formatters.relativeDate(bid.createdAt)),
                    onTap: () => AppRouterDelegate.of(context).push('/item/${item.id}'),
                  ),
                );
              },
            ),
    );
  }
}
