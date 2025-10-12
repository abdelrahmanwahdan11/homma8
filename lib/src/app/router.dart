import 'package:flutter/material.dart';

import '../core/app_state.dart';
import '../features/auction/presentation/swipe_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/signup_page.dart';
import '../features/auth/presentation/verify_page.dart';
import '../features/bids/presentation/bids_page.dart';
import '../features/catalog/presentation/catalog_page.dart';
import '../features/details/presentation/item_details_page.dart';
import '../features/favorites/presentation/favorites_page.dart';
import '../features/listings/presentation/create_listing_page.dart';
import '../features/onboarding/presentation/onboarding_page.dart';
import '../features/orders/presentation/create_intent_page.dart';
import '../features/orders/presentation/orders_page.dart';
import '../features/search/presentation/search_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/splash/presentation/splash_page.dart';

class AppRouter {
  AppRouter(this.state);

  final AppState state;

  RouterConfig<Object> get config => RouterConfig<Object>(
        routerDelegate: AppRouterDelegate(state),
        routeInformationParser: const AppRouteParser(),
        routeInformationProvider: PlatformRouteInformationProvider(initialRouteInformation: const RouteInformation(location: '/')),
      );
}

class AppRouteParser extends RouteInformationParser<_RoutePath> {
  const AppRouteParser();

  @override
  Future<_RoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.location ?? '/';
    return _RoutePath(location);
  }

  @override
  RouteInformation? restoreRouteInformation(_RoutePath configuration) {
    return RouteInformation(location: configuration.location);
  }
}

class AppRouterDelegate extends RouterDelegate<_RoutePath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<_RoutePath> {
  AppRouterDelegate(this.state) {
    _stack.add(const _RoutePath('/'));
    state.addListener(_handleStateChanged);
  }

  final AppState state;
  final List<_RoutePath> _stack = <_RoutePath>[];
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void dispose() {
    state.removeListener(_handleStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        for (final entry in _stack)
          MaterialPage<dynamic>(
            key: ValueKey<String>(entry.location),
            child: _buildPage(entry, context),
          ),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_stack.length > 1) {
          _stack.removeLast();
          notifyListeners();
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(_RoutePath configuration) async {
    if (_stack.isEmpty || _stack.last.location != configuration.location) {
      _stack
        ..clear()
        ..add(configuration);
      notifyListeners();
    }
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  static AppRouterDelegate of(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    assert(delegate is AppRouterDelegate, 'AppRouterDelegate not found in context');
    return delegate as AppRouterDelegate;
  }

  void go(String location) {
    _stack
      ..clear()
      ..add(_RoutePath(location));
    notifyListeners();
  }

  void push(String location) {
    _stack.add(_RoutePath(location));
    notifyListeners();
  }

  Widget _buildPage(_RoutePath path, BuildContext context) {
    final uri = Uri.parse(path.location);
    switch (uri.path) {
      case '/':
        return const SplashPage();
      case '/onboarding':
        return const OnboardingPage();
      case '/auth/login':
        return const LoginPage();
      case '/auth/signup':
        return const SignupPage();
      case '/auth/verify':
        return const VerifyPage();
      case '/swipe':
        return const SwipePage();
      case '/catalog':
        return const CatalogPage();
      case '/search':
        return const SearchPage();
      case '/listings/create':
        return const CreateListingPage();
      case '/orders/intent':
        return const CreateIntentPage();
      case '/favorites':
        return const FavoritesPage();
      case '/bids':
        return const BidsPage();
      case '/orders':
        return const OrdersPage();
      case '/settings':
        return const SettingsPage();
      default:
        if (uri.pathSegments.length == 2 && uri.pathSegments.first == 'item') {
          final id = uri.pathSegments[1];
          return ItemDetailsPage(itemId: id);
        }
        return Scaffold(body: Center(child: Text('Unknown route ${path.location}')));
    }
  }

  void _handleStateChanged() {
    if (_stack.isEmpty) {
      return;
    }
    final current = _stack.last.location;
    if (current == '/' || current == '/onboarding' || current.startsWith('/auth')) {
      if (!state.onboardingSeen) {
        go('/onboarding');
      } else if (!state.isLoggedIn) {
        go('/auth/login');
      } else {
        go('/swipe');
      }
    }
  }
}

class _RoutePath {
  const _RoutePath(this.location);

  final String location;
}
