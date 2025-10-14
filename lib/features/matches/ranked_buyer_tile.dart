import 'package:flutter/material.dart';

import '../../data/models/match_score.dart';

class RankedBuyerTile extends StatelessWidget {
  const RankedBuyerTile({super.key, required this.score});

  final MatchScoreModel score;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(child: Text(score.score.toStringAsFixed(2))),
      title: Text('Buyer ${score.targetId}'),
      subtitle: Text(score.reason),
      trailing: Wrap(
        spacing: 8,
        children: [
          OutlinedButton(onPressed: () {}, child: const Text('Invite')), 
          OutlinedButton(onPressed: () {}, child: const Text('Offer')),
        ],
      ),
    );
  }
}
