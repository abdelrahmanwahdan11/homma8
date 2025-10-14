import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/wanted.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/filter_chip.dart';
import '../../widgets/wanted_card.dart';

class WantedBoardPage extends StatefulWidget {
  const WantedBoardPage({super.key, required this.onOpenDetails});

  final void Function(String id) onOpenDetails;

  @override
  State<WantedBoardPage> createState() => _WantedBoardPageState();
}

class _WantedBoardPageState extends State<WantedBoardPage> {
  final ScrollController _controller = ScrollController();
  final List<WantedModel> _items = <WantedModel>[];
  bool _loading = false;
  bool _hasMore = true;
  int _pageKey = 0;
  String? _category;

  @override
  void initState() {
    super.initState();
    _load(reset: true);
    _controller.addListener(_onScroll);
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
    final filtered = result.items.where((item) => _category == null || item.category == _category).toList();
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
    final l10n = context.l10n;
    final categories = <String?>[null, 'phones', 'laptops', 'gaming', 'collectibles'];
    final appState = AppStateScope.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.wantedBoard)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => appState.bottomNavIndex.value = 2,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _controller,
          slivers: [
            SliverToBoxAdapter(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: categories.map((category) {
                    final label = category == null ? l10n.allCategories : category;
                    final selected = _category == category;
                    return LimeFilterChip(
                      label: label,
                      selected: selected,
                      onTap: () {
                        setState(() {
                          _category = category;
                        });
                        _load(reset: true);
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index >= _items.length) {
                    return _hasMore
                        ? const Padding(
                            padding: EdgeInsets.all(24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : const SizedBox.shrink();
                  }
                  final wanted = _items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: GestureDetector(
                      onTap: () => widget.onOpenDetails(wanted.id),
                      child: WantedCard(wanted: wanted),
                    ),
                  );
                },
                childCount: _items.length + (_hasMore ? 1 : 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
