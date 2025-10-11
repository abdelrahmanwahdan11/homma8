import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../application/engines/suggestion_engine.dart';
import '../application/stores.dart';
import '../application/usecases/create_sell_listing.dart';
import '../application/usecases/create_wanted_item.dart';
import '../application/usecases/fetch_products_page.dart';
import '../application/usecases/place_bid.dart';
import '../application/usecases/recompute_discounts.dart';
import '../application/usecases/register_price_alert.dart';
import '../application/usecases/skip_left.dart';
import '../application/usecases/swipe_right_add_demand.dart';
import '../domain/repositories.dart';
import 'router.dart';
import 'strings.dart';
import 'theme.dart';

class SwipeBidApp extends StatelessWidget {
  const SwipeBidApp({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    return AnimatedBuilder(
      animation: scope.appStore,
      builder: (context, _) {
        final locale = scope.appStore.value.locale;
        final themeMode = scope.appStore.value.themeMode;
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppStrings.fromLocale(locale).t('app_title'),
          theme: GreyDegreeTheme.buildLightTheme(),
          darkTheme: GreyDegreeTheme.buildDarkTheme(),
          themeMode: themeMode,
          locale: locale,
          supportedLocales: AppStrings.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          onGenerateRoute: (settings) => AppRouter.onGenerateRoute(settings, scope),
          builder: (context, child) {
            final strings = AppStrings.of(context);
            final baseTheme = Theme.of(context);
            final textTheme = strings.isArabic
                ? GoogleFonts.cairoTextTheme(baseTheme.textTheme)
                : baseTheme.textTheme;
            return Directionality(
              textDirection:
                  strings.isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: Theme(
                data: baseTheme.copyWith(textTheme: textTheme),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
          initialRoute: RouteNames.splash,
        );
      },
    );
  }
}

class AppScope extends InheritedWidget {
  const AppScope({
    required super.child,
    required this.appStore,
    required this.catalogStore,
    required this.auctionStore,
    required this.userStore,
    required this.productRepository,
    required this.userRepository,
    required this.sellRepository,
    required this.fetchProducts,
    required this.swipeRight,
    required this.skipLeft,
    required this.placeBid,
    required this.createSellListing,
    required this.createWantedItem,
    required this.registerPriceAlert,
    required this.recomputeDiscounts,
    required this.suggestionEngine,
    super.key,
  });

  final AppStore appStore;
  final CatalogStore catalogStore;
  final AuctionStore auctionStore;
  final UserStore userStore;
  final ProductRepository productRepository;
  final UserRepository userRepository;
  final SellRepository sellRepository;
  final FetchProductsPage fetchProducts;
  final SwipeRightAddDemandAndWatch swipeRight;
  final SkipLeft skipLeft;
  final PlaceBid placeBid;
  final CreateSellListing createSellListing;
  final CreateWantedItem createWantedItem;
  final RegisterPriceAlert registerPriceAlert;
  final RecomputeDiscountsForDemand recomputeDiscounts;
  final SuggestionEngine suggestionEngine;

  static AppScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(covariant AppScope oldWidget) => false;
}
