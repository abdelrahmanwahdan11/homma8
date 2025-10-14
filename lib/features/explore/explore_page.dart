import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state/app_state.dart';
import '../../core/localization/app_localizations.dart';
import '../../data/models/auction.dart';
import '../../data/repos/repo_provider.dart';
import '../../widgets/search_bar.dart';
import 'filters_bar.dart';
import 'results_grid.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with AutomaticKeepAliveClientMixin {
  final ValueNotifier<String> _query = ValueNotifier<String>('');
  Filters _filters = <String, String?>{};
  String _sort = 'relevance';
  List<AuctionModel> _results = <AuctionModel>[];
  Timer? _debounce;

  @override
  bool get wantKeepAlive => true;

  bool _loadedPrefs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedPrefs) return;
    final appState = AppStateScope.of(context);
    final cached = appState.readDraft('sp_filters_v1');
    _filters = cached.map((key, value) => MapEntry(key, value?.toString()));
    _loadResults();
    _loadedPrefs = true;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _query.dispose();
    super.dispose();
  }

  void _updateFilters(String key, String? value) {
    setState(() {
      if (value == null) {
        _filters.remove(key);
      } else {
        _filters[key] = value;
      }
    });
    AppStateScope.of(context).saveDraft('sp_filters_v1', _filters);
    _loadResults();
  }

  void _loadResults() {
    final all = RepoProvider.auctionRepository.all;
    final queryLower = _query.value.toLowerCase();
    var filtered = all.where((auction) => auction.title.toLowerCase().contains(queryLower)).toList();
    final category = _filters['category'];
    if (category != null) {
      filtered = filtered.where((auction) => auction.category == category).toList();
    }
    switch (_sort) {
      case 'price':
        filtered.sort((a, b) => a.priceNow.compareTo(b.priceNow));
        break;
      case 'end_time':
        filtered.sort((a, b) => a.endsAt.compareTo(b.endsAt));
        break;
      default:
        filtered.sort((a, b) => b.stats['views'].compareTo(a.stats['views']));
    }
    setState(() => _results = filtered);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, inner) => [
            SliverAppBar(
              floating: true,
              title: Text(l10n.explore),
            ),
          ],
          body: ValueListenableBuilder<String>(
            valueListenable: _query,
            builder: (context, query, _) {
              return RefreshIndicator(
                onRefresh: () async => _loadResults(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: BazaarSearchBar(
                          onQueryChanged: (value) {
                            _debounce?.cancel();
                            _debounce = Timer(const Duration(milliseconds: 300), () {
                              _query.value = value;
                              _loadResults();
                            });
                          },
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: FiltersBar(filters: _filters, onChanged: _updateFilters),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            Text(l10n.sortBy),
                            const SizedBox(width: 12),
                            DropdownButton<String>(
                              value: _sort,
                              items: [
                                DropdownMenuItem(value: 'relevance', child: Text(l10n.relevance)),
                                DropdownMenuItem(value: 'price', child: Text(l10n.price)),
                                DropdownMenuItem(value: 'end_time', child: Text(l10n.endTime)),
                              ],
                              onChanged: (value) {
                                if (value == null) return;
                                setState(() => _sort = value);
                                _loadResults();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_results.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(child: Text(l10n.noResults)),
                      )
                    else
                      ExploreResultsGrid(items: _results),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
