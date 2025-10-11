import '../../application/engines/pricing_engine.dart';
import '../../core/result.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import '../../data/mock/mock_sources.dart';
import '../stores.dart';

class SwipeRightAddDemandAndWatch {
  SwipeRightAddDemandAndWatch({
    required this.catalogStore,
    required this.userStore,
    required this.userRepository,
    required this.pricingEngine,
    this.productRepository,
  });

  final CatalogStore catalogStore;
  final UserStore userStore;
  final UserRepository userRepository;
  final PricingEngine pricingEngine;
  final ProductRepository? productRepository;

  Future<void> call(Product product) async {
    Product priced;
    if (productRepository is MockProductRepository) {
      priced = (productRepository as MockProductRepository).updateDemand(product.id);
    } else {
      final updated = product.copyWith(
        demandCount: product.demandCount + 1,
        watchers: product.watchers + 1,
      );
      final discount = pricingEngine.compute(updated);
      priced = updated.copyWith(
        discountPercent: discount,
        currentPrice: updated.basePrice * (1 - discount / 100),
      );
    }
    catalogStore.updateProduct(priced);
    userStore.addToWatchlist(priced);
    final result = await userRepository.addToWatchlist(product.id);
    if (result is Failure<void>) {
      // ignore for demo; in production show snackbar
    }
    catalogStore.setSwipeIndex(catalogStore.value.swipeIndex + 1);
  }
}
