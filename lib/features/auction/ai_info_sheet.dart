import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class AiInfoSheet extends StatelessWidget {
  const AiInfoSheet({super.key, required this.summary, required this.approxPrice});

  final String summary;
  final double approxPrice;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.aiInsights, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Text(summary),
          const SizedBox(height: 12),
          Text(
            l10n.approxPrice(amount: l10n.usdAmount(amount: approxPrice.toStringAsFixed(0))),
          ),
          const SizedBox(height: 12),
          Text(l10n.prosDescription),
          const SizedBox(height: 4),
          Text(l10n.consDescription),
        ],
      ),
    );
  }
}
