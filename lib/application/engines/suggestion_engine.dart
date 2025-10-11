import '../../domain/entities.dart';

class Suggestion {
  const Suggestion({required this.mode, required this.recommendedPrice, this.notes});

  final String mode;
  final double recommendedPrice;
  final String? notes;
}

class SuggestionEngine {
  SuggestionEngine();

  Suggestion suggest({
    required Condition condition,
    required String category,
    required double basePrice,
    required int recentDemand,
  }) {
    final factor = switch (condition) {
      Condition.newCondition => 1.0,
      Condition.likeNew => 0.9,
      Condition.good => 0.8,
      Condition.fair => 0.65,
    };
    final adjustedPrice = basePrice * factor;
    final bool highDemand = recentDemand > 15;
    if (highDemand) {
      return Suggestion(
        mode: 'auction',
        recommendedPrice: adjustedPrice,
        notes: 'High demand detected; auction recommended.',
      );
    }
    final discountNotes = 'Start with 5% discount ladder every 20 watches up to 30%';
    return Suggestion(
      mode: 'discount',
      recommendedPrice: adjustedPrice * 0.95,
      notes: discountNotes,
    );
  }
}
