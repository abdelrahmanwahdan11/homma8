import 'package:flutter/material.dart';

import '../../models/request_item.dart';

class RequestDetailsPage extends StatelessWidget {
  const RequestDetailsPage({super.key, required this.request});

  final RequestItem request;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تفاصيل الطلب')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(request.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(request.specs),
            const SizedBox(height: 16),
            Text('السعر الأقصى: ${request.maxPrice} — الموقع: ${request.location}'),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('اعرض سلعتك (محاكاة)')),
                );
              },
              child: const Text('اعرض سلعتك'),
            ),
          ],
        ),
      ),
    );
  }
}
