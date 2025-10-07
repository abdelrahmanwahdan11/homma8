import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/favorites_controller.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key, this.embed = false});

  final bool embed;

  @override
  Widget build(BuildContext context) {
    final grid = Obx(
      () {
        final favorites = controller.favorites;
        if (favorites.isEmpty) {
          return Center(child: Text('favorites_empty'.tr));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1,
          ),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return GlassCard(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.title, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('${item.currency} ${item.currentBid.toStringAsFixed(0)}'),
                ],
              ),
            );
          },
        );
      },
    );
    if (embed) return grid;
    return Scaffold(
      appBar: AppBar(title: Text('nav_favorites'.tr)),
      body: grid,
    );
  }
}
