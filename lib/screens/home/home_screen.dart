
import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/models.dart';
import '../../services/mock_api_service.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/shimmer_placeholder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final MockApiService _api;
  late final ScrollController _scrollController;
  late final ValueNotifier<List<Product>> _productsNotifier;
  late final ValueNotifier<List<Product>> _visibleProductsNotifier;
  late final ValueNotifier<bool> _loadingNotifier;
  Timer? _searchDebounce;
  bool _isLoadingMore = false;
  bool _initialized = false;
  bool _hasError = false;
  String _searchQuery = '';
  DateTime? _pageEnter;

  ValueNotifier<String>? _filterNotifier;

  @override
  void initState() {
    super.initState();
    _api = MockApiService.instance;
    _productsNotifier = ValueNotifier<List<Product>>(<Product>[]);
    _visibleProductsNotifier = ValueNotifier<List<Product>>(<Product>[]);
    _loadingNotifier = ValueNotifier<bool>(true);
    _scrollController = ScrollController()..addListener(_onScroll);
    _api.connectivityNotifier.addListener(_handleConnectivityChange);
    _loadInitial();
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
      unawaited(app.analytics.trackPageView('home'));
      _pageEnter = DateTime.now();
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _api.connectivityNotifier.removeListener(_handleConnectivityChange);
    _productsNotifier.dispose();
    _visibleProductsNotifier.dispose();
    _loadingNotifier.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    if (_pageEnter != null) {
      final duration = DateTime.now().difference(_pageEnter!);
      unawaited(AppState.of(context)
          .analytics
          .trackTimeSpent(pageId: 'home', duration: duration));
    }
    super.dispose();
  }

  Future<void> _loadInitial({bool force = false}) async {
    _loadingNotifier.value = true;
    try {
      final products = await _api.fetchProducts(forceRefresh: force);
      _productsNotifier.value = products;
      _applyFilter(AppState.of(context).homeFilterNotifier.value, save: false);
      setState(() {
        _hasError = false;
      });
    } on MockApiException {
      if (!mounted) return;
      setState(() {
        _hasError = true;
      });
    } finally {
      _loadingNotifier.value = false;
    }
  }

  Future<void> _refresh() async {
    await _loadInitial(force: true);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    AppState.of(context).setHomeScrollOffset(_scrollController.offset);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 120 &&
        !_isLoadingMore && !_loadingNotifier.value) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final current = [..._productsNotifier.value];
      final next = await _api.fetchProducts();
      final start = current.length;
      for (var i = 0; i < next.length; i++) {
        final product = next[i];
        final synthetic = product.copyWith(
          priceCurrent: product.priceCurrent + (i + start) * 8,
          bidsCount: product.bidsCount + i,
        );
        current.add(synthetic);
      }
      _productsNotifier.value = current;
      _applyFilter(AppState.of(context).homeFilterNotifier.value, save: false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  void _handleConnectivityChange() {
    if (!mounted) return;
    if (_api.connectivityNotifier.value &&
        _productsNotifier.value.isEmpty &&
        !_loadingNotifier.value) {
      _loadInitial(force: true);
    }
    setState(() {});
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
    var visible = products;
    if (_searchQuery.isNotEmpty) {
      visible = products
          .where((p) =>
              p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.tags.any((tag) =>
                  tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();
    }
    _visibleProductsNotifier.value = visible;
    if (save) {
      final app = AppState.of(context);
      app.setHomeFilter(filter);
      _filterNotifier?.value = filter;
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 320), () {
      if (!mounted) return;
      _searchQuery = value.trim();
      _applyFilter(AppState.of(context).homeFilterNotifier.value, save: false);
      if (_searchQuery.isNotEmpty) {
        AppState.of(context).addSearchQuery(_searchQuery);
      }
    });
  }

  Future<void> _showQuickBid(Product product) async {
    final lang = LanguageManager.of(context);
    final controller = TextEditingController(
      text: (product.priceCurrent + 20).toStringAsFixed(0),
    );
    final formKey = GlobalKey<FormState>();
    bool submitting = false;
    double? errorShake;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: GlassContainer(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.flash_on_rounded),
                          const SizedBox(width: 12),
                          Text(
                            lang.t('quick_bid'),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${lang.t('current_bid')}: ${product.priceCurrent.toStringAsFixed(0)} ${lang.t('currency')}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),
                      AnimatedBuilder(
                        animation: Listenable.merge([controller]),
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(errorShake ?? 0, 0),
                            child: child,
                          );
                        },
                        child: TextFormField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: lang.t('place_bid'),
                            suffixText: lang.t('currency'),
                          ),
                          validator: (value) {
                            final amount = double.tryParse(value ?? '');
                            if (amount == null) {
                              return lang.t('invalid_number');
                            }
                            if (amount <= product.priceCurrent) {
                              return lang.t('bid_too_low');
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: submitting
                              ? null
                              : () async {
                                  if (!formKey.currentState!.validate()) {
                                    setSheetState(() {
                                      errorShake = errorShake == 0 ? 12 : -12;
                                    });
                                    await Future<void>.delayed(
                                      const Duration(milliseconds: 120),
                                    );
                                    setSheetState(() {
                                      errorShake = 0;
                                    });
                                    return;
                                  }
                                  setSheetState(() {
                                    submitting = true;
                                  });
                                  try {
                                    final amount =
                                        double.parse(controller.text.trim());
                                    final updated = await _api.postBid(
                                      productId: product.id,
                                      amount: amount,
                                    );
                                    final list = [..._productsNotifier.value];
                                    final index = list
                                        .indexWhere((item) => item.id == product.id);
                                    if (index != -1) {
                                      list[index] = updated;
                                      _productsNotifier.value = list;
                                      _applyFilter(
                                        AppState.of(context)
                                            .homeFilterNotifier
                                            .value,
                                        save: false,
                                      );
                                    }
                                    if (mounted) {
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(lang.t('bid_success')),
                                        ),
                                      );
                                    }
                                  } on MockApiException catch (error) {
                                    setSheetState(() {
                                      submitting = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(error.message)),
                                    );
                                  }
                                },
                          child: submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text(lang.t('confirm')),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _aiHintFor(Product product, LanguageManager lang) {
    final suggested = product.priceCurrent * 1.05;
    return '${lang.t('recommendations')}: ${suggested.toStringAsFixed(0)} ${lang.t('currency')}';
  }

  Widget _buildSearchHistory(LanguageManager lang, AppState app) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: app.searchHistoryNotifier,
      builder: (context, history, _) {
        if (history.isEmpty) {
          return const SizedBox.shrink();
        }
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...history.map(
                  (query) => Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8),
                    child: ActionChip(
                      label: Text(query),
                      onPressed: () {
                        _onSearchChanged(query);
                        _applyFilter(app.homeFilterNotifier.value, save: false);
                      },
                    ),
                  ),
                ),
                ActionChip(
                  label: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () => app.clearSearchHistory(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);
    final app = AppState.of(context);

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text(lang.t('home')),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi_off_rounded),
            onPressed: _api.toggleConnection,
          ),
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
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                                  onChanged: _onSearchChanged,
                                  decoration: InputDecoration(
                                    hintText: lang.t('search_items'),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildSearchHistory(lang, app),
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
                                    onSelected: () =>
                                        _applyFilter('ending_soon'),
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
                        if (_hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: TextButton.icon(
                              onPressed: () => _loadInitial(force: true),
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(lang.t('retry')),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                ValueListenableBuilder<bool>(
                  valueListenable: _loadingNotifier,
                  builder: (context, loading, _) {
                    if (loading) {
                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.76,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => const ShimmerPlaceholder(),
                            childCount: 6,
                          ),
                        ),
                      );
                    }
                    return ValueListenableBuilder<List<Product>>(
                      valueListenable: _visibleProductsNotifier,
                      builder: (context, products, _) {
                        if (products.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32, vertical: 48),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inventory_2_outlined,
                                    size: 64,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    lang.t('no_offers'),
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        final width = MediaQuery.of(context).size.width;
                        final crossAxisCount = width >= 1200
                            ? 4
                            : width >= 900
                                ? 3
                                : 2;
                        return SliverPadding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                          sliver: SliverGrid(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
                                      child: Opacity(
                                        opacity: value,
                                        child: child,
                                      ),
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
                                    onLongPress: () => _showQuickBid(product),
                                    aiHint: _aiHintFor(product, lang),
                                  ),
                                );
                              },
                              childCount: products.length,
                            ),
                          ),
                        );
                      },
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
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ValueListenableBuilder<bool>(
              valueListenable: _api.connectivityNotifier,
              builder: (context, online, _) {
                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: online ? 0 : 1,
                  child: online
                      ? const SizedBox.shrink()
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          color: theme.colorScheme.error.withOpacity(0.9),
                          child: Text(
                            lang.t('connection_lost'),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onError,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<List<Product>>(
        valueListenable: _visibleProductsNotifier,
        builder: (context, products, _) {
          final disabled = products.isEmpty || _loadingNotifier.value;
          return FloatingActionButton.extended(
            heroTag: 'home_quick_bid',
            onPressed:
                disabled ? null : () => _showQuickBid(products.first),
            icon: const Icon(Icons.flash_auto),
            label: Text(lang.t('quick_bid')),
          );
        },
      ),
    );
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
