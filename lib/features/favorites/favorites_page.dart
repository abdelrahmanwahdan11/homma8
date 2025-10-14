import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/wanted_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ValueListenableBuilder<Set<String>>(
        valueListenable: appState.favoritesNotifier,
        builder: (context, favorites, _) {
          if (favorites.isEmpty) {
            return const Center(child: Text('No favorites yet'));
          }
          final auctions = RepoProvider.auctionRepository.all
              .where((auction) => favorites.contains(auction.id))
              .toList();
          final wanteds = RepoProvider.wantedRepository.all
              .where((wanted) => favorites.contains(wanted.id))
              .toList();
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index < auctions.length) {
                        return AuctionCard(auction: auctions[index], appState: appState);
                      }
                      final wanted = wanteds[index - auctions.length];
                      return WantedCard(wanted: wanted);
                    },
                    childCount: auctions.length + wanteds.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.8,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
