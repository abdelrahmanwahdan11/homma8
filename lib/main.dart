import 'package:flutter/material.dart';

import 'app.dart';
import 'core/app_state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appState = AppState();
  await appState.init();
  runApp(AppStateScope(notifier: appState, child: BazaarApp(appState: appState)));
}
