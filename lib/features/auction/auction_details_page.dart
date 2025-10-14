import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/auction.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/media_placeholder.dart';
import '../../widgets/skeletons.dart';
import 'ai_info_sheet.dart';
import 'place_bid_modal.dart';

class AuctionDetailsPage extends StatefulWidget {
  const AuctionDetailsPage({super.key, required this.auctionId});

  final String auctionId;

  @override
  State<AuctionDetailsPage> createState() => _AuctionDetailsPageState();
}

class _AuctionDetailsPageState extends State<AuctionDetailsPage> {
  late Future<AuctionModel?> _future;
  Timer? _timer;
  final ValueNotifier<Duration> _countdown = ValueNotifier<Duration>(Duration.zero);

  @override
  void initState() {
    super.initState();
    _future = RepoProvider.auctionRepository.getAuction(widget.auctionId);
    _future.then((auction) {
      if (auction != null) {
        _startTimer(auction.endsAt);
      }
    });
  }

  void _startTimer(DateTime endsAt) {
    _timer?.cancel();
    void update() {
      final remaining = endsAt.difference(DateTime.now());
      _countdown.value = remaining.isNegative ? Duration.zero : remaining;
    }

    update();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => update());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _countdown.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.auctionDetails)),
      body: FutureBuilder<AuctionModel?>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: DetailsSkeleton(),
              );
            }
            return Center(child: Text(l10n.auctionNotFound));
          }
          final auction = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              final refreshed = await RepoProvider.auctionRepository.getAuction(widget.auctionId);
              if (refreshed != null) {
                _startTimer(refreshed.endsAt);
                setState(() {
                  _future = Future.value(refreshed);
                });
              }
            },
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: _ImageCarousel(auction: auction),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(auction.title, style: Theme.of(context).textTheme.displayLarge),
                        const SizedBox(height: 8),
                        ValueListenableBuilder<Duration>(
                          valueListenable: _countdown,
                          builder: (context, remaining, _) {
                            final formatted = '${remaining.inHours.remainder(24).toString().padLeft(2, '0')}:${(remaining.inMinutes % 60).toString().padLeft(2, '0')}';
                            return Text(l10n.endsIn(time: formatted));
                          },
                        ),
                        const SizedBox(height: 12),
                        TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: auction.priceStart, end: auction.priceNow),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, _) {
                            return Text(
                              l10n.currentBidValue(
                                amount: l10n.usdAmount(amount: value.toStringAsFixed(0)),
                              ),
                              style: Theme.of(context).textTheme.titleLarge,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        Text(auction.desc),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => showModalBottomSheet<void>(
                                context: context,
                                isScrollControlled: true,
                                builder: (_) => PlaceBidModal(
                                  currentBid: auction.priceNow,
                                  onSubmit: (amount) async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.bidPlaced(
                                            amount: l10n.usdAmount(amount: amount.toStringAsFixed(0)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              child: Text(l10n.placeBid),
                            ),
                            const SizedBox(width: 12),
                            OutlinedButton(
                              onPressed: () => showModalBottomSheet<void>(
                                context: context,
                                builder: (_) => AiInfoSheet(
                                  summary: l10n.aiSummaryTemplate(title: auction.title),
                                  approxPrice: auction.priceNow * 1.05,
                                ),
                              ),
                              child: Text(l10n.aiInfo),
                            ),
                            const SizedBox(width: 12),
                            ValueListenableBuilder<Set<String>>(
                              valueListenable: appState.favoritesNotifier,
                              builder: (context, favorites, _) {
                                final isFav = favorites.contains(auction.id);
                                return IconButton(
                                  onPressed: () => appState.toggleFavorite(auction.id),
                                  icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Text(l10n.bidHistory),
                        const SizedBox(height: 8),
                        Column(
                          children: List.generate(5, (index) {
                            return ListTile(
                              leading: const CircleAvatar(child: Icon(Icons.person_outline)),
                              title: Text(l10n.bidderLabel(number: index)),
                              subtitle: Text(l10n.mockTimestamp),
                              trailing: Text(
                                  l10n.usdAmount(amount: (auction.priceNow - index * 5).toStringAsFixed(0))),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ImageCarousel extends StatefulWidget {
  const _ImageCarousel({required this.auction});

  final AuctionModel auction;

  @override
  State<_ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<_ImageCarousel> {
  final PageController _controller = PageController();
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final images = widget.auction.images.isEmpty ? <String>[widget.auction.id] : widget.auction.images;
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 0.6,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) {
              final imageSeed = images[index];
              return Hero(
                tag: 'hero_auction_image_${widget.auction.id}',
                child: MediaPlaceholder(
                  seed: '${widget.auction.id}_$imageSeed_$index',
                  borderRadius: BorderRadius.circular(24),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            final active = index == _index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 20 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: active ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
            );
          }),
        ),
      ],
    );
  }
}
