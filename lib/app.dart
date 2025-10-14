import 'package:flutter/material.dart';

import 'core/app_state/app_state.dart';
import 'core/localization/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'features/auction/auction_details_page.dart';
import 'features/auth/auth_page.dart';
import 'features/favorites/favorites_page.dart';
import 'features/help/help_page.dart';
import 'features/home/home_page.dart';
import 'features/matches/matches_page.dart';
import 'features/notifications/notifications_page.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/profile/profile_page.dart';
import 'features/profile/prefs_page.dart';
import 'features/create/create_page.dart';
import 'features/explore/explore_page.dart';
import 'features/wanted/wanted_board_page.dart';
import 'features/wanted/wanted_details_page.dart';

class BazaarApp extends StatefulWidget {
  const BazaarApp({required this.appState, super.key});

  final AppState appState;

  @override
  State<BazaarApp> createState() => _BazaarAppState();
}

class _BazaarAppState extends State<BazaarApp> {
  late final AppRouterDelegate _routerDelegate;
  late final AppRouteParser _routeParser;

  @override
  void initState() {
    super.initState();
    _routerDelegate = AppRouterDelegate(widget.appState);
    _routeParser = AppRouteParser();
  }

  @override
  Widget build(BuildContext context) {
    final appState = widget.appState;
    final locale = appState.localeOverride;
    final platformBrightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
    return AnimatedBuilder(
      animation: appState,
      builder: (context, _) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => context.l10n.appTitle,
          theme: AppTheme.lightTheme(platformBrightness),
          darkTheme: AppTheme.darkTheme(),
          themeMode: appState.themeMode,
          routerDelegate: _routerDelegate,
          routeInformationParser: _routeParser,
          backButtonDispatcher: RootBackButtonDispatcher(),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: localizationsDelegates,
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            if (deviceLocale == null) {
              return const Locale('en');
            }
            for (final localeOption in supportedLocales) {
              if (localeOption.languageCode == deviceLocale.languageCode) {
                return localeOption;
              }
            }
            return const Locale('en');
          },
          locale: locale,
        );
      },
    );
  }
}

class AppRouteConfig {
  const AppRouteConfig(this.name, {this.arguments = const <String, dynamic>{}});

  final String name;
  final Map<String, dynamic> arguments;

  AppRouteConfig copyWith({String? name, Map<String, dynamic>? arguments}) {
    return AppRouteConfig(name ?? this.name, arguments: arguments ?? this.arguments);
  }
}

class AppRouteParser extends RouteInformationParser<AppRouteConfig> {
  @override
  Future<AppRouteConfig> parseRouteInformation(RouteInformation routeInformation) async {
    final location = routeInformation.location ?? '/';
    final uri = Uri.parse(location);
    if (uri.pathSegments.isEmpty) {
      return const AppRouteConfig('root');
    }
    if (uri.pathSegments.length == 2) {
      if (uri.pathSegments.first == 'auction') {
        return AppRouteConfig('auction', arguments: {'id': uri.pathSegments[1]});
      }
      if (uri.pathSegments.first == 'wanted') {
        return AppRouteConfig('wanted', arguments: {'id': uri.pathSegments[1]});
      }
    }
    switch (uri.pathSegments.first) {
      case 'home':
        return const AppRouteConfig('home');
      case 'explore':
        return const AppRouteConfig('explore');
      case 'create':
        return const AppRouteConfig('create');
      case 'matches':
        return const AppRouteConfig('matches');
      case 'favorites':
        return const AppRouteConfig('favorites');
      case 'profile':
        return const AppRouteConfig('profile');
      case 'profile-settings':
        return const AppRouteConfig('profile-settings');
      case 'notifications':
        return const AppRouteConfig('notifications');
      case 'help':
        return const AppRouteConfig('help');
      case 'wanted-board':
        return const AppRouteConfig('wanted-board');
      default:
        return const AppRouteConfig('root');
    }
  }

  @override
  RouteInformation? restoreRouteInformation(AppRouteConfig configuration) {
    switch (configuration.name) {
      case 'auction':
        return RouteInformation(location: '/auction/${configuration.arguments['id']}');
      case 'wanted':
        return RouteInformation(location: '/wanted/${configuration.arguments['id']}');
      case 'explore':
      case 'create':
      case 'matches':
      case 'favorites':
      case 'profile':
      case 'notifications':
      case 'help':
      case 'wanted-board':
      case 'profile-settings':
        return RouteInformation(location: '/${configuration.name}');
      default:
        return const RouteInformation(location: '/');
    }
  }
}

class AppRouterDelegate extends RouterDelegate<AppRouteConfig>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRouteConfig> {
  AppRouterDelegate(this.appState) {
    appState.addListener(_handleAppStateChanged);
  }

  final AppState appState;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final List<AppRouteConfig> _stack = <AppRouteConfig>[];

