import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/core/theme/app_theme.dart';
import 'app/core/utils/app_translation.dart';
import 'app/data/services/mock_data_service.dart';
import 'app/data/services/settings_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final settings = SettingsService(prefs);
  await settings.init();
  Get.put(settings, permanent: true);
  await Get.putAsync(() => MockDataService().init());
  runApp(const AuctionApp());
}

class AuctionApp extends StatelessWidget {
  const AuctionApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Get.find<SettingsService>();
    return Obx(
      () => GetMaterialApp(
        title: 'VidGen Auctions',
        debugShowCheckedModeBanner: false,
        translations: AppTranslation(),
        locale: settings.locale.value,
        fallbackLocale: const Locale('en'),
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        themeMode: settings.themeMode.value,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
      ),
    );
  }
}
