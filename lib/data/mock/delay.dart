import 'dart:async';
import 'dart:math';

Future<void> mockLatency([int baseMs = 300]) async {
  final jitter = Random().nextInt(200);
  await Future<void>.delayed(Duration(milliseconds: baseMs + jitter));
}
