import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../data/models.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/offers/offers_screen.dart';
import '../../screens/onboarding/onboarding_screen.dart';
import '../../screens/product/product_details_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/wanted/wanted_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onboarding:
        return _build(settings, const OnboardingScreen());
      case AppRoutes.auth:
        return _build(settings, const AuthScreen());
      case AppRoutes.home:
        return _build(settings, const HomeScreen());
      case AppRoutes.offers:
        return _build(settings, const OffersScreen());
      case AppRoutes.wanted:
        return _build(settings, const WantedScreen());
      case AppRoutes.profile:
        return _build(settings, const ProfileScreen());
      case AppRoutes.productDetails:
        final product = settings.arguments as Product?;
        return _build(settings, ProductDetailsScreen(product: product));
      default:
        return _build(settings, const HomeScreen());
    }
  }

  static PageRouteBuilder<dynamic> _build(
    RouteSettings settings,
    Widget child,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation.drive(
            CurveTween(curve: Curves.easeInOut),
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.98, end: 1).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }
}

class RouteTracker extends NavigatorObserver {
  RouteTracker(this.onRouteChanged);

  final void Function(String routeName) onRouteChanged;

  void _notify(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name != null && name.isNotEmpty) {
      onRouteChanged(name);
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _notify(route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _notify(previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _notify(newRoute);
  }
}
