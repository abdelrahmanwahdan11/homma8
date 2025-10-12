import 'dart:math' as math;

import '../../../core/utils/tokenizer.dart';
import '../../../models/models.dart';
import 'relevance_engine.dart';

class SearchFilters {
  const SearchFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.condition,
    this.location,
    this.statuses,
  });

  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? condition;
  final String? location;
  final Set<String>? statuses;

  bool matches(Item item, SellListing? listing) {
    if (category != null && category!.isNotEmpty && item.category != category) {
      return false;
    }
    if (condition != null && condition != 'any') {
      if (item.condition.toLowerCase() != condition!.toLowerCase()) {
        return false;
      }
    }
    if (location != null && location!.isNotEmpty) {
      if (!item.locationText.toLowerCase().contains(location!.toLowerCase())) {
        return false;
      }
    }
    final price = listing?.currentBid ?? listing?.askPrice ?? item.basePrice;
    if (minPrice != null && price < minPrice!) {
      return false;
    }
    if (maxPrice != null && price > maxPrice!) {
      return false;
    }
    if (statuses != null && statuses!.isNotEmpty) {
      final status = listing?.status ?? 'active';
      if (!statuses!.contains(status)) {
        return false;
      }
    }
    return true;
  }
}

class SearchHit {
  const SearchHit({
    required this.item,
    required this.listing,
    required this.score,
  });

  final Item item;
  final SellListing? listing;
  final double score;
}

class SearchResult {
  const SearchResult({required this.hits, required this.suggestions});

  final List<SearchHit> hits;
  final List<String> suggestions;
}

class _Document {
  _Document({
    required this.item,
    required this.listing,
    required this.termWeights,
    required this.recency,
  });

  final Item item;
  final SellListing? listing;
  final Map<String, double> termWeights;
  final double recency;
}

class MiniSearchIndex {
  MiniSearchIndex({Tokenizer? tokenizer}) : _tokenizer = tokenizer ?? Tokenizer();

  final Tokenizer _tokenizer;
  final List<_Document> _documents = <_Document>[];
  final Map<String, int> _docFrequency = <String, int>{};
  final List<String> _history = <String>[];

  void rebuild({required List<Item> items, required List<SellListing> listings}) {
    _documents.clear();
    _docFrequency.clear();
    final now = DateTime.now();
    for (final item in items) {
      final matching = listings.where((element) => element.itemId == item.id).toList();
      final listing = matching.isEmpty ? null : matching.first;
      final tokens = <String, double>{};
      void addTokens(Iterable<String> values, double weight) {
        for (final value in values) {
          final words = _tokenizer.tokenize(value);
          for (final word in words) {
            tokens[word] = (tokens[word] ?? 0) + weight;
          }
        }
      }

      addTokens(<String>[item.title], 3);
      addTokens(<String>[item.description], 1);
      addTokens(item.tags, 2);
      addTokens(<String>[item.category], 2);

      for (final token in tokens.keys.toList()) {
        _docFrequency[token] = (_docFrequency[token] ?? 0) + 1;
      }

      final diffDays = now.difference(item.createdAt).inDays;
      final recency = 1 - math.min(1, diffDays / 180);

      _documents.add(
        _Document(
          item: item,
          listing: listing,
          termWeights: tokens,
          recency: recency,
        ),
      );
    }
  }

  SearchResult search(String query, SearchFilters filters, RelevanceSnapshot snapshot) {
    final tokens = _tokenizer.tokenize(query);
    if (tokens.isEmpty && query.isNotEmpty) {
      _history.insert(0, query);
      return const SearchResult(hits: <SearchHit>[], suggestions: <String>[]);
    }

    if (query.isNotEmpty) {
      _history.removeWhere((element) => element == query);
      _history.insert(0, query);
      if (_history.length > 12) {
        _history.removeRange(12, _history.length);
      }
    }

    final List<SearchHit> results = <SearchHit>[];
    for (final document in _documents) {
      if (!filters.matches(document.item, document.listing)) {
        continue;
      }
      final textScore = _textMatchScore(tokens, document);
      if (textScore == 0 && tokens.isNotEmpty) {
        continue;
      }
      final categoryScore = snapshot.categoryScore(document.item.category);
      final priceScore = _priceScore(document, snapshot);
      final recency = document.recency;
      final interaction = snapshot.interactionScore(document.item.id);
      double total = textScore * 0.5 + categoryScore * 0.2 + priceScore * 0.2 + recency * 0.1;
      total += interaction * 0.3;
      results.add(SearchHit(item: document.item, listing: document.listing, score: total));
    }

    results.sort((a, b) => b.score.compareTo(a.score));
    final suggestions = _buildSuggestions(query, snapshot);
    return SearchResult(hits: results.take(40).toList(), suggestions: suggestions);
  }

  double _textMatchScore(List<String> tokens, _Document document) {
    if (tokens.isEmpty) {
      return 0.6;
    }
    double score = 0;
    for (final token in tokens) {
      final tf = document.termWeights[token] ?? 0;
      if (tf == 0) {
        continue;
      }
      final df = _docFrequency[token] ?? 1;
      final idf = math.log((_documents.length + 1) / (df + 1)) + 1;
      score += tf * idf;
    }
    return math.min(1.0, score / (tokens.length * 4));
  }

  double _priceScore(_Document document, RelevanceSnapshot snapshot) {
    final price = document.listing?.currentBid ?? document.listing?.askPrice ?? document.item.basePrice;
    final min = snapshot.priceMin;
    final max = snapshot.priceMax;
    if (min == null || max == null || min >= max) {
      return 0.6;
    }
    if (price < min || price > max) {
      final diff = price < min ? min - price : price - max;
      final range = max - min;
      return math.max(0, 1 - diff / (range + 1));
    }
    final center = (min + max) / 2;
    final diff = (price - center).abs();
    final range = (max - min) / 2;
    return math.max(0.4, 1 - diff / (range + 1));
  }

  List<String> _buildSuggestions(String query, RelevanceSnapshot snapshot) {
    final suggestions = <String>{};
    if (query.isEmpty) {
      suggestions.addAll(snapshot.favoriteCategories);
    } else {
      final tokens = _tokenizer.tokenize(query);
      if (tokens.isNotEmpty) {
        final prefix = tokens.last;
        for (final document in _documents) {
          for (final tag in document.item.tags) {
            if (tag.toLowerCase().startsWith(prefix)) {
              suggestions.add(tag);
            }
          }
        }
      }
    }
    suggestions.addAll(_history);
    return suggestions.take(8).toList();
  }
}
