import 'package:flutter/material.dart';

import '../../widgets/filter_chip.dart';

typedef FilterCallback = void Function(String key, String? value);

typedef Filters = Map<String, String?>;

class FiltersBar extends StatelessWidget {
  const FiltersBar({super.key, required this.filters, required this.onChanged});

  final Filters filters;
  final FilterCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final chips = <Widget>[];
    const categories = ['phones', 'laptops', 'cameras'];
    for (final category in categories) {
      chips.add(LimeFilterChip(
        label: category,
        selected: filters['category'] == category,
        onTap: () => onChanged('category', filters['category'] == category ? null : category),
      ));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(children: chips),
    );
  }
}
