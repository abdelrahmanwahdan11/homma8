import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/mock_data.dart';
import '../../data/models.dart';
import '../../widgets/app_navigation.dart';
import '../../widgets/auction_card.dart';
import '../../widgets/glass_container.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  final ValueNotifier<bool> _isGrid = ValueNotifier(true);
  late final ValueNotifier<List<Product>> _offersNotifier;

  @override
  void initState() {
    super.initState();
    _offersNotifier = ValueNotifier(MockData.offers());
  }

  @override
  void dispose() {
    _isGrid.dispose();
    _offersNotifier.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    _offersNotifier.value = MockData.offers();
  }

  void _onNavigate(int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
        break;
      case 1:
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
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('offers_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationBar(
        currentIndex: 1,
        onTap: _onNavigate,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ValueListenableBuilder<bool>(
              valueListenable: _isGrid,
              builder: (context, isGrid, _) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGrid
                          ? lang.t('switch_to_list')
                          : lang.t('switch_to_grid'),
                      style: theme.textTheme.titleMedium,
                    ),
                    Switch(
                      value: isGrid,
                      onChanged: (value) => _isGrid.value = value,
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder<bool>(
                valueListenable: _isGrid,
                builder: (context, isGrid, _) {
                  return ValueListenableBuilder<List<Product>>(
                    valueListenable: _offersNotifier,
                    builder: (context, offers, __) {
                      if (offers.isEmpty) {
                        return Center(
                          child: Text(
                            lang.t('no_offers'),
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      }
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: RefreshIndicator(
                          key: ValueKey(isGrid),
                          onRefresh: _refresh,
                          child: isGrid
                              ? GridView.builder(
                                  padding: EdgeInsets.zero,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).size.width >= 900
                                            ? 3
                                            : 2,
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: MediaQuery.of(context)
                                                .size
                                                .width >=
                                            900
                                        ? 0.85
                                        : 0.78,
                                  ),
                                  itemCount: offers.length,
                                  itemBuilder: (context, index) {
                                    final product = offers[index];
                                    return AuctionCard(
                                      product: product,
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                          AppRoutes.productDetails,
                                          arguments: product,
                                        );
                                      },
                                    );
                                  },
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemCount: offers.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                                  itemBuilder: (context, index) {
                                    final product = offers[index];
                                    return AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      child: GlassContainer(
                                        child: ListTile(
                                          contentPadding: const EdgeInsets.all(16),
                                          leading: CircleAvatar(
                                            radius: 32,
                                            backgroundImage:
                                                NetworkImage(product.images.first),
                                          ),
                                          title: Text(product.title),
                                          subtitle: Text(
                                            '${lang.t('current_bid')}: ${product.priceCurrent.toStringAsFixed(2)}',
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '-${product.discount.toStringAsFixed(0)}%',
                                                style: theme.textTheme.titleMedium
                                                    ?.copyWith(
                                                  color:
                                                      theme.colorScheme.primary,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                lang.t('bid_now'),
                                                style: theme.textTheme.bodySmall,
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                              AppRoutes.productDetails,
                                              arguments: product,
                                            );
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
