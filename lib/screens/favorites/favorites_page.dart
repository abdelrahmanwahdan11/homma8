import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/auction_item.dart';
import '../../widgets/animated_price.dart';
import '../../widgets/glass_card.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({required this.items, super.key});

  final List<AuctionItem> items;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late final ValueNotifier<int> _versionNotifier;
  final Map<AuctionItem, List<VoidCallback>> _listeners = {};

  @override
  void initState() {
    super.initState();
    _versionNotifier = ValueNotifier<int>(0);
    for (final item in widget.items) {
      void favoriteListener() => _versionNotifier.value++;
      void priceListener() => _versionNotifier.value++;
      item.favoriteNotifier.addListener(favoriteListener);
      item.priceNotifier.addListener(priceListener);
      _listeners[item] = [favoriteListener, priceListener];
    }
  }

  @override
  void dispose() {
    for (final entry in _listeners.entries) {
      entry.key.favoriteNotifier.removeListener(entry.value[0]);
      entry.key.priceNotifier.removeListener(entry.value[1]);
    }
    _versionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('favorites')),
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _versionNotifier,
        builder: (context, _, __) {
          final favorites = widget.items
              .where((item) => item.favoriteNotifier.value)
              .toList(growable: false);
          if (favorites.isEmpty) {
            return Center(
              child: Text(
                lang.t('favorites_empty'),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
              ),
            );
          }
          final currency = lang.locale.languageCode == 'ar' ? 'د.إ ' : 'USD ';
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.8,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(item.icon, size: 28, color: Theme.of(context).colorScheme.primary),
                        const Spacer(),
                        ValueListenableBuilder<bool>(
                          valueListenable: item.favoriteNotifier,
                          builder: (context, isFavorite, _) {
                            return IconButton(
                              onPressed: item.toggleFavorite,
                              icon: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 250),
                                child: Icon(
                                  isFavorite ? Icons.favorite : Icons.favorite_border,
                                  key: ValueKey<bool>(isFavorite),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      item.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    AnimatedPrice(priceNotifier: item.priceNotifier, currency: currency),
                    const Spacer(),
                    Text(
                      item.subtitle,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
