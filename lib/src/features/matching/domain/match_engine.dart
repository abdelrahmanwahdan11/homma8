import 'dart:math' as math;

import '../../../core/utils/tokenizer.dart';
import '../../../models/models.dart';

class MatchSuggestion {
  const MatchSuggestion({
    required this.listing,
    required this.intent,
    required this.score,
    required this.priceDifference,
  });

  final SellListing listing;
  final BuyIntent intent;
  final double score;
  final double priceDifference;
}

class MatchSnapshot {
  const MatchSnapshot({
    required this.sellerMatches,
    required this.buyerMatches,
  });

  final Map<String, List<MatchSuggestion>> sellerMatches;
  final Map<String, List<MatchSuggestion>> buyerMatches;

  List<MatchSuggestion> forListing(String listingId) {
    return sellerMatches[listingId] ?? const <MatchSuggestion>[];
  }

  List<MatchSuggestion> forIntent(String intentId) {
    return buyerMatches[intentId] ?? const <MatchSuggestion>[];
  }
}

class MatchEngine {
  MatchEngine({Tokenizer? tokenizer}) : _tokenizer = tokenizer ?? Tokenizer();

  final Tokenizer _tokenizer;
  MatchSnapshot _snapshot = const MatchSnapshot(sellerMatches: <String, List<MatchSuggestion>>{}, buyerMatches: <String, List<MatchSuggestion>>{});

  MatchSnapshot get snapshot => _snapshot;

  MatchSnapshot compute({
    required List<SellListing> listings,
    required List<BuyIntent> intents,
    required List<Item> items,
  }) {
    final Map<String, List<MatchSuggestion>> sellerMatches = <String, List<MatchSuggestion>>{};
    final Map<String, List<MatchSuggestion>> buyerMatches = <String, List<MatchSuggestion>>{};

    final Map<String, Item> itemById = <String, Item>{for (final item in items) item.id: item};
    for (final listing in listings) {
      final item = itemById[listing.itemId];
      if (item == null) {
        continue;
      }
      final tokens = _tokenizer.tokenize(item.title);
      final List<MatchSuggestion> suggestions = <MatchSuggestion>[];
      for (final intent in intents) {
        if (!_isCategoryMatch(item, intent)) {
          continue;
        }
        if (!_isConditionMatch(item, intent)) {
          continue;
        }
        final intentTokens = _tokenizer.tokenize(intent.title);
        final tokenScore = _tokenOverlap(tokens, intentTokens);
        final priceScore = _priceOverlap(listing, intent);
        if (priceScore <= 0) {
          continue;
        }
        final score = 0.45 * tokenScore + 0.35 * priceScore + 0.2;
        final priceDiff = (listing.askPrice - intent.maxPrice).abs();
        suggestions.add(
          MatchSuggestion(
            listing: listing,
            intent: intent,
            score: score,
            priceDifference: priceDiff,
          ),
        );
      }
      suggestions.sort((a, b) => b.score.compareTo(a.score));
      sellerMatches[listing.id] = suggestions.take(6).toList();
    }

    for (final intent in intents) {
      final matches = <MatchSuggestion>[];
      for (final entry in sellerMatches.entries) {
        for (final suggestion in entry.value) {
          if (suggestion.intent.id == intent.id) {
            matches.add(suggestion);
          }
        }
      }
      matches.sort((a, b) => b.score.compareTo(a.score));
      buyerMatches[intent.id] = matches.take(6).toList();
    }

    _snapshot = MatchSnapshot(sellerMatches: sellerMatches, buyerMatches: buyerMatches);
    return _snapshot;
  }

  List<MatchSuggestion> forListing(String listingId) {
    return _snapshot.sellerMatches[listingId] ?? const <MatchSuggestion>[];
  }

  List<MatchSuggestion> forIntent(String intentId) {
    return _snapshot.buyerMatches[intentId] ?? const <MatchSuggestion>[];
  }

  bool _isCategoryMatch(Item item, BuyIntent intent) {
    if (intent.category.toLowerCase() == 'any') {
      return true;
    }
    return item.category == intent.category;
  }

  bool _isConditionMatch(Item item, BuyIntent intent) {
    if (intent.condition == 'any') {
      return true;
    }
    if (intent.condition == 'new') {
      return item.condition.toLowerCase() == 'new';
    }
    return true;
  }

  double _tokenOverlap(List<String> listingTokens, List<String> intentTokens) {
    if (intentTokens.isEmpty) {
      return 0.5;
    }
    final setListing = listingTokens.toSet();
    final setIntent = intentTokens.toSet();
    final intersection = setListing.intersection(setIntent).length;
    if (intersection == 0) {
      return 0.2;
    }
    return math.min(1, intersection / setIntent.length + 0.2);
  }

  double _priceOverlap(SellListing listing, BuyIntent intent) {
    final ask = listing.askPrice;
    final maxPrice = intent.maxPrice;
    final diff = (ask - maxPrice).abs();
    final maxAllowed = math.max(50, maxPrice * 0.5);
    final score = 1 - diff / (maxAllowed + 1);
    return math.max(0, math.min(1, score));
  }
}
