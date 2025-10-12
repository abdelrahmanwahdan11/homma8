import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_state.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/formatters.dart';
import '../../../models/models.dart';
import '../domain/mini_search_index.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  SearchResult? _result;
  String? _category;
  double? _minPrice;
  double? _maxPrice;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final l10n = context.l10n;
    final suggestions = _result?.suggestions ?? const <String>[];
    final hits = _result?.hits ?? const <SearchHit>[];
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(hintText: l10n.searchHint),
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _performSearch(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _openFilters(context, state),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (suggestions.isNotEmpty) ...[
            Text(l10n.suggestions, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final suggestion in suggestions)
                  ActionChip(
                    label: Text(suggestion),
                    onPressed: () {
                      _controller.text = suggestion;
                      _performSearch();
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
          ],
          for (final hit in hits) _SearchTile(hit: hit),
          if (hits.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Center(child: Text(l10n.noResults)),
            ),
        ],
      ),
    );
  }

  void _performSearch() {
    final state = AppScope.of(context);
    final filters = SearchFilters(
      category: _category,
      minPrice: _minPrice,
      maxPrice: _maxPrice,
      statuses: _minPrice != null || _maxPrice != null ? {'active'} : null,
    );
    setState(() {
      _result = state.search(_controller.text.trim(), filters);
    });
  }

  Future<void> _openFilters(BuildContext context, AppState state) async {
    final l10n = context.l10n;
    final categories = state.items.map((item) => item.category).toSet();
    String? category = _category;
    double min = _minPrice ?? 0;
    double max = _maxPrice ?? 4000;
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        String? tempCategory = category;
        double tempMin = min;
        double tempMax = max;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.filters, style: Theme.of(context).textTheme.titleLarge),
                  DropdownButton<String?>(
                    value: tempCategory,
                    hint: Text(l10n.allCategories),
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.allCategories)),
                      ...categories.map((cat) => DropdownMenuItem(value: cat, child: Text(cat))),
                    ],
                    onChanged: (value) => setModalState(() => tempCategory = value),
                  ),
                  RangeSlider(
                    min: 0,
                    max: 5000,
                    values: RangeValues(tempMin, tempMax),
                    onChanged: (value) => setModalState(() {
                      tempMin = value.start;
                      tempMax = value.end;
                    }),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _category = tempCategory;
                          _minPrice = tempMin;
                          _maxPrice = tempMax;
                        });
                        _performSearch();
                      },
                      child: Text(l10n.apply),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _SearchTile extends StatelessWidget {
  const _SearchTile({required this.hit});

  final SearchHit hit;

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final item = hit.item;
    final listing = hit.listing;
    return Card(
      child: ListTile(
        onTap: () => AppRouterDelegate.of(context).push('/item/${item.id}'),
        title: Text(item.title),
        subtitle: Text('${item.category} • ${Formatters.currency(listing?.currentBid ?? item.basePrice)}'),
        trailing: Text('${(hit.score * 100).toStringAsFixed(0)}%'),
        leading: Hero(
          tag: 'item_card_${item.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(item.image, width: 56, height: 56, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }
}
