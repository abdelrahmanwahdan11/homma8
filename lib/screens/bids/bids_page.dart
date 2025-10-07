import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/auction_item.dart';
import '../../widgets/animated_price.dart';
import '../../widgets/countdown_timer.dart';
import '../../widgets/glass_card.dart';

class BidsPage extends StatefulWidget {
  const BidsPage({required this.items, super.key});

  final List<AuctionItem> items;

  @override
  State<BidsPage> createState() => _BidsPageState();
}

class _BidsPageState extends State<BidsPage> {
  late final ValueNotifier<int> _versionNotifier;
  final Map<AuctionItem, VoidCallback> _listeners = {};

  @override
  void initState() {
    super.initState();
    _versionNotifier = ValueNotifier<int>(0);
    for (final item in widget.items) {
      void listener() => _versionNotifier.value++;
      item.hasBidNotifier.addListener(listener);
      item.priceNotifier.addListener(listener);
      _listeners[item] = listener;
    }
  }

  @override
  void dispose() {
    for (final entry in _listeners.entries) {
      entry.key.hasBidNotifier.removeListener(entry.value);
      entry.key.priceNotifier.removeListener(entry.value);
    }
    _versionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('bids')),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _versionNotifier,
        builder: (context, _, __) {
          final bids = widget.items
              .where((item) => item.hasBidNotifier.value)
              .toList(growable: false);
          if (bids.isEmpty) {
            return Center(
              child: Text(
                lang.t('no_bids'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            );
          }
          final currency = lang.locale.languageCode == 'ar' ? 'د.إ ' : 'USD ';
          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final item = bids[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(item.icon, size: 28, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              item.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      AnimatedPrice(priceNotifier: item.priceNotifier, currency: currency),
                      const SizedBox(height: 12),
                      Text(
                        lang.t('countdown'),
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                      ),
                      const SizedBox(height: 6),
                      CountdownTimer(endTime: item.endTime),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
