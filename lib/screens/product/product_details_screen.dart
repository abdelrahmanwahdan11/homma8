import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/models.dart';
import '../../widgets/bid_module.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/page_indicator.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.product});

  final Product? product;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _pageNotifier;
  late final ValueNotifier<double> _bidNotifier;
  late Duration _remaining;
  Timer? _carouselTimer;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageNotifier = ValueNotifier(0);
    final product = widget.product ?? _placeholder();
    _bidNotifier = ValueNotifier(product.priceCurrent);
    _remaining = product.timeLeft;
    _startCarousel();
    _startCountdown();
  }

  @override
  void didUpdateWidget(covariant ProductDetailsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.product?.id != widget.product?.id) {
      final product = widget.product ?? _placeholder();
      _bidNotifier.value = product.priceCurrent;
      _remaining = product.timeLeft;
      _pageNotifier.value = 0;
      _startCountdown();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _pageNotifier.dispose();
    _bidNotifier.dispose();
    _carouselTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCarousel() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      final total = widget.product?.images.length ?? 0;
      if (total <= 1) return;
      final nextPage = (_pageNotifier.value + 1) % total;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
      _pageNotifier.value = nextPage;
    });
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
        if (_remaining.isNegative) {
          _remaining = Duration.zero;
          timer.cancel();
        }
      });
    });
  }

  Product _placeholder() {
    return const Product(
      id: 'placeholder',
      title: 'SouqBid Concept',
      images: ['https://picsum.photos/seed/souqbid/800/600'],
      priceCurrent: 320,
      endTime: DateTime(2099),
      seller: 'SouqBid Studio',
      bidsCount: 12,
      discount: 12,
      tags: ['concept'],
    );
  }

  String _formatDuration(Duration duration, LanguageManager lang) {
    if (duration.inSeconds <= 0) {
      return lang.t('ending_in');
    }
    if (duration.inDays > 0) {
      return '${duration.inDays}${lang.t('days')}';
    }
    if (duration.inHours > 0) {
      return '${duration.inHours}${lang.t('hours')}';
    }
    if (duration.inMinutes > 0) {
      return '${duration.inMinutes}${lang.t('minutes')}';
    }
    return '${duration.inSeconds}${lang.t('seconds')}';
  }

  void _openBidSheet() {
    final product = widget.product ?? _placeholder();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: BidModule(
            currentBid: _bidNotifier.value,
            onSubmit: (value) {
              _bidNotifier.value = value;
              AppState.of(context).setLastRoute(AppRoutes.productDetails);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product ?? _placeholder();
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openBidSheet,
        icon: const Icon(Icons.gavel_outlined),
        label: Text(lang.t('bid_now')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: Stack(
                children: [
                  Hero(
                    tag: 'product_${product.id}',
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => _pageNotifier.value = index,
                      itemCount: product.images.length,
                      itemBuilder: (context, index) {
                        final image = product.images[index];
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          child: Image.network(
                            image,
                            key: ValueKey(image),
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.05),
                            colorBlendMode: BlendMode.darken,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary,
                                      theme.colorScheme.primary
                                          .withOpacity(0.6),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(Icons.inventory_2_outlined, size: 64),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: ValueListenableBuilder<int>(
                        valueListenable: _pageNotifier,
                        builder: (context, page, _) {
                          return PageIndicator(
                            length: product.images.length,
                            currentIndex: page,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${product.seller} • ${lang.t('time_left')}: ${_formatDuration(_remaining, lang)}',
                          style: theme.textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        ValueListenableBuilder<double>(
                          valueListenable: _bidNotifier,
                          builder: (context, bid, _) {
                            return AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              transitionBuilder: (child, animation) {
                                return ScaleTransition(scale: animation, child: child);
                              },
                              child: Text(
                                '${lang.t('current_bid')}: ${bid.toStringAsFixed(2)}',
                                key: ValueKey(bid),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang.t('description'),
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(
                          'Minimalist concept crafted with liquid glass gradients and matte metals. Auction ends soon.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Icon(Icons.tag, color: theme.colorScheme.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Wrap(
                                spacing: 8,
                                children: product.tags
                                    .map((tag) => Chip(label: Text(tag)))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassContainer(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lang.t('place_bid'),
                            style: theme.textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                lang.t('pull_to_refresh'),
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _openBidSheet,
                              child: Text(lang.t('bid_now')),
                            ),
                          ],
                        ),
                      ],
                    ),
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
