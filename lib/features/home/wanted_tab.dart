import 'package:flutter/material.dart';

import '../../data/models/wanted.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/wanted_card.dart';

class WantedTab extends StatefulWidget {
  const WantedTab({super.key, required this.query});

  final String query;

  @override
  State<WantedTab> createState() => _WantedTabState();
}

class _WantedTabState extends State<WantedTab> with AutomaticKeepAliveClientMixin {
  final ScrollController _controller = ScrollController();
  final List<WantedModel> _items = <WantedModel>[];
  bool _loading = false;
  bool _hasMore = true;
  int _pageKey = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _controller.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant WantedTab oldWidget) {
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
      _pageKey = 0;
      _hasMore = true;
    }
    final result = await RepoProvider.wantedRepository.fetch(pageKey: _pageKey);
    final filtered = result.items.where((wanted) => wanted.title.toLowerCase().contains(widget.query.toLowerCase())).toList();
    _items.addAll(filtered);
    _pageKey = result.nextKey ?? _pageKey;
    _hasMore = result.nextKey != null;
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
    return RefreshIndicator(
      onRefresh: _refresh,
      child: CustomScrollView(
        key: const PageStorageKey('wanted_scroll'),
        controller: _controller,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: _items.isEmpty && _loading
                ? SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const Padding(
                        padding: EdgeInsets.only(bottom: 16),
                        child: SizedBox(height: 180, child: AuctionCardSkeleton()),
                      ),
                      childCount: 6,
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _items.length) {
                          return const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final wanted = _items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SizedBox(height: 180, child: WantedCard(wanted: wanted)),
                        );
                      },
                      childCount: _items.length + (_hasMore ? 1 : 0),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
