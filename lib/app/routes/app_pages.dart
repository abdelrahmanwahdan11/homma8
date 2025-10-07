import 'package:get/get.dart';

import '../modules/alerts/bindings/alerts_binding.dart';
import '../modules/alerts/views/alerts_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/bids/bindings/bids_binding.dart';
import '../modules/bids/views/bids_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/item_detail/bindings/item_detail_binding.dart';
import '../modules/item_detail/views/item_detail_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/sell_buy/bindings/sell_buy_binding.dart';
import '../modules/sell_buy/views/sell_buy_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash,
      page: SplashView.new,
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.onboarding,
      page: OnboardingView.new,
      binding: OnboardingBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: Routes.auth,
      page: AuthView.new,
      binding: AuthBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: Routes.home,
      page: HomeView.new,
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: '${Routes.item}/:id',
      page: ItemDetailView.new,
      binding: ItemDetailBinding(),
      transition: Transition.cupertino,
    ),
    GetPage(
      name: Routes.bids,
      page: BidsView.new,
      binding: BidsBinding(),
    ),
    GetPage(
      name: Routes.favorites,
      page: FavoritesView.new,
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: Routes.alerts,
      page: AlertsView.new,
      binding: AlertsBinding(),
    ),
    GetPage(
      name: Routes.sellBuy,
      page: SellBuyView.new,
      binding: SellBuyBinding(),
    ),
    GetPage(
      name: Routes.settings,
      page: SettingsView.new,
      binding: SettingsBinding(),
    ),
  ];
}
