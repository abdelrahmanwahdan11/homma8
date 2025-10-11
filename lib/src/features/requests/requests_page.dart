import 'package:flutter/material.dart';

import '../../core/app_scope.dart';
import '../../models/request_item.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppScope.of(context);
    final requests = app.requests;
    return Scaffold(
      appBar: AppBar(title: const Text('طلبات السوق')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          final RequestItem item = requests[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text('سعر أقصى: ${item.maxPrice} — ${item.location}'),
            onTap: () => Navigator.pushNamed(context, '/request', arguments: item),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: requests.length,
      ),
    );
  }
}
