import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../data/models/auction.dart';
import '../../data/models/wanted.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/wanted_card.dart';

class ForYouTab extends StatefulWidget {
  const ForYouTab({super.key, required this.query});

  final String query;

  @override
  State<ForYouTab> createState() => _ForYouTabState();
}

class _ForYouTabState extends State<ForYouTab> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final List<Object> _items = <Object>[];
  bool _loading = false;
  bool _hasMore = true;
  int _auctionPage = 0;
  int _wantedPage = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant ForYouTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) {
      _load(reset: true);
    }
  }

  void _onScroll() {
    if (!_controller.hasClients || _loading || !_hasMore) return;
    if (_controller.position.pixels > _controller.position.maxScrollExtent - 200) {
      _load();
    }
  }

  Future<void> _load({bool reset = false}) async {
    if (_loading) return;
    setState(() => _loading = true);
    if (reset) {
      _items.clear();
      _auctionPage = 0;
      _wantedPage = 0;
      _hasMore = true;
    }
    final auctionResult = await RepoProvider.auctionRepository.fetchAuctions(pageKey: _auctionPage);
    final wantedResult = await RepoProvider.wantedRepository.fetch(pageKey: _wantedPage);
    final combined = <Object>[];
    final maxLength = max(auctionResult.items.length, wantedResult.items.length);
    for (var i = 0; i < maxLength; i++) {
      if (i < auctionResult.items.length) {
        final auction = auctionResult.items[i];
        if (auction.title.toLowerCase().contains(widget.query.toLowerCase())) {
          combined.add(auction);
        }
      }
      if (i < wantedResult.items.length) {
        final wanted = wantedResult.items[i];
        if (wanted.title.toLowerCase().contains(widget.query.toLowerCase())) {
          combined.add(wanted);
        }
      }
    }
    _items.addAll(combined);
    _auctionPage = auctionResult.nextKey ?? _auctionPage;
    _wantedPage = wantedResult.nextKey ?? _wantedPage;
    _hasMore = auctionResult.nextKey != null || wantedResult.nextKey != null;
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _refresh() => _load(reset: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final appState = AppStateScope.of(context);
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        key: const PageStorageKey('for_you_scroll'),
        controller: _controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _items.length) {
                    return _loading
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                  final item = _items[index];
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: item is AuctionModel
                          ? SizedBox(
                              height: 240,
                              child: AuctionCard(auction: item, appState: appState),
                            )
                          : SizedBox(
                              height: 180,
                              child: WantedCard(wanted: item as WantedModel),
                            ),
                    ),
                  );
                },
                childCount: _items.length + (_hasMore ? 1 : 0),
              ),
            ),
          ),
          if (_items.isEmpty && _loading)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
