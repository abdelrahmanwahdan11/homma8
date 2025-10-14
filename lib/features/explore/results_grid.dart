import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../data/models/auction.dart';
import '../../widgets/auction_card.dart';

class ExploreResultsGrid extends StatelessWidget {
  const ExploreResultsGrid({super.key, required this.items});

  final List<AuctionModel> items;

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    return SliverPadding(
      padding: const EdgeInsets.all(16),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => AuctionCard(auction: items[index], appState: appState),
          childCount: items.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
        ),
      ),
    );
  }
}
