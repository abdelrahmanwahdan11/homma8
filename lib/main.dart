import 'package:flutter/material.dart';
import 'src/app/app.dart';
import 'src/app/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.load();
  runApp(BentoBidApp(state: dependencies.state));
}
