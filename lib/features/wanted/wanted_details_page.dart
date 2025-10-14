import 'package:flutter/material.dart';

import '../../data/models/wanted.dart';
import '../../data/repos/repo_provider.dart';

class WantedDetailsPage extends StatelessWidget {
  const WantedDetailsPage({super.key, required this.wantedId});

  final String wantedId;

  @override
  Widget build(BuildContext context) {
    final wanted = RepoProvider.wantedRepository.all.firstWhere((w) => w.id == wantedId,
        orElse: () => RepoProvider.wantedRepository.all.first);
    return Scaffold(
      appBar: AppBar(title: Text(wanted.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Budget: ${wanted.maxPrice.toStringAsFixed(0)} USD', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('Location: ${wanted.location}'),
            const SizedBox(height: 12),
            Text('Specs'),
            const SizedBox(height: 8),
            Text(wanted.specs),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Suggest item (mock)'))),
                child: const Text('Suggest item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
