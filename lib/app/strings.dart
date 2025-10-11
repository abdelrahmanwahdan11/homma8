import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings._(this.locale);

  factory AppStrings.fromLocale(Locale locale) => AppStrings._(locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static AppStrings of(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return AppStrings._(locale);
  }

  bool get isArabic => locale.languageCode == 'ar';

  String t(String key) {
    final lang = locale.languageCode;
    final fallback = _localized['en']!;
    return _localized[lang]?[key] ?? fallback[key] ?? key;
  }

  String getDirectionText(String key) => t(key);
}

const Map<String, Map<String, String>> _localized = {
  'en': {
    'app_title': 'SwipeBid',
    'onboarding_1_title': 'Swipe to Shop',
    'onboarding_1_sub': 'Discover products with a Tinder-like experience.',
    'onboarding_2_title': 'Discounts Rise with Demand',
    'onboarding_2_sub': 'More interest = bigger discounts for everyone.',
    'onboarding_3_title': 'Auctions & Alerts',
    'onboarding_3_sub': 'Bid to win or set a target price and get notified.',
    'cta_get_started': 'Get Started',
    'tab_swipe': 'Discover',
    'tab_auctions': 'Auctions',
    'tab_sell': 'Sell',
    'tab_profile': 'Profile',
    'label_watch': 'Watch',
    'label_bid_now': 'Bid Now',
    'label_request_discount': 'Request Discount',
    'label_target_price': 'Target Price',
    'label_skip': 'Skip',
    'howto_title': 'How to use',
    'howto_start_tour': 'Start app tour',
    'btn_post_to_sell': 'Post to Sell',
    'btn_post_wanted': 'Post Wanted',
    'discount_label': 'Discount',
    'auction_label': 'Auction',
    'min_left': 'min left',
    'error_title': 'Something went wrong',
    'retry': 'Retry',
    'cancel': 'Cancel',
    'condition_new': 'New',
    'condition_likeNew': 'Like new',
    'condition_good': 'Good',
    'condition_fair': 'Fair',
    'howto_step_swipe': 'Swipe right to add to Watchlist.',
    'howto_step_bid': 'Tap to place a bid.',
    'howto_step_discount': 'Discount grows with demand.',
    'howto_step_sell': 'Post items or wanted ads.',
    'sell_title': 'Sell',
    'wanted_title': 'Wanted',
    'form_title': 'Title',
    'form_category': 'Category',
    'form_condition': 'Condition',
    'form_base_price': 'Base price',
    'form_notes': 'Notes',
    'form_submit': 'Submit',
    'form_mode': 'Sale mode',
    'form_recommendation': 'Suggested',
    'watchlist_empty': 'Your watchlist is empty.',
    'alerts_empty': 'No alerts yet.',
    'profile_watchlist': 'Watchlist',
    'profile_alerts': 'Alerts',
    'toggle_language': 'عربي',
    'toggle_theme': 'Theme',
  },
  'ar': {
    'app_title': 'سوايب بيد',
    'onboarding_1_title': 'تسوّق بالسحب',
    'onboarding_1_sub': 'استكشف المنتجات بواجهة مشابهة لتطبيق تندر.',
    'onboarding_2_title': 'الخصم يزيد مع الطلب',
    'onboarding_2_sub': 'كلما زاد الاهتمام زاد الخصم للجميع.',
    'onboarding_3_title': 'مزادات والتنبيهات',
    'onboarding_3_sub': 'زايد للفوز أو حدّد سعراً مستهدفاً لتصلك إشعارات.',
    'cta_get_started': 'ابدأ الآن',
    'tab_swipe': 'الاكتشاف',
    'tab_auctions': 'المزادات',
    'tab_sell': 'بيع',
    'tab_profile': 'حسابي',
    'label_watch': 'متابعة',
    'label_bid_now': 'زايد الآن',
    'label_request_discount': 'طلب خصم',
    'label_target_price': 'سعر مستهدف',
    'label_skip': 'تخطي',
    'howto_title': 'طريقة الاستخدام',
    'howto_start_tour': 'ابدأ الجولة الإرشادية',
    'btn_post_to_sell': 'اعرض للبيع',
    'btn_post_wanted': 'أعلن طلب شراء',
    'discount_label': 'خصم',
    'auction_label': 'مزاد',
    'min_left': 'دقيقة متبقية',
    'error_title': 'حدث خطأ',
    'retry': 'إعادة المحاولة',
    'cancel': 'إلغاء',
    'condition_new': 'جديد',
    'condition_likeNew': 'شبه جديد',
    'condition_good': 'جيد',
    'condition_fair': 'مقبول',
    'howto_step_swipe': 'اسحب لليمين للإضافة إلى المتابعة.',
    'howto_step_bid': 'اضغط للمزايدة.',
    'howto_step_discount': 'الخصم يزيد مع الطلب.',
    'howto_step_sell': 'اعرض للبيع أو أعلن طلب شراء.',
    'sell_title': 'بيع',
    'wanted_title': 'مطلوب',
    'form_title': 'العنوان',
    'form_category': 'الفئة',
    'form_condition': 'الحالة',
    'form_base_price': 'السعر الأساسي',
    'form_notes': 'ملاحظات',
    'form_submit': 'إرسال',
    'form_mode': 'نوع البيع',
    'form_recommendation': 'اقتراح',
    'watchlist_empty': 'قائمة المتابعة فارغة.',
    'alerts_empty': 'لا توجد تنبيهات بعد.',
    'profile_watchlist': 'المتابعة',
    'profile_alerts': 'التنبيهات',
    'toggle_language': 'English',
    'toggle_theme': 'السمة',
  },
};
