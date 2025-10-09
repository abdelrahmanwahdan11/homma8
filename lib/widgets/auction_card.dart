import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../core/localization/language_manager.dart';
import '../data/models.dart';
import 'glass_container.dart';

class AuctionCard extends StatelessWidget {
  const AuctionCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);
    final app = AppState.of(context);
    final isFavorite = app.isFavorite(product.id);

    return Hero(
      tag: 'product_${product.id}',
      child: GlassContainer(
        padding: EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: Image.network(
                            product.images.first,
                            key: ValueKey(product.images.first),
                            fit: BoxFit.cover,
                            color: Colors.black.withOpacity(0.05),
                            colorBlendMode: BlendMode.darken,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: theme.colorScheme.surface,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.colorScheme.primary.withOpacity(0.6),
                                      theme.colorScheme.secondary.withOpacity(0.4),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.inventory_2_outlined,
                                    size: 48,
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      left: 12,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: product.discount),
                        duration: const Duration(milliseconds: 400),
                        builder: (context, value, child) {
                          return GlassContainer(
                            borderRadius: 14,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            child: Text(
                              '-${value.toStringAsFixed(0)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey(isFavorite),
                            color: isFavorite
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        onPressed: () => AppState.of(context)
                            .toggleFavorite(product.id),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${lang.t('current_bid')}: ${product.priceCurrent.toStringAsFixed(0)} \$',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _CountdownChip(duration: product.timeLeft),
                    GlassContainer(
                      borderRadius: 16,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: Text(
                        lang.t('ai_chips'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountdownChip extends StatefulWidget {
  const _CountdownChip({required this.duration});

  final Duration duration;

  @override
  State<_CountdownChip> createState() => _CountdownChipState();
}

class _CountdownChipState extends State<_CountdownChip>
    with SingleTickerProviderStateMixin {
  late Duration _remaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remaining = widget.duration;
    _start();
  }

  void _start() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _remaining = _remaining - const Duration(seconds: 1);
        if (_remaining.isNegative) {
          _remaining = Duration.zero;
          timer.cancel();
        }
      });
    });
  }

  @override
  void didUpdateWidget(covariant _CountdownChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.duration != oldWidget.duration) {
      _remaining = widget.duration;
      _start();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    final theme = Theme.of(context);

    String formatted() {
      if (_remaining.inSeconds <= 0) {
        return lang.t('seconds');
      }
      if (_remaining.inHours >= 24) {
        final days = max(1, _remaining.inDays);
        return '$days${lang.t('days')}';
      }
      if (_remaining.inHours > 0) {
        return '${_remaining.inHours}${lang.t('hours')}';
      }
      if (_remaining.inMinutes > 0) {
        return '${_remaining.inMinutes}${lang.t('minutes')}';
      }
      return '${_remaining.inSeconds}${lang.t('seconds')}';
    }

    return GlassContainer(
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.timer_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 6),
          Text(
            formatted(),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
