import 'package:flutter/foundation.dart';

@immutable
class MatchScoreModel {
  const MatchScoreModel({
    required this.sourceId,
    required this.targetId,
    required this.score,
    required this.reason,
  });

  final String sourceId;
  final String targetId;
  final double score;
  final String reason;

  factory MatchScoreModel.fromJson(Map<String, dynamic> json) => MatchScoreModel(
        sourceId: json['sourceId'] as String,
        targetId: json['targetId'] as String,
        score: (json['score'] as num).toDouble(),
        reason: json['reason'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'sourceId': sourceId,
        'targetId': targetId,
        'score': score,
        'reason': reason,
      };
}
