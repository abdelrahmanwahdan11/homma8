import 'package:card_swiper/card_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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
                      _CatalogSection(controller: controller),
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
  const _CatalogSection({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        _CategoryFilters(controller: controller),
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
                            ).animate().fadeIn(duration: 350.ms, delay: (index * 40).ms),
                          ),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: 0.78,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                        ),
                      ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSwiper(BuildContext context) {
    final items = controller.pagingController.itemList ?? [];
    return Swiper(
      itemCount: items.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: _AuctionCard(
          item: items[index],
          controller: controller,
        ),
      ),
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

class _AuctionCard extends StatelessWidget {
  const _AuctionCard({required this.item, required this.controller});

  final AuctionItem item;
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeRemaining = item.timeRemaining;
    final isEndingSoon = timeRemaining.inMinutes < 30 && timeRemaining.isNegative == false;
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
                  Text('${item.currency} ${item.currentBid.toStringAsFixed(0)}',
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 6),
                  Text('item_distance'.trParams({
                    'distance': item.distanceKm.toStringAsFixed(0),
                  })),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => controller.openDetail(item),
                          icon: const Icon(Icons.auto_awesome_rounded),
                          label: Text('item_ai_button'.tr),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.toggleFavorite(item),
                        icon: Icon(
                          item.isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: item.isFavorite
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
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
}
