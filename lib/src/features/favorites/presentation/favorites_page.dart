import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/models.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final favorites = state.favoriteListings;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.favorites)),
      body: favorites.isEmpty
          ? Center(child: Text(context.l10n.noResults))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final listing = favorites[index];
                final item = state.itemForListing(listing);
                if (item == null) {
                  return const SizedBox.shrink();
                }
                return Card(
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(Formatters.currency(listing.currentBid)),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite),
                      onPressed: () => state.toggleFavorite(item.id),
                    ),
                    onTap: () => AppRouterDelegate.of(context).push('/item/${item.id}'),
                  ),
                );
              },
            ),
    );
  }
}
