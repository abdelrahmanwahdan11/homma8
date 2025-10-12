class Formatters {
  const Formatters._();

  static String currency(num value, {String symbol = 'ر.س'}) {
    final bool hasDecimals = value % 1 != 0;
    final formatted = hasDecimals ? value.toStringAsFixed(2) : value.toStringAsFixed(0);
    return '$symbol $formatted';
  }

  static String timeLeft(Duration duration) {
    if (duration <= Duration.zero) {
      return '0s';
    }
    if (duration.inDays >= 1) {
      final days = duration.inDays;
      final hours = duration.inHours.remainder(24);
      if (hours > 0) {
        return '${days}d ${hours}h';
      }
      return '${days}d';
    }
    if (duration.inHours >= 1) {
      final hours = duration.inHours;
      final minutes = duration.inMinutes.remainder(60);
      if (minutes > 0) {
        return '${hours}h ${minutes}m';
      }
      return '${hours}h';
    }
    if (duration.inMinutes >= 1) {
      final minutes = duration.inMinutes;
      final seconds = duration.inSeconds.remainder(60);
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      }
      return '${minutes}m';
    }
    return '${duration.inSeconds}s';
  }

  static String relativeDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inDays >= 365) {
      final years = (diff.inDays / 365).floor();
      return '${years}y';
    }
    if (diff.inDays >= 30) {
      final months = (diff.inDays / 30).floor();
      return '${months}mo';
    }
    if (diff.inDays >= 1) {
      return '${diff.inDays}d';
    }
    if (diff.inHours >= 1) {
      return '${diff.inHours}h';
    }
    if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m';
    }
    return 'now';
  }
}
