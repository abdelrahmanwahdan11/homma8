import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../models/listing.dart';

class WishesPage extends StatelessWidget {
  const WishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final items = app.watchlistItems;
    if (items.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('لا عناصر بعد')),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('رغباتي')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final Listing item = items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text('السعر الحالي: ${item.currentPrice}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () => app.toggleWatch(item.id),
            ),
            onTap: () => Navigator.pushNamed(context, '/auction', arguments: item),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: items.length,
      ),
    );
  }
}
