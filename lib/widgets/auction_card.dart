import 'package:flutter/material.dart';

import '../app.dart';
import '../core/app_state/app_state.dart';
import '../core/localization/app_localizations.dart';
import '../data/models/auction.dart';
import 'media_placeholder.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({super.key, required this.auction, required this.appState});

  final AuctionModel auction;
  final AppState appState;

  @override
  Widget build(BuildContext context) {
    final heroTag = 'hero_auction_image_${auction.id}';
    final l10n = context.l10n;
    return InkWell(
      onTap: () => context.appRouter.push(AppRouteConfig('auction', arguments: {'id': auction.id})),
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        header: Align(
          alignment: Alignment.topRight,
          child: ValueListenableBuilder<Set<String>>(
            valueListenable: appState.favoritesNotifier,
            builder: (context, favorites, _) {
              final isFav = favorites.contains(auction.id);
              return IconButton(
                tooltip: l10n.favorites,
                onPressed: () => appState.toggleFavorite(auction.id),
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    isFav ? Icons.bookmark : Icons.bookmark_border,
                    key: ValueKey<bool>(isFav),
                    color: isFav ? Theme.of(context).colorScheme.primary : null,
                  ),
                ),
              );
            },
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(auction.title, style: Theme.of(context).textTheme.titleLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text(l10n.usdAmount(amount: auction.priceNow.toStringAsFixed(0)),
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Hero(
                  tag: 'hero_wanted_chip_${auction.id}',
                  child: Chip(
                    label: Text(
                      l10n.bidsAndLocation(
                        bids: (auction.stats['bids'] as num?)?.toInt() ?? 0,
                        location: auction.location,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        child: Hero(
          tag: heroTag,
          child: MediaPlaceholder(
            seed: auction.images.isNotEmpty ? '${auction.id}_${auction.images.first}' : auction.id,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
