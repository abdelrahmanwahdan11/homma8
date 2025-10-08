import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../core/theme/theme_manager.dart';
import '../../models/auction_item.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/primary_button.dart';
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
  late final ScrollController _scrollController;
  late final FocusNode _searchFocusNode;
  late final TextEditingController _searchController;
  late final ValueNotifier<bool> _searchFocusNotifier;
  bool _initialized = false;
  bool _loadingMore = false;
  bool _initialLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_handleScroll);
    _searchFocusNode = FocusNode();
    _searchController = TextEditingController();
    _searchFocusNotifier = ValueNotifier<bool>(false);
    _searchFocusNode.addListener(() {
      _searchFocusNotifier.value = _searchFocusNode.hasFocus;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final state = AppState.of(context);
    _searchController.text = state.searchQueryNotifier.value;
    if (state.itemsNotifier.value.isEmpty) {
      _initialLoading = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _seedInitialItems();
      });
    } else {
      for (final item in state.itemsNotifier.value) {
        item.favoriteNotifier.value = state.isFavorite(item.id);
      }
      final offset = state.getScrollPosition('home_scroll');
      if (offset != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(offset);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _searchFocusNode.dispose();
    _searchController.dispose();
    _searchFocusNotifier.dispose();
    super.dispose();
  }

  Future<void> _seedInitialItems() async {
    final state = AppState.of(context);
    final items = _generateMockItems(9);
    state.registerItems(items);
    setState(() => _initialLoading = false);
  }

  List<AuctionItem> _generateMockItems(int count) {
    final random = Random();
    final options = [
      (Icons.directions_car_rounded, 'Tesla Model S', 'Electric performance'),
      (Icons.phone_iphone_rounded, 'iPhone 15 Pro', 'Flagship smartphone'),
      (Icons.house_rounded, 'Skyline Apartment', 'City centre views'),
      (Icons.watch_rounded, 'Swiss Chronograph', 'Limited edition timepiece'),
      (Icons.computer_rounded, 'Gaming Laptop', 'RTX graphics powerhouse'),
      (Icons.camera_alt_rounded, 'Vintage Camera', 'Collector favourite'),
      (Icons.diamond_rounded, 'Emerald Necklace', 'Museum grade jewel'),
      (Icons.electric_bike_rounded, 'Electric Bike', 'City ready rides'),
    ];

    return List.generate(count, (index) {
      final choice = options[random.nextInt(options.length)];
      return AuctionItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}_$index',
        title: choice.$2,
        subtitle: choice.$3,
        description:
            '${choice.$2} with premium quality and verified inspection reports.',
        icon: choice.$1,
        initialPrice: 500 + random.nextInt(9500),
        duration: Duration(hours: 4 + random.nextInt(48)),
      );
    });
  }

  void _handleScroll() {
    final state = AppState.of(context);
    if (_scrollController.hasClients) {
      state.setScrollPosition('home_scroll', _scrollController.offset);
    }
    if (_loadingMore || !_scrollController.hasClients) return;
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 180) {
      _loadMoreItems();
    }
  }

  Future<void> _loadMoreItems() async {
    if (_loadingMore) return;
    setState(() => _loadingMore = true);
    await Future.delayed(const Duration(milliseconds: 750));
    if (!mounted) return;
    final state = AppState.of(context);
    final newItems = _generateMockItems(6);
    state.addMoreItems(newItems);
    setState(() => _loadingMore = false);
  }

  Future<void> _onRefresh() async {
    final state = AppState.of(context);
    await Future.delayed(const Duration(milliseconds: 600));
    final refreshed = _generateMockItems(10);
    state.registerItems(refreshed);
  }

  void _openDestination(int index) {
    final state = AppState.of(context);
    state.setNavigationIndex(index);
    Widget? page;
    switch (index) {
      case 1:
        page = FavoritesPage(items: state.itemsNotifier.value);
        break;
      case 2:
        page = AlertsPage();
        break;
      case 3:
        page = BidsPage(items: state.itemsNotifier.value);
        break;
      case 4:
        page = const SellBuyPage();
        break;
      case 5:
        page = const SettingsPage();
        break;
      default:
        return;
    }
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => page!))
        .then((_) => state.setNavigationIndex(0));
  }

  void _openAddItemSheet() {
    final lang = LanguageManager.of(context);
    final state = AppState.of(context);
    final titleController = TextEditingController();
    final priceController = TextEditingController();
    final focusTitle = FocusNode();
    final focusPrice = FocusNode();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GradientBackground(
          useSurface: true,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lang.t('add_item'),
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: titleController,
                    focusNode: focusTitle,
                    decoration: InputDecoration(labelText: lang.t('sell_form_title')),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: priceController,
                    focusNode: focusPrice,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: lang.t('sell_form_price')),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: lang.t('submit'),
                    onPressed: () {
                      final title = titleController.text.trim();
                      final price = double.tryParse(priceController.text.trim());
                      if (title.isEmpty || price == null || price <= 0) {
                        Navigator.of(context).pop();
                        state.showBannerMessage(lang.t('invalid_price'));
                        return;
                      }
                      final newItem = AuctionItem(
                        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
                        title: title,
                        subtitle: lang.t('sell_form_desc'),
                        description: lang.t('sell_form_desc'),
                        icon: Icons.star_rounded,
                        initialPrice: price,
                        duration: const Duration(hours: 24),
                      );
                      final items = List<AuctionItem>.from(state.itemsNotifier.value)
                        ..insert(0, newItem);
                      state.registerItems(items);
                      Navigator.of(context).pop();
                      state.showBannerMessage(lang.t('item_created'));
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      titleController.dispose();
      priceController.dispose();
      focusTitle.dispose();
      focusPrice.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final state = AppState.of(context);
    final gradients = Theme.of(context).extension<AppGradients>();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _openAddItemSheet,
          icon: const Icon(Icons.add_rounded),
          label: Text(lang.t('add_item')),
        ),
        bottomNavigationBar: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 900) {
              return const SizedBox.shrink();
            }
            return ValueListenableBuilder<int>(
              valueListenable: state.navigationIndexNotifier,
              builder: (context, index, _) {
                return BottomNavigationBar(
                  currentIndex: index,
                  onTap: (selected) {
                    if (selected == 0) return;
                    _openDestination(selected);
                  },
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .surface
                      .withOpacity(0.85),
                  items: [
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.dashboard_rounded),
                      label: lang.t('home'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.favorite_rounded),
                      label: lang.t('favorites'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.notifications_active_rounded),
                      label: lang.t('alerts'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.history_rounded),
                      label: lang.t('bids'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.swap_horiz_rounded),
                      label: lang.t('sell_buy'),
                    ),
                    BottomNavigationBarItem(
                      icon: const Icon(Icons.settings_rounded),
                      label: lang.t('settings'),
                    ),
                  ],
                );
              },
            );
          },
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 900;
            final content = _buildContent(state, lang, gradients);
            if (!isWide) {
              return content;
            }
            return Row(
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: state.navigationIndexNotifier,
                  builder: (context, index, _) {
                    return NavigationRail(
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .surface
                          .withOpacity(0.6),
                      selectedIndex: index,
                      onDestinationSelected: (selected) {
                        if (selected == 0) return;
                        _openDestination(selected);
                      },
                      labelType: NavigationRailLabelType.all,
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.dashboard_outlined),
                          selectedIcon: const Icon(Icons.dashboard_rounded),
                          label: Text(lang.t('home')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.favorite_border),
                          selectedIcon: const Icon(Icons.favorite_rounded),
                          label: Text(lang.t('favorites')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.notifications_none_rounded),
                          selectedIcon:
                              const Icon(Icons.notifications_active_rounded),
                          label: Text(lang.t('alerts')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.history_rounded),
                          selectedIcon: const Icon(Icons.history_rounded),
                          label: Text(lang.t('bids')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.swap_horiz_rounded),
                          selectedIcon: const Icon(Icons.swap_horiz_rounded),
                          label: Text(lang.t('sell_buy')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.settings_outlined),
                          selectedIcon: const Icon(Icons.settings_rounded),
                          label: Text(lang.t('settings')),
                        ),
                      ],
                    );
                  },
                ),
                Expanded(child: content),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(
    _AppStateScope state,
    LanguageManager lang,
    AppGradients? gradients,
  ) {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      displacement: 80,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            elevation: 0,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsetsDirectional.only(start: 24, bottom: 16),
              title: Text(lang.t('auction_app')),
              background: DecoratedBox(
                decoration: BoxDecoration(gradient: gradients?.primary),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => state.toggleCurrency(),
                icon: ValueListenableBuilder<String>(
                  valueListenable: state.currencyNotifier,
                  builder: (context, symbol, _) {
                    return Text(
                      symbol,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ),
              IconButton(
                onPressed: state.switchLanguage,
                icon: const Icon(Icons.translate_rounded),
              ),
              IconButton(
                onPressed: state.toggleTheme,
                icon: const Icon(Icons.brightness_6_rounded),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ValueListenableBuilder<bool>(
                    valueListenable: _searchFocusNotifier,
                    builder: (context, hasFocus, _) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: gradients?.surface,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            if (hasFocus)
                              BoxShadow(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.28),
                                blurRadius: 24,
                                offset: const Offset(0, 14),
                              ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: state.setSearchQuery,
                          decoration: InputDecoration(
                            hintText: lang.t('search_items'),
                            prefixIcon: const Icon(Icons.search_rounded),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 18,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.tune_rounded,
                                color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('filters'),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<RangeValues>(
                          valueListenable: state.priceFilterNotifier,
                          builder: (context, range, _) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${lang.t('price_range')}: ${range.start.toStringAsFixed(0)} - ${range.end.toStringAsFixed(0)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                RangeSlider(
                                  values: range,
                                  min: 0,
                                  max: 20000,
                                  divisions: 40,
                                  labels: RangeLabels(
                                    range.start.toStringAsFixed(0),
                                    range.end.toStringAsFixed(0),
                                  ),
                                  onChanged: state.setPriceFilter,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_initialLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: 0.82,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _LoadingPlaceholder(gradients: gradients),
                  childCount: 4,
                ),
              ),
            ),
          if (!_initialLoading)
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: ValueListenableBuilder<List<AuctionItem>>(
                valueListenable: state.itemsNotifier,
                builder: (context, items, _) {
                  return ValueListenableBuilder<String>(
                    valueListenable: state.searchQueryNotifier,
                    builder: (context, query, __) {
                      return ValueListenableBuilder<RangeValues>(
                        valueListenable: state.priceFilterNotifier,
                        builder: (context, range, ___) {
                          final filtered = items.where((item) {
                            final matchesQuery = query.isEmpty ||
                                item.title.toLowerCase().contains(query.toLowerCase()) ||
                                item.subtitle.toLowerCase().contains(query.toLowerCase());
                            final price = item.priceNotifier.value;
                            final matchesPrice =
                                price >= range.start && price <= range.end;
                            return matchesQuery && matchesPrice;
                          }).toList();

                          if (filtered.isEmpty) {
                            return SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 60),
                                child: Column(
                                  children: [
                                    Icon(Icons.inbox_outlined,
                                        size: 64,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.4)),
                                    const SizedBox(height: 16),
                                    Text(
                                      lang.t('empty_state'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }

                          final crossAxisCount = MediaQuery.of(context).size.width > 1000
                              ? 3
                              : MediaQuery.of(context).size.width > 700
                                  ? 2
                                  : 1;

                          return SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.82,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = filtered[index];
                                item.favoriteNotifier.value =
                                    state.isFavorite(item.id);
                                return AuctionCard(
                                  item: item,
                                  lang: lang,
                                  currencySymbol:
                                      '${state.currencyNotifier.value} ',
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ItemDetailPage(item: item),
                                      ),
                                    );
                                  },
                                  onBid: () => state.addBidForItem(item, 50),
                                  onToggleFavorite: () => state.toggleFavorite(item),
                                );
                              },
                              childCount: filtered.length,
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _loadingMore
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation(
                                Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(lang.t('loading_more')),
                        ],
                      ),
                    )
                  : const SizedBox(height: 32),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingPlaceholder extends StatelessWidget {
  const _LoadingPlaceholder({required this.gradients});

  final AppGradients? gradients;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: gradients?.surface,
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _ShimmerBar(widthFactor: 0.6, gradients: gradients),
          const SizedBox(height: 8),
          _ShimmerBar(widthFactor: 0.4, gradients: gradients),
        ],
      ),
    );
  }
}

class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar({required this.widthFactor, required this.gradients});

  final double widthFactor;
  final AppGradients? gradients;

  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerGradient = LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.15),
          ],
          stops: [
            (_controller.value - 0.3).clamp(0.0, 1.0),
            _controller.value,
            (_controller.value + 0.3).clamp(0.0, 1.0),
          ],
        );
        return FractionallySizedBox(
          widthFactor: widget.widthFactor,
          child: Container(
            height: 14,
            decoration: BoxDecoration(
              gradient: widget.gradients?.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: shimmerGradient,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
