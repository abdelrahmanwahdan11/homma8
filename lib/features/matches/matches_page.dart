import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../data/models/match_score.dart';
import '../../data/mock/seed.dart';
import 'ranked_buyer_tile.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  List<MatchScoreModel> _scores = MockSeed.matchesForAuction('a_1001');
  String _sort = 'score';

  void _sortScores(String value) {
    setState(() {
      _sort = value;
      switch (value) {
        case 'score':
          _scores.sort((a, b) => b.score.compareTo(a.score));
          break;
        case 'id':
          _scores.sort((a, b) => a.targetId.compareTo(b.targetId));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.matches)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(l10n.sort),
                const SizedBox(width: 12),
                DropdownButton<String>(
                  value: _sort,
                  items: [
                    DropdownMenuItem(value: 'score', child: Text(l10n.sortScore)),
                    DropdownMenuItem(value: 'id', child: Text(l10n.sortBuyerId)),
                  ],
                  onChanged: (value) => _sortScores(value ?? 'score'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _scores.length,
              itemBuilder: (context, index) => RankedBuyerTile(score: _scores[index]),
            ),
          ),
        ],
      ),
    );
  }
}
