import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  String _timeAgo(Duration diff) {
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final List<(String, DateTime, String)> notifications = [
      ('auction_ending', now.subtract(const Duration(minutes: 5)), 'Auction ending soon'),
      ('new_bid', now.subtract(const Duration(hours: 1)), 'You received a new bid'),
      ('wanted_match', now.subtract(const Duration(hours: 3)), 'New wanted match for your listing'),
      ('price_drop', now.subtract(const Duration(days: 1)), 'Price drop detected'),
      ('system', now.subtract(const Duration(days: 2)), 'System maintenance scheduled'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final (type, timestamp, title) = notifications[index];
          return ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(title),
            subtitle: Text(type),
            trailing: Text(_timeAgo(now.difference(timestamp))),
          );
        },
      ),
    );
  }
}
