import 'package:shared_preferences/shared_preferences.dart';

class AppPrefs {
  static const _kTheme = 'theme_mode';
  static const _kLocale = 'locale_code';
  static const _kLogged = 'logged_in';
  static const _kSplashShown = 'splash_shown';

  AppPrefs(this._prefs);

  final SharedPreferences _prefs;

  static Future<AppPrefs> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPrefs(prefs);
  }

  String get theme => _prefs.getString(_kTheme) ?? 'system';
  set theme(String value) => _prefs.setString(_kTheme, value);

  String get locale => _prefs.getString(_kLocale) ?? 'system';
  set locale(String value) => _prefs.setString(_kLocale, value);

  bool get loggedIn => _prefs.getBool(_kLogged) ?? false;
  set loggedIn(bool value) => _prefs.setBool(_kLogged, value);

  bool get splashShown => _prefs.getBool(_kSplashShown) ?? false;
  set splashShown(bool value) => _prefs.setBool(_kSplashShown, value);
}
