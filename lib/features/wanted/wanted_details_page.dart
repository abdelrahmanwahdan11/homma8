import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/wanted.dart';
import '../../data/repos/repo_provider.dart';

class WantedDetailsPage extends StatelessWidget {
  const WantedDetailsPage({super.key, required this.wantedId});

  final String wantedId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final wanted = RepoProvider.wantedRepository.all.firstWhere((w) => w.id == wantedId,
        orElse: () => RepoProvider.wantedRepository.all.first);
    return Scaffold(
      appBar: AppBar(title: Text(wanted.title)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.budgetValue(amount: wanted.maxPrice.toStringAsFixed(0)),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Text(l10n.locationValue(location: wanted.location)),
            const SizedBox(height: 12),
            Text(l10n.specs),
            const SizedBox(height: 8),
            Text(wanted.specs),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.suggestItemMock))),
                child: Text(l10n.suggestItem),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
