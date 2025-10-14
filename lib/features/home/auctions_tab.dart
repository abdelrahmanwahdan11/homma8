import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../data/models/auction.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/skeletons.dart';

class AuctionsTab extends StatefulWidget {
  const AuctionsTab({super.key, required this.query});

  final String query;

  @override
  State<AuctionsTab> createState() => _AuctionsTabState();
}

class _AuctionsTabState extends State<AuctionsTab> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
  final List<AuctionModel> _items = <AuctionModel>[];
  bool _isLoading = false;
  bool _hasMore = true;
  int _pageKey = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant AuctionsTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _load(reset: true);
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _isLoading || !_hasMore) return;
    final threshold = _scrollController.position.maxScrollExtent - 200;
    if (_scrollController.position.pixels > threshold) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (_isLoading) return;
    setState(() => _isLoading = true);
    if (reset) {
      _items.clear();
      _pageKey = 0;
      _hasMore = true;
    }
    final result = await RepoProvider.auctionRepository.fetchAuctions(pageKey: _pageKey);
    final filtered = result.items.where((auction) => auction.title.toLowerCase().contains(widget.query.toLowerCase())).toList();
    _items.addAll(filtered);
    _pageKey = result.nextKey ?? _pageKey;
    _hasMore = result.nextKey != null;
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() => _load(reset: true);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appState = AppStateScope.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        key: const PageStorageKey('auctions_scroll'),
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _items.isEmpty && _isLoading
                ? SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) => const AuctionCardSkeleton(), childCount: 6),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.8,
                    ),
                  )
                : SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _items.length) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final auction = _items[index];
                        return AuctionCard(auction: auction, appState: appState);
                      },
                      childCount: _items.length + (_hasMore ? 1 : 0),
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
      ),
    );
  }
}
