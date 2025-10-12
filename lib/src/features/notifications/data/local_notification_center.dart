import 'package:flutter/foundation.dart';

import '../../../models/models.dart';

class LocalNotificationCenter extends ChangeNotifier {
  LocalNotificationCenter(List<NotificationEntry> initial)
      : _entries = List<NotificationEntry>.from(initial);

  final List<NotificationEntry> _entries;

  List<NotificationEntry> get entries => List<NotificationEntry>.unmodifiable(_entries);

  void push(NotificationEntry entry) {
    _entries.insert(0, entry);
    notifyListeners();
  }

  void markRead(String id) {
    final index = _entries.indexWhere((element) => element.id == id);
    if (index == -1) {
      return;
    }
    final entry = _entries[index];
    _entries[index] = entry.copyWith(read: true);
    notifyListeners();
  }

  void clearRead() {
    _entries.removeWhere((element) => element.read);
    notifyListeners();
  }
}
