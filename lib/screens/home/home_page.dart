import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../models/auction_item.dart';
import '../../widgets/auction_card.dart';
import '../alerts/alerts_page.dart';
import '../bids/bids_page.dart';
import '../favorites/favorites_page.dart';
import '../item_detail/item_detail_page.dart';
import '../sell_buy/sell_buy_page.dart';
import '../settings/settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<AuctionItem> _items = [];
  late final ScrollController _scrollController;
  bool _loadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _populateInitialItems();
  }

  void _populateInitialItems() {
    _items
      ..clear()
      ..addAll(_generateMockItems());
  }

  List<AuctionItem> _generateMockItems() {
    final icons = [
      Icons.directions_car_rounded,
      Icons.phone_iphone_rounded,
      Icons.house_rounded,
      Icons.watch_rounded,
      Icons.computer_rounded,
      Icons.camera_alt_rounded,
    ];
    final titles = [
      'Tesla Model S',
      'iPhone 15 Pro',
      'Skyline Apartment',
      'Swiss Chronograph',
      'Gaming Laptop',
      'Vintage Camera',
    ];
    final subtitles = [
      'Electric performance',
      'Flagship smartphone',
      'City center view',
      'Limited edition',
      'RTX graphics',
      'Collector item',
    ];
    final descriptions = [
      'Experience top-tier performance with premium finishes.',
      'Secure the latest technology at an unbeatable price.',
      'Luxury apartment with breathtaking skyline views.',
      'Timeless craftsmanship and precision.',
      'High-end build for creators and gamers alike.',
      'Restored and ready for your next photoshoot.',
    ];
    final random = Random();
    return List.generate(8, (index) {
      final icon = icons[index % icons.length];
      return AuctionItem(
        id: 'item_$index_${DateTime.now().millisecondsSinceEpoch}',
        title: titles[index % titles.length],
        subtitle: subtitles[index % subtitles.length],
        description: descriptions[index % descriptions.length],
        icon: icon,
        initialPrice: 1000 + random.nextInt(9000),
        duration: Duration(hours: 6 + random.nextInt(48)),
      );
    });
  }

  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    setState(() {
      for (final item in _items) {
        item.dispose();
      }
      _items
        ..clear()
        ..addAll(_generateMockItems());
    });
  }

  void _handleScroll() {
    if (_loadingMore) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 120) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    setState(() => _loadingMore = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _items.addAll(_generateMockItems());
      _loadingMore = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  void _openDetails(AuctionItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ItemDetailPage(item: item),
      ),
    );
  }

  void _toggleFavorite(AuctionItem item, LanguageManager lang) {
    item.toggleFavorite();
    final isFavorite = item.favoriteNotifier.value;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lang.t(isFavorite ? 'added_favorite' : 'removed_favorite'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('auction_app')),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => FavoritesPage(items: _items),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_active_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AlertsPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.gavel_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BidsPage(items: _items),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SellBuyPage()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 900
                ? 3
                : constraints.maxWidth > 600
                    ? 2
                    : 1;
            return CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = _items[index];
                        return AuctionCard(
                          item: item,
                          lang: lang,
                          onTap: () => _openDetails(item),
                          onBid: () {
                            item.placeBid(50);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(lang.t('bid_success'))),
                            );
                          },
                          onToggleFavorite: () => _toggleFavorite(item, lang),
                        );
                      },
                      childCount: _items.length,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.78,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _loadingMore
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          )
                        : const SizedBox(height: 24),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
