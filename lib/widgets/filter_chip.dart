import 'package:flutter/material.dart';

class LimeFilterChip extends StatelessWidget {
  const LimeFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onTap(),
        labelStyle: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
