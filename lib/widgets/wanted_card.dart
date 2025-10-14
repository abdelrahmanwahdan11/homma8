import 'package:flutter/material.dart';

import '../app.dart';
import '../data/models/wanted.dart';

class WantedCard extends StatelessWidget {
  const WantedCard({super.key, required this.wanted});

  final WantedModel wanted;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.appRouter.push(AppRouteConfig('wanted', arguments: {'id': wanted.id})),
      borderRadius: BorderRadius.circular(20),
      child: GridTile(
        header: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Chip(label: Text(wanted.category)),
              const SizedBox(width: 8),
              Expanded(child: Text(wanted.location, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
        footer: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(wanted.title, style: Theme.of(context).textTheme.titleLarge, maxLines: 2, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 4),
              Text('Budget ${wanted.maxPrice.toStringAsFixed(0)} USD', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 4),
              Text(wanted.specs, maxLines: 3, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
