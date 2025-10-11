import 'package:flutter/material.dart';

import 'app/app.dart';
import 'application/engines/pricing_engine.dart';
import 'application/engines/suggestion_engine.dart';
import 'application/stores.dart';
import 'application/usecases/create_sell_listing.dart';
import 'application/usecases/create_wanted_item.dart';
import 'application/usecases/fetch_products_page.dart';
import 'application/usecases/place_bid.dart';
import 'application/usecases/recompute_discounts.dart';
import 'application/usecases/register_price_alert.dart';
import 'application/usecases/skip_left.dart';
import 'application/usecases/swipe_right_add_demand.dart';
import 'data/mock/mock_sources.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final appStore = AppStore();
  final catalogStore = CatalogStore();
  final auctionStore = AuctionStore();
  final userStore = UserStore();

  final pricingEngine = PricingEngine();
  final suggestionEngine = SuggestionEngine();

  final productRepository = MockProductRepository(pricingEngine);
  final userRepository = MockUserRepository(productRepository);
  final sellRepository = MockSellRepository(userRepository);

  final fetchProducts = FetchProductsPage(productRepository, catalogStore);
  final swipeRight = SwipeRightAddDemandAndWatch(
    catalogStore: catalogStore,
    userStore: userStore,
    userRepository: userRepository,
    pricingEngine: pricingEngine,
    productRepository: productRepository,
  );
  final skipLeft = SkipLeft(catalogStore);
  final placeBid = PlaceBid(repository: productRepository, auctionStore: auctionStore);
  final createSellListing = CreateSellListing(sellRepository);
  final createWantedItem = CreateWantedItem(repository: sellRepository, userStore: userStore);
  final registerAlert = RegisterPriceAlert(userStore);
  final recomputeDiscounts = RecomputeDiscountsForDemand(pricingEngine, catalogStore);

  runApp(
    AppScope(
      appStore: appStore,
      catalogStore: catalogStore,
      auctionStore: auctionStore,
      userStore: userStore,
      productRepository: productRepository,
      userRepository: userRepository,
      sellRepository: sellRepository,
      fetchProducts: fetchProducts,
      swipeRight: swipeRight,
      skipLeft: skipLeft,
      placeBid: placeBid,
      createSellListing: createSellListing,
      createWantedItem: createWantedItem,
      registerPriceAlert: registerAlert,
      recomputeDiscounts: recomputeDiscounts,
      suggestionEngine: suggestionEngine,
      child: const SwipeBidApp(),
    ),
  );
}
