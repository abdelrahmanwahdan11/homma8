import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/refresh/refresh_hub.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/swipe_deck.dart';
import '../../../models/models.dart';

class SwipePage extends StatefulWidget {
  const SwipePage({super.key});

  @override
  State<SwipePage> createState() => _SwipePageState();
}

class _SwipePageState extends State<SwipePage> {
  final SwipeDeckController _controller = SwipeDeckController();
  static const double _deckHeight = 420;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    final listings = state.listings.where((listing) => listing.status == 'active').toList();
    return RefreshHub(
      controller: state.refreshHub,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async {
                  await Future<void>.delayed(const Duration(milliseconds: 700));
                  setState(() {});
                },
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: SizedBox(height: _deckHeight + 24)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverToBoxAdapter(
                        child: _SectionHeader(title: l10n.recommendedForYou),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: RefreshSlot(
                        sectionId: 'matches',
                        builder: (context) {
                          final suggestions = state.matches.sellerMatches.values.expand((value) => value).toList();
                          return _MatchesStrip(matches: suggestions);
                        },
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      sliver: SliverToBoxAdapter(
                        child: _FavoritesStrip(items: state.favoriteListings, fetchItem: state.itemForListing),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      sliver: SliverToBoxAdapter(child: _SectionHeader(title: l10n.bidsPageTitle)),
                    ),
                    SliverToBoxAdapter(
                      child: RefreshSlot(
                        sectionId: 'bids',
                        builder: (context) => _BidsStrip(bids: state.myBids, getListing: (id) => state.listings.firstWhere((listing) => listing.id == id)),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 120)),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: RefreshSlot(
                  sectionId: 'deck',
                  builder: (context) => SizedBox(
                    height: _deckHeight,
                    child: SwipeDeck(
                      itemCount: listings.length,
                      controller: _controller,
                      onAction: (action, index) => _handleAction(context, action, listings[index], state),
                      cardBuilder: (context, index) {
                        final listing = listings[index];
                        final item = state.itemForListing(listing)!;
                        return _AuctionCard(listing: listing, item: item);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleAction(BuildContext context, SwipeDeckAction action, SellListing listing, AppState state) {
    final item = state.itemForListing(listing);
    if (item == null) {
      return;
    }
    switch (action) {
      case SwipeDeckAction.like:
        state.toggleFavorite(item.id);
        break;
      case SwipeDeckAction.pass:
        state.recordView(item.id);
        break;
      case SwipeDeckAction.open:
        AppRouterDelegate.of(context).push('/item/${item.id}');
        break;
      case SwipeDeckAction.quickBid:
        final amount = state.quickBidAmount(listing);
        state.placeBid(listingId: listing.id, amount: amount);
        break;
    }
  }
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({required this.listing, required this.item});

  final SellListing listing;
  final Item item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = AppScope.of(context);
    final timeLeft = item.endAt.difference(DateTime.now());
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Hero(
            tag: 'item_card_${item.id}',
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(item.image, fit: BoxFit.cover),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Chip(label: Text(item.category)),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    right: 12,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white)),
                            const SizedBox(height: 4),
                            Text('${Formatters.currency(listing.currentBid)} • ${item.locationText}', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Formatters.currency(listing.currentBid), style: theme.textTheme.titleMedium),
                Text('${state.matches.forListing(listing.id).length} ${context.l10n.matchedForYourRequest}', style: theme.textTheme.labelSmall),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(context.l10n.timeLeft, style: theme.textTheme.labelSmall),
                Text(Formatters.timeLeft(timeLeft), style: theme.textTheme.titleMedium),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(title, style: theme.textTheme.titleLarge);
  }
}

class _MatchesStrip extends StatelessWidget {
  const _MatchesStrip({required this.matches});

  final List<MatchSuggestion> matches;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return SizedBox(
      height: 160,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final suggestion = matches[index];
          return Container(
            width: 220,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestion.intent.title, style: theme.textTheme.titleMedium),
                const Spacer(),
                Text('Match ${(suggestion.score * 100).toStringAsFixed(0)}%'),
                Text('Δ ${Formatters.currency(suggestion.priceDifference)}'),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: matches.length,
      ),
    );
  }
}

class _FavoritesStrip extends StatelessWidget {
  const _FavoritesStrip({required this.items, required this.fetchItem});

  final List<SellListing> items;
  final Item? Function(SellListing listing) fetchItem;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final listing = items[index];
          final item = fetchItem(listing);
          if (item == null) {
            return const SizedBox.shrink();
          }
          return Container(
            width: 160,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: theme.colorScheme.surface,
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodyLarge),
                const Spacer(),
                Text(Formatters.currency(listing.currentBid), style: theme.textTheme.titleMedium),
              ],
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemCount: items.length,
      ),
    );
  }
}

class _BidsStrip extends StatelessWidget {
  const _BidsStrip({required this.bids, required this.getListing});

  final List<Bid> bids;
  final SellListing Function(String id) getListing;

  @override
  Widget build(BuildContext context) {
    if (bids.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: bids.length,
        itemBuilder: (context, index) {
          final bid = bids[index];
          final listing = getListing(bid.listingId);
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(18),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('#${listing.id} • ${Formatters.currency(bid.amount)}', style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(Formatters.relativeDate(bid.createdAt), style: theme.textTheme.labelSmall),
                const Spacer(),
                Text(bid.status, style: theme.textTheme.labelLarge),
              ],
            ),
          );
        },
      ),
    );
  }
}
