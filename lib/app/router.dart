import 'package:flutter/material.dart';

import '../features/howto/howto_page.dart';
import '../features/home/home_page.dart';
import '../features/onboarding/onboarding_page.dart';
import '../features/details/product_details_page.dart';
import '../features/sell/sell_page.dart';
import 'app.dart';

class RouteNames {
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const home = '/home';
  static const productDetails = '/product';
  static const sellForm = '/sell/new';
  static const wantedForm = '/wanted/new';
  static const howTo = '/howto';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings, AppScope scope) {
    Widget builder;
    switch (settings.name) {
      case RouteNames.splash:
        builder = SplashPage(scope: scope);
        break;
      case RouteNames.onboarding:
        builder = const OnboardingPage();
        break;
      case RouteNames.home:
        builder = const HomePage();
        break;
      case RouteNames.productDetails:
        final args = settings.arguments as ProductDetailsArgs;
        builder = ProductDetailsPage(args: args);
        break;
      case RouteNames.sellForm:
        builder = SellPage(initialTab: SellTab.sell);
        break;
      case RouteNames.wantedForm:
        builder = SellPage(initialTab: SellTab.wanted);
        break;
      case RouteNames.howTo:
        builder = const HowToPage();
        break;
      default:
        builder = const Scaffold(body: Center(child: Text('Not found')));
    }
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: builder,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}

class SplashPage extends StatefulWidget {
  const SplashPage({required this.scope, super.key});

  final AppScope scope;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      final firstRun = widget.scope.appStore.value.isFirstRun;
      final route = firstRun ? RouteNames.onboarding : RouteNames.home;
      Navigator.of(context).pushReplacementNamed(route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
