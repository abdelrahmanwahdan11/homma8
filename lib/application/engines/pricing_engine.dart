import '../../domain/entities.dart';

class PricingEngine {
  PricingEngine({
    this.base = 0,
    this.stepWatchers = 2,
    this.watchUnit = 10,
    this.stepDemand = 1,
    this.demandUnit = 8,
    this.maxDiscount = 50,
  });

  final double base;
  final double stepWatchers;
  final int watchUnit;
  final double stepDemand;
  final int demandUnit;
  final double maxDiscount;

  double compute(Product product) {
    final watcherBonus = stepWatchers * (product.watchers ~/ watchUnit);
    final demandBonus = stepDemand * (product.demandCount ~/ demandUnit);
    final discount = (base + watcherBonus + demandBonus).clamp(0, maxDiscount);
    return discount;
  }
}
