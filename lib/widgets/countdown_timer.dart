import 'dart:async';

import 'package:flutter/material.dart';

import '../core/localization/language_manager.dart';

class CountdownTimer extends StatefulWidget {
  const CountdownTimer({
    required this.endTime,
    this.onFinished,
    super.key,
  });

  final DateTime endTime;
  final VoidCallback? onFinished;

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = _calculateRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final next = _calculateRemaining();
      if (!mounted) return;
      setState(() => _remaining = next);
      if (next == Duration.zero) {
        _timer?.cancel();
        widget.onFinished?.call();
      }
    });
  }

  Duration _calculateRemaining() {
    final now = DateTime.now();
    final remaining = widget.endTime.difference(now);
    if (remaining.isNegative) {
      return Duration.zero;
    }
    return remaining;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _format(Duration duration, LanguageManager lang) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;
    final parts = <String>[];
    if (days > 0) parts.add('${days}${lang.t('days')}');
    if (hours > 0) parts.add('${hours}${lang.t('hours')}');
    if (minutes > 0) parts.add('${minutes}${lang.t('minutes')}');
    parts.add('${seconds}${lang.t('seconds')}');
    return parts.join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _remaining == Duration.zero
            ? lang.t('timer_finished')
            : _format(_remaining, lang),
        key: ValueKey<int>(_remaining.inSeconds),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }
}
