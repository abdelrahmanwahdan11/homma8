class Tokenizer {
  const Tokenizer();

  static final RegExp _arabicDiacritics = RegExp(r'[ؐ-ًؚ-ٟۖ-ۭ]');
  static final RegExp _punctuation = RegExp(r'[^a-z0-9؀-ۿ]+');
  static final Set<String> _arStopwords = <String>{
    'من', 'إلى', 'على', 'في', 'عن', 'هذا', 'هذه', 'ذلك', 'تلك', 'هو', 'هي', 'هم',
    'كما', 'لكن', 'أو', 'ثم', 'هناك', 'هنا', 'لقد', 'لدي', 'مع', 'كان', 'كانت',
  };
  static final Set<String> _enStopwords = <String>{
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'with', 'for', 'of', 'to',
    'is', 'are', 'was', 'were', 'be', 'been', 'this', 'that', 'from', 'by', 'at',
  };

  List<String> tokenize(String text) {
    if (text.isEmpty) {
      return const <String>[];
    }
    final normalized = _normalize(text);
    final parts = normalized.split(_punctuation);
    final tokens = <String>[];
    for (final part in parts) {
      final token = part.trim();
      if (token.isEmpty) {
        continue;
      }
      if (_isStopword(token)) {
        continue;
      }
      tokens.add(token);
    }
    return tokens;
  }

  String _normalize(String input) {
    var text = input.toLowerCase();
    text = text.replaceAll(_arabicDiacritics, '');
    text = text.replaceAll('أ', 'ا').replaceAll('إ', 'ا').replaceAll('آ', 'ا');
    text = text.replaceAll('ة', 'ه');
    text = text.replaceAll('ى', 'ي');
    return text;
  }

  bool _isStopword(String token) {
    if (token.isEmpty) {
      return true;
    }
    if (token.codeUnitAt(0) >= 0x0600) {
      return _arStopwords.contains(token);
    }
    return _enStopwords.contains(token);
  }

  String identifier(String text) {
    return tokenize(text).join('-');
  }
}
