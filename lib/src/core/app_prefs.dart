import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_prefs.dart';

class AppPrefs {
  AppPrefs(this._prefs);

  static const String _kAuthSession = 'auth.session';
  static const String _kOnboardingSeen = 'onboarding.seen';
  static const String _kThemeMode = 'settings.theme_mode';
  static const String _kLocale = 'settings.locale';
  static const String _kReferralCode = 'referral.my_code';
  static const String _kReferredBy = 'referral.referred_by';
  static const String _kReferralCount = 'referral.count';
  static const String _kUserPrefs = 'user.prefs';
  static const String _kItemsBlob = 'data.items';
  static const String _kListingsBlob = 'data.listings';
  static const String _kIntentsBlob = 'data.intents';
  static const String _kBidsBlob = 'data.bids';
  static const String _kFavoritesBlob = 'data.favorites';
  static const String _kNotificationsBlob = 'data.notifications';
  static const String _kIndexBlob = 'search.index';

  final SharedPreferences _prefs;

  static Future<AppPrefs> load() async {
    final prefs = await SharedPreferences.getInstance();
    return AppPrefs(prefs);
  }

  bool get hasSession => _prefs.getBool(_kAuthSession) ?? false;
  set hasSession(bool value) => _prefs.setBool(_kAuthSession, value);

  bool get onboardingSeen => _prefs.getBool(_kOnboardingSeen) ?? false;
  set onboardingSeen(bool value) => _prefs.setBool(_kOnboardingSeen, value);

  String get theme => _prefs.getString(_kThemeMode) ?? 'dark';
  set theme(String value) => _prefs.setString(_kThemeMode, value);

  String get locale => _prefs.getString(_kLocale) ?? 'ar';
  set locale(String value) => _prefs.setString(_kLocale, value);

  String? get referralCode => _prefs.getString(_kReferralCode);
  set referralCode(String? value) {
    if (value == null) {
      _prefs.remove(_kReferralCode);
    } else {
      _prefs.setString(_kReferralCode, value);
    }
  }

  String? get referredBy => _prefs.getString(_kReferredBy);
  set referredBy(String? value) {
    if (value == null) {
      _prefs.remove(_kReferredBy);
    } else {
      _prefs.setString(_kReferredBy, value);
    }
  }

  int get referralCount => _prefs.getInt(_kReferralCount) ?? 0;
  set referralCount(int value) => _prefs.setInt(_kReferralCount, value);

  UserPrefs loadUserPrefs() {
    final raw = _prefs.getString(_kUserPrefs);
    if (raw == null || raw.isEmpty) {
      return const UserPrefs();
    }
    return UserPrefs.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  void saveUserPrefs(UserPrefs prefs) {
    _prefs.setString(_kUserPrefs, jsonEncode(prefs.toJson()));
  }

  String? loadBlob(String key) => _prefs.getString(key);
  void saveBlob(String key, String value) => _prefs.setString(key, value);
  void clearBlob(String key) => _prefs.remove(key);

  String? get itemsBlob => loadBlob(_kItemsBlob);
  set itemsBlob(String? value) {
    if (value == null) {
      clearBlob(_kItemsBlob);
    } else {
      saveBlob(_kItemsBlob, value);
    }
  }

  String? get listingsBlob => loadBlob(_kListingsBlob);
  set listingsBlob(String? value) {
    if (value == null) {
      clearBlob(_kListingsBlob);
    } else {
      saveBlob(_kListingsBlob, value);
    }
  }

  String? get intentsBlob => loadBlob(_kIntentsBlob);
  set intentsBlob(String? value) {
    if (value == null) {
      clearBlob(_kIntentsBlob);
    } else {
      saveBlob(_kIntentsBlob, value);
    }
  }

  String? get bidsBlob => loadBlob(_kBidsBlob);
  set bidsBlob(String? value) {
    if (value == null) {
      clearBlob(_kBidsBlob);
    } else {
      saveBlob(_kBidsBlob, value);
    }
  }

  String? get favoritesBlob => loadBlob(_kFavoritesBlob);
  set favoritesBlob(String? value) {
    if (value == null) {
      clearBlob(_kFavoritesBlob);
    } else {
      saveBlob(_kFavoritesBlob, value);
    }
  }

  String? get notificationsBlob => loadBlob(_kNotificationsBlob);
  set notificationsBlob(String? value) {
    if (value == null) {
      clearBlob(_kNotificationsBlob);
    } else {
      saveBlob(_kNotificationsBlob, value);
    }
  }

  String? get indexBlob => loadBlob(_kIndexBlob);
  set indexBlob(String? value) {
    if (value == null) {
      clearBlob(_kIndexBlob);
    } else {
      saveBlob(_kIndexBlob, value);
    }
  }
}
