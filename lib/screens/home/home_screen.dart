import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/glass_container.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ValueNotifier<List<Product>> _productsNotifier;
  late final ScrollController _scrollController;
  bool _isLoadingMore = false;
  bool _initialized = false;

  ValueNotifier<String>? _filterNotifier;

  @override
  void initState() {
    super.initState();
    _productsNotifier = ValueNotifier(MockData.products());
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final app = AppState.of(context);
      _filterNotifier = app.homeFilterNotifier;
      final offset = app.homeScrollOffsetNotifier.value;
      if (offset > 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(offset);
          }
        });
      }
      _applyFilter(app.homeFilterNotifier.value, save: false);
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _productsNotifier.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    _productsNotifier.value = MockData.products();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    AppState.of(context).setHomeScrollOffset(_scrollController.offset);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        !_isLoadingMore) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    await Future<void>.delayed(const Duration(seconds: 1));
    final more = MockData.products()
        .map((p) => p.copyWith(priceCurrent: p.priceCurrent + 25))
        .toList();
    _productsNotifier.value = [..._productsNotifier.value, ...more];
    setState(() {
      _isLoadingMore = false;
    });
  }

  void _applyFilter(String filter, {bool save = true}) {
    final products = [..._productsNotifier.value];
    switch (filter) {
      case 'ending_soon':
        products.sort((a, b) => a.endTime.compareTo(b.endTime));
        break;
      case 'highest_discount':
        products.sort((b, a) => a.discount.compareTo(b.discount));
        break;
      default:
        products.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    _productsNotifier.value = products;
    if (save) {
      AppState.of(context).setHomeFilter(filter);
      _filterNotifier?.value = filter;
    }
  }

  void _onNavigate(int index) {
    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed(AppRoutes.offers);
        break;
      case 2:
        Navigator.of(context).pushReplacementNamed(AppRoutes.wanted);
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed(AppRoutes.profile);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Navigator.of(context).pushNamed(AppRoutes.profile),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 0,
        onTap: _onNavigate,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassContainer(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: lang.t('search_items'),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_filterNotifier != null)
                      ValueListenableBuilder<String>(
                        valueListenable: _filterNotifier!,
                        builder: (context, filter, _) {
                          return Wrap(
                            spacing: 12,
                            runSpacing: 8,
                            children: [
                              _FilterChip(
                                label: lang.t('nearest'),
                                selected: filter == 'nearest',
                                onSelected: () => _applyFilter('nearest'),
                              ),
                              _FilterChip(
                                label: lang.t('ending_soon'),
                                selected: filter == 'ending_soon',
                                onSelected: () => _applyFilter('ending_soon'),
                              ),
                              _FilterChip(
                                label: lang.t('highest_discount'),
                                selected: filter == 'highest_discount',
                                onSelected: () =>
                                    _applyFilter('highest_discount'),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            ValueListenableBuilder<List<Product>>(
              valueListenable: _productsNotifier,
              builder: (context, products, _) {
                final width = MediaQuery.of(context).size.width;
                final crossAxisCount = width >= 1200
                    ? 4
                    : width >= 900
                        ? 3
                        : 2;
                return SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: width >= 900 ? 0.8 : 0.76,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = products[index];
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: const Duration(milliseconds: 400),
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 20 * (1 - value)),
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: AuctionCard(
                            product: product,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AppRoutes.productDetails,
                                arguments: product,
                              );
                            },
                          ),
                        );
                      },
                      childCount: products.length,
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _isLoadingMore
                    ? const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: selected
            ? LinearGradient(
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.6),
                ],
              )
            : null,
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(selected ? 0.0 : 0.2),
        ),
        color: selected
            ? null
            : theme.colorScheme.surface.withOpacity(0.9),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ]
            : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onSelected,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: selected
                  ? theme.colorScheme.onPrimary
                  : theme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
