import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/match_score.dart';

class RankedBuyerTile extends StatelessWidget {
  const RankedBuyerTile({super.key, required this.score});

  final MatchScoreModel score;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      leading: CircleAvatar(child: Text(score.score.toStringAsFixed(2))),
      title: Text(l10n.buyerLabel(id: score.targetId)),
      subtitle: Text(score.reason),
      trailing: Wrap(
        spacing: 8,
        children: [
          OutlinedButton(onPressed: () {}, child: Text(l10n.invite)),
          OutlinedButton(onPressed: () {}, child: Text(l10n.offer)),
        ],
      ),
    );
  }
}
