import '../../application/engines/pricing_engine.dart';
import '../stores.dart';

class RecomputeDiscountsForDemand {
  RecomputeDiscountsForDemand(this.pricingEngine, this.catalogStore);

  final PricingEngine pricingEngine;
  final CatalogStore catalogStore;

  void call() {
    final updated = catalogStore.value.products.map((product) {
      final discount = pricingEngine.compute(product);
      return product.copyWith(
        discountPercent: discount,
        currentPrice: product.basePrice * (1 - discount / 100),
      );
    }).toList();
    catalogStore.replaceProducts(updated);
  }
}