  void _handleAppStateChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    appState.removeListener(_handleAppStateChanged);
    super.dispose();
  }

  @override
  AppRouteConfig? get currentConfiguration => _stack.isEmpty ? null : _stack.last;

  @override
  Future<void> setNewRoutePath(AppRouteConfig configuration) async {
    switch (configuration.name) {
      case 'home':
        appState.bottomNavIndex.value = 0;
        _stack.clear();
        break;
      case 'explore':
        appState.bottomNavIndex.value = 1;
        _stack.clear();
        break;
      case 'create':
        appState.bottomNavIndex.value = 2;
        _stack.clear();
        break;
      case 'matches':
        appState.bottomNavIndex.value = 3;
        _stack.clear();
        break;
      case 'favorites':
        appState.bottomNavIndex.value = 4;
        _stack.clear();
        break;
      case 'profile':
        appState.bottomNavIndex.value = 5;
        _stack.clear();
        break;
      default:
        _stack
          ..clear()
          ..add(configuration);
    }
  }

  void push(AppRouteConfig config) {
    _stack.add(config);
    notifyListeners();
  }

  void pop() {
    if (_stack.isNotEmpty) {
      _stack.removeLast();
      notifyListeners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = <Page<dynamic>>[];
    if (!appState.onboardingDone) {
      pages.add(MaterialPage<dynamic>(
        name: 'onboarding',
        key: const ValueKey('onboarding'),
        child: OnboardingPage(onDone: appState.completeOnboarding),
      ));
    } else if (!appState.isGuest) {
      pages.add(MaterialPage<dynamic>(
        name: 'auth',
        key: const ValueKey('auth'),
        child: AuthPage(onGuest: appState.signInAsGuest),
      ));
    } else {
      pages.add(MaterialPage<dynamic>(
        name: 'shell',
        key: const ValueKey('shell'),
        child: ShellHome(routerDelegate: this, appState: appState),
      ));
      for (final config in _stack) {
        switch (config.name) {
          case 'auction':
            pages.add(MaterialPage<dynamic>(
              name: 'auction-${config.arguments['id']}',
              child: AuctionDetailsPage(auctionId: config.arguments['id'] as String),
            ));
            break;
          case 'wanted':
            pages.add(MaterialPage<dynamic>(
              name: 'wanted-${config.arguments['id']}',
              child: WantedDetailsPage(wantedId: config.arguments['id'] as String),
            ));
            break;
          case 'profile-settings':
            pages.add(MaterialPage<dynamic>(
              name: 'profile-settings',
              child: const PrefsPage(),
            ));
            break;
          case 'notifications':
            pages.add(const MaterialPage<dynamic>(
              name: 'notifications',
              child: NotificationsPage(),
            ));
            break;
          case 'help':
            pages.add(const MaterialPage<dynamic>(
              name: 'help',
              child: HelpPage(),
            ));
            break;
          case 'wanted-board':
            pages.add(MaterialPage<dynamic>(
              name: 'wanted-board',
              child: WantedBoardPage(onOpenDetails: (id) => push(AppRouteConfig('wanted', arguments: {'id': id}))),
            ));
            break;
        }
      }
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        if (_stack.isNotEmpty) {
          _stack.removeLast();
        }
        notifyListeners();
        return true;
      },
    );
  }

  @override
  Future<bool> popRoute() {
    if (_stack.isNotEmpty) {
      _stack.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }
}

class ShellHome extends StatefulWidget {
  const ShellHome({required this.routerDelegate, required this.appState, super.key});

  final AppRouterDelegate routerDelegate;
  final AppState appState;

  @override
  State<ShellHome> createState() => _ShellHomeState();
}

class _ShellHomeState extends State<ShellHome> with TickerProviderStateMixin {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.appState.bottomNavIndex.value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomePage(),
      const ExplorePage(),
      const CreatePage(),
      const MatchesPage(),
      const FavoritesPage(),
      ProfilePage(onOpenPrefs: () => widget.routerDelegate.push(const AppRouteConfig('profile-settings'))),
    ];

    return Scaffold(
      extendBody: true,
      body: ValueListenableBuilder<int>(
        valueListenable: widget.appState.bottomNavIndex,
        builder: (context, index, _) {
          return PageView.builder(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tabs.length,
            itemBuilder: (context, pageIndex) {
              final child = tabs[pageIndex];
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: child,
              );
            },
          );
        },
      ),
      bottomNavigationBar: _BottomNav(appState: widget.appState, pageController: _pageController),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.appState, required this.pageController});

  final AppState appState;
  final PageController pageController;

  @override
  Widget build(BuildContext context) {
    final labels = context.l10n;
    final items = [
      BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), label: labels['home']),
      BottomNavigationBarItem(icon: const Icon(Icons.explore_outlined), label: labels['explore']),
      BottomNavigationBarItem(icon: const Icon(Icons.add_box_outlined), label: labels['create']),
      BottomNavigationBarItem(icon: const Icon(Icons.auto_graph_outlined), label: labels['matches']),
      BottomNavigationBarItem(icon: const Icon(Icons.bookmark_border), label: labels['favorites']),
      BottomNavigationBarItem(icon: const Icon(Icons.person_outline), label: labels['profile']),
    ];
    return ValueListenableBuilder<int>(
      valueListenable: appState.bottomNavIndex,
      builder: (context, currentIndex, _) {
        return BottomNavigationBar(
          currentIndex: currentIndex,
          items: items,
          onTap: (index) {
            appState.bottomNavIndex.value = index;
            pageController.jumpToPage(index);
          },
        );
      },
    );
  }
}
