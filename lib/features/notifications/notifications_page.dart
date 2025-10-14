import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  String _timeAgo(AppLocalizations l10n, Duration diff) {
    if (diff.inMinutes < 1) return l10n.timeJustNow;
    if (diff.inHours < 1) {
      return l10n.timeMinutesAgo(minutes: diff.inMinutes);
    }
    if (diff.inDays < 1) {
      return l10n.timeHoursAgo(hours: diff.inHours);
    }
    return l10n.timeDaysAgo(days: diff.inDays);
  }

  String _messageForType(AppLocalizations l10n, String type) {
    switch (type) {
      case 'auction_ending':
        return l10n.notificationAuctionEnding;
      case 'new_bid':
        return l10n.notificationNewBid;
      case 'wanted_match':
        return l10n.notificationWantedMatch;
      case 'price_drop':
        return l10n.notificationPriceDrop;
      case 'system':
      default:
        return l10n.notificationSystem;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final now = DateTime.now();
    final List<(String, DateTime)> notifications = [
      ('auction_ending', now.subtract(const Duration(minutes: 5))),
      ('new_bid', now.subtract(const Duration(hours: 1))),
      ('wanted_match', now.subtract(const Duration(hours: 3))),
      ('price_drop', now.subtract(const Duration(days: 1))),
      ('system', now.subtract(const Duration(days: 2))),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final (type, timestamp) = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(_messageForType(l10n, type)),
            subtitle: Text(_timeAgo(l10n, now.difference(timestamp))),
          );
        },
      ),
    );
  }
}
