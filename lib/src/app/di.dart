import 'package:flutter/widgets.dart';

import '../core/app_prefs.dart';
import '../core/app_state.dart';
import '../core/refresh/refresh_hub.dart';
import '../features/matching/domain/match_engine.dart';
import '../features/notifications/data/local_notification_center.dart';
import '../features/search/domain/mini_search_index.dart';
import '../features/search/domain/relevance_engine.dart';
import '../mock/seed_data.dart';

class AppDependencies {
  AppDependencies({required this.state, required this.refreshHub});

  final AppState state;
  final RefreshHubController refreshHub;

  static Future<AppDependencies> load() async {
    final prefs = await AppPrefs.load();
    final seed = SeedData.generate();
    final refreshHub = RefreshHubController();
    final notificationCenter = LocalNotificationCenter(seed.notifications);
    final state = AppState(
      prefs: prefs,
      searchIndex: MiniSearchIndex(),
      relevanceEngine: RelevanceEngine(),
      matchEngine: MatchEngine(),
      notificationCenter: notificationCenter,
      refreshHub: refreshHub,
      seed: seed,
    );
    return AppDependencies(state: state, refreshHub: refreshHub);
  }
}
