import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/app_state.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../core/widgets/bento_grid.dart';
import '../../../models/models.dart';

class CatalogPage extends StatefulWidget {
  const CatalogPage({super.key});

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String? _category;
  RangeValues _price = const RangeValues(0, 2000);
  bool _onlyActive = true;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    final items = state.items.where((item) {
      final matching = state.listings.where((listing) => listing.itemId == item.id).toList();
      if (matching.isEmpty) {
        return false;
      }
      final listing = matching.first;
      final price = listing.currentBid;
      if (_category != null && item.category != _category) {
        return false;
      }
      if (_onlyActive && listing.status != 'active') {
        return false;
      }
      if (price < _price.start || price > _price.end) {
        return false;
      }
      return true;
    }).toList();

    final pattern = <BentoTileSize>[
      BentoTileSize.twoByOne,
      BentoTileSize.oneByOne,
      BentoTileSize.oneByTwo,
      BentoTileSize.oneByOne,
      BentoTileSize.twoByTwo,
    ];

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            title: Text(l10n.catalog),
            actions: [
              IconButton(
                icon: const Icon(Icons.filter_list),
                onPressed: () => _openFilters(context, state),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Wrap(
                  spacing: 12,
                  children: [
                    FilterChip(
                      label: Text(_category ?? l10n.allCategories),
                      selected: _category != null,
                      onSelected: (_) => _openCategorySheet(context, state),
                    ),
                    FilterChip(
                      label: Text('≤ ${_price.end.toInt()}'),
                      selected: true,
                      onSelected: (_) => _openFilters(context, state),
                    ),
                    FilterChip(
                      label: Text(l10n.activeOnly),
                      selected: _onlyActive,
                      onSelected: (value) => setState(() => _onlyActive = value),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  final matching = state.listings.where((listing) => listing.itemId == item.id).toList();
                  if (matching.isEmpty) {
                    return const SizedBox();
                  }
                  final listing = matching.first;
                  return _CatalogTile(item: item, listing: listing);
                },
                childCount: items.length,
              ),
              gridDelegate: BentoGridDelegate(
                pattern: pattern,
                crossAxisCount: 2,
                tileAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openFilters(BuildContext context, AppState state) async {
    final result = await showModalBottomSheet<RangeValues>(
      context: context,
      builder: (context) {
        RangeValues values = _price;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Price range', style: Theme.of(context).textTheme.titleMedium),
                  RangeSlider(
                    min: 0,
                    max: 5000,
                    divisions: 50,
                    values: values,
                    onChanged: (value) => setModalState(() => values = value),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, values),
                    child: const Text('Apply'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (result != null) {
      setState(() => _price = result);
    }
  }

  Future<void> _openCategorySheet(BuildContext context, AppState state) async {
    final category = await showModalBottomSheet<String>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(
                title: Text(context.l10n.allCategories),
                onTap: () => Navigator.pop(context, null),
              ),
              for (final category in state.items.map((item) => item.category).toSet())
                ListTile(
                  title: Text(category),
                  onTap: () => Navigator.pop(context, category),
                ),
            ],
          ),
        );
      },
    );
    if (mounted) {
      setState(() => _category = category);
    }
  }
}

class _CatalogTile extends StatelessWidget {
  const _CatalogTile({required this.item, required this.listing});

  final Item item;
  final SellListing listing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GridTile(
      header: Padding(
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.topRight,
          child: Chip(label: Text(item.category)),
        ),
      ),
      footer: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(item.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('${listing.status} • ${Formatters.currency(listing.currentBid)}', style: theme.textTheme.labelSmall),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: () => AppRouterDelegate.of(context).push('/item/${item.id}'),
        child: Hero(
          tag: 'item_card_${item.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(item.image, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
