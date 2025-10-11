import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/core/app_prefs.dart';
import 'src/core/app_scope.dart';
import 'src/core/app_state.dart';
import 'src/core/theme/app_theme.dart';
import 'src/features/auth/forgot_page.dart';
import 'src/features/auth/guest_page.dart';
import 'src/features/auth/login_page.dart';
import 'src/features/auth/reset_page.dart';
import 'src/features/auth/signup_page.dart';
import 'src/features/details/auction_details_page.dart';
import 'src/features/details/request_details_page.dart';
import 'src/features/home/home_root.dart';
import 'src/features/settings/settings_page.dart';
import 'src/features/splash/splash_soon_page.dart';
import 'src/models/listing.dart';
import 'src/models/request_item.dart';
import 'src/router/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final prefs = await AppPrefs.load();
  final state = AppState(prefs);
  runApp(AppScope(state: state, child: MazzzadApp(state: state)));
}

class MazzzadApp extends StatelessWidget {
  const MazzzadApp({super.key, required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF4F46E5);
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          theme: AppTheme.light(seed),
          darkTheme: AppTheme.dark(seed),
          themeMode: state.themeMode,
          locale: state.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          initialRoute: '/',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/':
                return AppRouter.animated(
                  settings,
                  (context) {
                    if (!state.splashShown) {
                      return SplashSoonPage(
                        onDone: () {
                          state.markSplashShown();
                          if (state.isLoggedIn) {
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            Navigator.pushReplacementNamed(context, '/login');
                          }
                        },
                      );
                    }
                    return state.isLoggedIn ? const HomeRoot() : const LoginPage();
                  },
                );
              case '/login':
                return AppRouter.animated(settings, (context) => const LoginPage());
              case '/signup':
                return AppRouter.animated(settings, (context) => const SignupPage());
              case '/forgot':
                return AppRouter.animated(settings, (context) => const ForgotPage());
              case '/reset':
                return AppRouter.animated(settings, (context) => const ResetPage());
              case '/guest':
                return AppRouter.animated(settings, (context) => const GuestPage());
              case '/home':
                return AppRouter.animated(settings, (context) => const HomeRoot());
              case '/settings':
                return AppRouter.animated(settings, (context) => const SettingsPage());
              case '/auction':
                final Listing listing = settings.arguments as Listing;
                return AppRouter.animated(
                  settings,
                  (context) => AuctionDetailsPage(listing: listing),
                );
              case '/request':
                final RequestItem request = settings.arguments as RequestItem;
                return AppRouter.animated(
                  settings,
                  (context) => RequestDetailsPage(request: request),
                );
            }
            return AppRouter.animated(
              settings,
              (context) => Scaffold(
                body: Center(child: Text('Unknown route: ${settings.name}')),
              ),
            );
          },
        );
      },
    );
  }
}
