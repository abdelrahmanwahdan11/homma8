import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:transparent_image/transparent_image.dart';

import '../../../core/widgets/glass_card.dart';
import '../../../data/models/auction_item.dart';
import '../../../data/services/settings_service.dart';
import '../../alerts/views/alerts_view.dart';
import '../../bids/views/bids_view.dart';
import '../../favorites/views/favorites_view.dart';
import '../../sell_buy/views/sell_buy_view.dart';
import '../../settings/views/settings_view.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final settings = Get.find<SettingsService>();
        final useRail = constraints.maxWidth >= 900;
        return Scaffold(
          appBar: _HomeAppBar(controller: controller),
          body: Row(
            children: [
              if (useRail)
                Obx(
                  () => NavigationRail(
                    selectedIndex: controller.selectedIndex.value,
                    onDestinationSelected: controller.changeIndex,
                    labelType: NavigationRailLabelType.all,
                    destinations: [
                      NavigationRailDestination(
                        icon: const Icon(Icons.grid_view_rounded),
                        selectedIcon:
                            const Icon(Icons.grid_view_rounded, size: 28),
                        label: Text('nav_catalog'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.gavel_outlined),
                        selectedIcon: const Icon(Icons.gavel_rounded),
                        label: Text('nav_bids'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.favorite_outline),
                        selectedIcon:
                            const Icon(Icons.favorite_rounded, color: Colors.redAccent),
                        label: Text('nav_favorites'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.notifications_none),
                        selectedIcon: const Icon(Icons.notifications),
                        label: Text('nav_alerts'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.swap_horiz_rounded),
                        selectedIcon: const Icon(Icons.swap_horiz_rounded),
                        label: Text('nav_sell_buy'.tr),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings_outlined),
                        selectedIcon: const Icon(Icons.settings),
                        label: Text('nav_settings'.tr),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: controller.selectedIndex.value,
                    children: [
                      _CatalogSection(controller: controller, settings: settings),
                      const BidsView(embed: true),
                      const FavoritesView(embed: true),
                      const AlertsView(embed: true),
                      const SellBuyView(embed: true),
                      const SettingsView(embed: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: useRail
              ? null
              : Obx(
                  () => NavigationBar(
                    selectedIndex: controller.selectedIndex.value,
                    onDestinationSelected: controller.changeIndex,
                    destinations: [
                      NavigationDestination(
                        icon: const Icon(Icons.home_rounded),
                        label: 'nav_catalog'.tr,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.gavel_rounded),
                        label: 'nav_bids'.tr,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.add_circle_outline),
                        label: 'nav_sell_buy'.tr,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.notifications_outlined),
                        label: 'nav_alerts'.tr,
                      ),
                      NavigationDestination(
                        icon: const Icon(Icons.settings_outlined),
                        label: 'nav_settings'.tr,
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      titleSpacing: 24,
      title: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.search_rounded),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller.searchController,
                onChanged: controller.onSearchChanged,
                onSubmitted: controller.submitSearch,
                decoration: InputDecoration.collapsed(
                  hintText: 'home_search_hint'.tr,
                ),
              ),
            ),
            IconButton(
              tooltip: 'home_filters'.tr,
              onPressed: controller.saveFilterPreset,
              icon: const Icon(Icons.tune_rounded),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => controller.toggleViewMode(),
          icon: const Icon(Icons.dashboard_customize_rounded),
        ),
        IconButton(
          onPressed: () {
            final settings = Get.find<SettingsService>();
            final newMode = settings.themeMode.value == ThemeMode.dark
                ? ThemeMode.light
                : ThemeMode.dark;
            settings.updateTheme(newMode);
          },
          icon: const Icon(Icons.brightness_6_rounded),
        ),
        IconButton(
          onPressed: () {
            final settings = Get.find<SettingsService>();
            final newLocale = settings.locale.value.languageCode == 'en'
                ? const Locale('ar')
                : const Locale('en');
            settings.updateLocale(newLocale);
            Get.updateLocale(newLocale);
          },
          icon: const Icon(Icons.translate_rounded),
        ),
        const SizedBox(width: 12),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(88);
}

class _CatalogSection extends StatelessWidget {
  const _CatalogSection({required this.controller, required this.settings});

  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        if (settings.featureToggles['feature_recent_searches'] ?? true)
          _RecentSearches(controller: controller, settings: settings),
        _CategoryFilters(controller: controller),
        if (settings.featureToggles['feature_status_filters'] ?? true)
          _StatusChips(controller: controller),
        _SortDensityBar(controller: controller, settings: settings),
        if ((settings.featureToggles['feature_recently_viewed'] ?? true))
          Obx(
            () => controller.recentlyViewed.isEmpty
                ? const SizedBox.shrink()
                : _RecentlyViewed(controller: controller, settings: settings),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) {
              final width = box.maxWidth;
              final crossAxisCount = width >= 1200
                  ? 4
                  : width >= 900
                      ? 3
                      : 2;
              return Obx(
                () => controller.useSwiper.isTrue
                    ? _buildSwiper(context)
                    : RefreshIndicator(
                        onRefresh: () async => controller.refreshItems(),
                        child: PagedGridView<int, AuctionItem>(
                          padding: const EdgeInsets.all(16),
                          pagingController: controller.pagingController,
                          builderDelegate: PagedChildBuilderDelegate<AuctionItem>(
                            itemBuilder: (context, item, index) => _AuctionCard(
                              item: item,
                              controller: controller,
                              settings: settings,
                            ).animate().fadeIn(duration: 350.ms, delay: (index * 40).ms),
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: _densityAspect(controller.gridDensity.value),
                            crossAxisSpacing: _densitySpacing(controller.gridDensity.value),
                            mainAxisSpacing: _densitySpacing(controller.gridDensity.value),
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
        if (settings.featureToggles['feature_compare_items'] ?? true)
          Obx(
            () => controller.compareSelection.isEmpty
                ? const SizedBox.shrink()
                : _CompareTray(controller: controller, settings: settings),
          ),
      ],
    );
  }

  double _densitySpacing(String density) {
    return switch (density) {
      'cozy' => 20.0,
      'compact' => 12.0,
      _ => 16.0,
    };
  }

  double _densityAspect(String density) {
    return switch (density) {
      'cozy' => 0.9,
      'compact' => 0.72,
      _ => 0.78,
    };
  }

  Widget _buildSwiper(BuildContext context) {
    final items = controller.pagingController.itemList ?? [];
    if (items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return PageView.builder(
      controller: controller.spotlightPageController,
      itemCount: items.length,
      padEnds: false,
      itemBuilder: (context, index) {
        final inset = index == 0 ? 32.0 : 16.0;
        return Padding(
          padding: EdgeInsets.fromLTRB(inset, 24, 32, 24),
          child: AnimatedBuilder(
            animation: controller.spotlightPageController,
            builder: (context, child) {
              double scale = 1;
              if (controller.spotlightPageController.hasClients &&
                  controller.spotlightPageController.position.haveDimensions) {
                final page = controller.spotlightPageController.page ?? 0;
                final diff = (page - index).abs();
                scale = (1 - (diff * 0.08)).clamp(0.9, 1.0);
              }
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: _AuctionCard(
              item: items[index],
              controller: controller,
              settings: settings,
            ),
          ),
        );
      },
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final categories = [
      'all',
      'apartments',
      'cars',
      'retail',
      'smart_devices',
      'home_appliances',
    ];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            for (final category in categories)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text(category.tr),
                  selected: controller.selectedCategory.value == category,
                  onSelected: (_) => controller.selectCategory(category),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({required this.controller, required this.settings});

  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Obx(() {
      final recents = settings.recentSearches;
      if (recents.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('home_recent_searches'.tr, style: theme.textTheme.titleMedium),
                const Spacer(),
                TextButton(
                  onPressed: settings.clearRecentSearches,
                  child: Text('search_recent_clear'.tr),
                ),
              ],
            ),
            Wrap(
              spacing: 8,
              children: [
                for (final search in recents)
                  InputChip(
                    label: Text(search),
                    onPressed: () => controller.submitSearch(search),
                    onDeleted: () => settings.removeRecentSearch(search),
                  ),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }
}

class _StatusChips extends StatelessWidget {
  const _StatusChips({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final statuses = ['all', 'live', 'upcoming', 'ended'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(
        () => Row(
          children: [
            for (final status in statuses)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: ChoiceChip(
                  label: Text('home_status_$status'.tr),
                  selected: controller.statusFilter.value == status,
                  onSelected: (_) => controller.changeStatus(status),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SortDensityBar extends StatelessWidget {
  const _SortDensityBar({required this.controller, required this.settings});

  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortOptions = {
      'endingSoon': 'home_sort_ending'.tr,
      'nearest': 'home_sort_nearest'.tr,
      'priceLowHigh': 'home_sort_low_high'.tr,
      'priceHighLow': 'home_sort_high_low'.tr,
      'mostViewed': 'home_sort_popular'.tr,
    };
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Obx(
        () => Wrap(
          spacing: 12,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('home_sort_label'.tr, style: theme.textTheme.labelLarge),
                DropdownButton<String>(
                  value: controller.sortOption.value,
                  onChanged: (value) {
                    if (value != null) controller.changeSort(value);
                  },
                  items: [
                    for (final entry in sortOptions.entries)
                      DropdownMenuItem(value: entry.key, child: Text(entry.value)),
                  ],
                ),
              ],
            ),
            if (settings.featureToggles['feature_grid_density'] ?? true)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('home_density_label'.tr, style: theme.textTheme.labelLarge),
                  SegmentedButton<String>(
                    segments: [
                      ButtonSegment(value: 'cozy', label: Text('home_density_cozy'.tr)),
                      ButtonSegment(value: 'comfortable', label: Text('home_density_comfort'.tr)),
                      ButtonSegment(value: 'compact', label: Text('home_density_compact'.tr)),
                    ],
                    selected: {controller.gridDensity.value},
                    onSelectionChanged: (value) => controller.changeDensity(value.first),
                  ),
                ],
              ),
            FilterChip(
              label: Text('home_view_swiper'.tr),
              selected: controller.useSwiper.value,
              onSelected: (_) => controller.toggleViewMode(),
            ),
            if (settings.featureToggles['feature_saved_filters'] ?? true)
              ElevatedButton.icon(
                onPressed: () => _showSavedFilters(context),
                icon: const Icon(Icons.bookmark_added_outlined),
                label: Text('home_saved_filters'.tr),
              ),
          ],
        ),
      ),
    );
  }

  void _showSavedFilters(BuildContext context) {
    final saved = settings.savedFilters;
    if (saved.isEmpty) {
      Get.snackbar('app_name'.tr, 'home_no_saved_filters'.tr);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final preset in saved)
              ListTile(
                title: Text(preset['query'] as String? ?? ''),
                subtitle: Text(preset['category'] as String? ?? 'all'),
                trailing: IconButton(
                  icon: const Icon(Icons.play_arrow_rounded),
                  onPressed: () {
                    final query = preset['query'] as String? ?? '';
                    final category = preset['category'] as String? ?? 'all';
                    Navigator.of(context).pop();
                    controller.searchController.text = query;
                    controller.query.value = query;
                    controller.selectCategory(category);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _RecentlyViewed extends StatelessWidget {
  const _RecentlyViewed({required this.controller, required this.settings});

  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Obx(
        () => ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: controller.recentlyViewed.length,
          itemBuilder: (context, index) {
            final item = controller.recentlyViewed[index];
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: SizedBox(
                width: 220,
                child: GestureDetector(
                  onTap: () => controller.openDetail(item),
                  child: GlassCard(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(settings.formatPrice(item.currentBid, item.currency)),
                          const Spacer(),
                          Text('home_recently_viewed'.tr,
                              style: Theme.of(context).textTheme.labelMedium),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CompareTray extends StatelessWidget {
  const _CompareTray({required this.controller, required this.settings});

  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GlassCard(
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => Wrap(
                  spacing: 12,
                  children: [
                    for (final item in controller.selectedComparisons)
                      Chip(
                        label: Text(item.title),
                        onDeleted: () => controller.toggleCompare(item),
                      ),
                  ],
                ),
              ),
            ),
            FilledButton(
              onPressed: () => _showComparison(context),
              child: Text('home_compare_button'.tr),
            ),
          ],
        ),
      ),
    );
  }

  void _showComparison(BuildContext context) {
    final items = controller.selectedComparisons;
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('home_compare_title'.tr, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            for (final item in items)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 6),
                      Text(settings.formatPrice(item.currentBid, item.currency)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: item.specs.entries
                            .take(3)
                            .map((e) => Chip(label: Text('${e.key}: ${e.value}')))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({
    required this.item,
    required this.controller,
    required this.settings,
  });

  final AuctionItem item;
  final HomeController controller;
  final SettingsService settings;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeRemaining = item.timeRemaining;
    final isEndingSoon = timeRemaining.inMinutes < 30 && timeRemaining.isNegative == false;
    final features = settings.featureToggles;
    final formattedPrice = settings.formatPrice(item.currentBid, item.currency);
    final distanceText = settings.formatDistance(item.distanceKm);
    final isHot = item.views > 350;
    final isNew = DateTime.now().difference(item.startAt).inHours < 24;
    return InkWell(
      onTap: () => controller.openDetail(item),
      borderRadius: BorderRadius.circular(26),
      child: GlassCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Hero(
                tag: 'item-${item.id}',
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(26),
                    topRight: Radius.circular(26),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: item.images.first,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Image.memory(kTransparentImage, fit: BoxFit.cover),
                        errorWidget: (context, url, error) => const Icon(Icons.broken_image_outlined),
                      ),
                      if (isEndingSoon)
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colorScheme.tertiary,
                                    theme.colorScheme.primary,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                child: Text('home_ending_soon'.tr,
                                    style: theme.textTheme.labelLarge
                                        ?.copyWith(color: theme.colorScheme.onPrimary)),
                              ),
                            ),
                          ),
                        ),
                      if ((features['feature_hot_badges'] ?? true) && (isHot || isNew))
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Wrap(
                              spacing: 6,
                              children: [
                                if (isHot)
                                  Chip(
                                    backgroundColor:
                                        theme.colorScheme.errorContainer.withOpacity(0.85),
                                    label: Text('badge_hot'.tr,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(color: theme.colorScheme.onErrorContainer)),
                                  ),
                                if (isNew)
                                  Chip(
                                    backgroundColor:
                                        theme.colorScheme.primaryContainer.withOpacity(0.85),
                                    label: Text('badge_new'.tr,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      if ((features['feature_watchlist_banner'] ?? true) && item.watching)
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.visibility_rounded, size: 16),
                                  const SizedBox(width: 6),
                                  Text('home_watching'.tr,
                                      style: theme.textTheme.labelSmall),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: theme.textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text('item_current_bid'.tr,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      )),
                  Text(formattedPrice, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text('home_distance_value'.trParams({'distance': distanceText})),
                  if (features['feature_price_projection'] ?? false)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text('home_price_projection'.tr,
                          style: theme.textTheme.labelMedium),
                    ),
                  const SizedBox(height: 12),
                  if (features['feature_quick_bid_steps'] ?? true)
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final step in [5, 10, 15])
                          ActionChip(
                            label: Text('+${step}%'),
                            onPressed: () => _showQuickBid(context, step),
                          ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => _showAiSheet(context),
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: Text('item_ai_button'.tr),
                        ),
                      ),
                      IconButton(
                        tooltip: 'home_favorite'.tr,
                        onPressed: () => controller.toggleFavorite(item),
                        icon: Icon(
                          item.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: item.isFavorite
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                      if (features['feature_watchlist_banner'] ?? true)
                        IconButton(
                          tooltip: 'home_watch'.tr,
                          onPressed: () => controller.toggleWatching(item),
                          icon: Icon(
                            item.watching
                                ? Icons.visibility_rounded
                                : Icons.visibility_outlined,
                          ),
                        ),
                      if (features['feature_compare_items'] ?? true)
                        Obx(
                          () => IconButton(
                            tooltip: 'home_compare'.tr,
                            onPressed: () => controller.toggleCompare(item),
                            color: controller.compareSelection.contains(item.id)
                                ? theme.colorScheme.primary
                                : null,
                            icon: const Icon(Icons.table_view_rounded),
                          ),
                        ),
                      if (features['feature_reminder_scheduler'] ?? true)
                        IconButton(
                          tooltip: 'home_remind'.tr,
                          onPressed: () => controller.scheduleReminder(item),
                          icon: const Icon(Icons.alarm_add_rounded),
                        ),
                      IconButton(
                        tooltip: 'home_share'.tr,
                        onPressed: () async {
                          final link = 'https://vidgen.app/item/${item.id}';
                          await Clipboard.setData(ClipboardData(text: link));
                          Get.snackbar('app_name'.tr, 'share_link_copied'.tr);
                        },
                        icon: const Icon(Icons.share_rounded),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickBid(BuildContext context, int percent) {
    final increment = item.currentBid * (1 + percent / 100);
    Get.snackbar('app_name'.tr, 'home_quick_bid'.trParams({
      'amount': settings.formatPrice(increment, item.currency),
    }));
  }

  Future<void> _showAiSheet(BuildContext context) async {
    final features = settings.featureToggles;
    String mode = 'brief';
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
              child: Container(
                color: theme.colorScheme.surface.withOpacity(0.85),
                padding: const EdgeInsets.all(24),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('item_ai_summary'.tr, style: theme.textTheme.titleLarge),
                        const SizedBox(height: 12),
                        if (features['feature_ai_insights_modes'] ?? true)
                          SegmentedButton<String>(
                            segments: [
                              ButtonSegment(value: 'brief', label: Text('ai_mode_brief'.tr)),
                              ButtonSegment(value: 'detailed', label: Text('ai_mode_detailed'.tr)),
                              ButtonSegment(value: 'bullets', label: Text('ai_mode_bullets'.tr)),
                            ],
                            selected: {mode},
                            onSelectionChanged: (value) => setState(() => mode = value.first),
                          ),
                        const SizedBox(height: 16),
                        Text(item.aiSummary, style: theme.textTheme.bodyLarge),
                        const SizedBox(height: 12),
                        FilledButton.icon(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: item.aiSummary));
                            Get.snackbar('app_name'.tr, 'share_link_copied'.tr);
                          },
                          icon: const Icon(Icons.copy_rounded),
                          label: Text('action_copy'.tr),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
