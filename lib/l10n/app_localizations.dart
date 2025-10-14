// GENERATED CODE - DO NOT MODIFY BY HAND.
// ignore_for_file: type=lint

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

abstract class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  String get appTitle;
  String get login;
  String get signUp;
  String get continueAsGuest;
  String get home;
  String get explore;
  String get create;
  String get matches;
  String get favorites;
  String get profile;
  String get search;
  String get filters;
  String get placeBid;
  String get addWanted;
  String get aiInfo;
  String get darkMode;
  String get language;
  String get english;
  String get arabic;
  String get systemDefault;
  String get tabForYou;
  String get tabAuctions;
  String get tabWanted;
  String get wantedDraftSavedMock;
  String get specs;
  String get budget;
  String get category;
  String get publish;
  String get publishMock;
  String get auctionDraftSavedMock;
  String get images;
  String mockImageLabel({ required int index });
  String get addPlaceholderImage;
  String get atLeastOneImageRequired;
  String get errorEmailRequired;
  String get errorEmailInvalid;
  String get errorPasswordRequired;
  String errorPasswordMin({ required int min });
  String get errorNameShort;
  String get errorPasswordsMismatch;
  String get errorTitleShort;
  String errorValueMustBePositive({ required String label });
  String get errorAddImage;
  String get details;
  String get pricing;
  String get skip;
  String get next;
  String get done;
  String get sort;
  String get sortBy;
  String get sortScore;
  String get sortBuyerId;
  String buyerLabel({ required String id });
  String get invite;
  String get offer;
  String currentBidValue({ required String amount });
  String get submitBid;
  String get aiInsights;
  String approxPrice({ required String amount });
  String get prosDescription;
  String get consDescription;
  String aiSummaryTemplate({ required String title });
  String get auctionDetails;
  String get auctionNotFound;
  String endsIn({ required String time });
  String bidPlaced({ required String amount });
  String get bidHistory;
  String bidderLabel({ required int number });
  String get mockTimestamp;
  String usdAmount({ required String amount });
  String get noFavoritesYet;
  String get forgotPassword;
  String get loggedInMock;
  String get resetLinkSentMock;
  String get accountCreatedMock;
  String get guestModeActivated;
  String get guestSession;
  String get member;
  String get helpFaq;
  String get onboardingIndustrial;
  String get onboardingSell;
  String get onboardingFind;
  String get onboardingAi;
  String get faqHowBid;
  String get faqHowBidAnswer;
  String get faqHowWanted;
  String get faqHowWantedAnswer;
  String get faqContactSupport;
  String get wantedBoard;
  String budgetValue({ required String amount });
  String budgetShort({ required String amount });
  String locationValue({ required String location });
  String get suggestItem;
  String get suggestItemMock;
  String get relevance;
  String get price;
  String get endTime;
  String get noResults;
  String get notifications;
  String get notificationAuctionEnding;
  String get notificationNewBid;
  String get notificationWantedMatch;
  String get notificationPriceDrop;
  String get notificationSystem;
  String get timeJustNow;
  String timeMinutesAgo({ required int minutes });
  String timeHoursAgo({ required int hours });
  String timeDaysAgo({ required int days });
  String get notificationSettingsSoon;
  String get logout;
  String get logoutMock;
  String get email;
  String get password;
  String get fullName;
  String get confirmPassword;
  String get title;
  String get description;
  String get startPrice;
  String get maxPrice;
  String get location;
  String get yourBid;
  String get allCategories;
  String get bidMustExceedCurrent;
  String bidsAndLocation({ required int bids, required String location });
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
    default:
      return AppLocalizationsEn();
  }
}

class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn() : super(const Locale('en'));

  @override
  String get appTitle => 'BazaarX';

  @override
  String get login => 'Log in';

  @override
  String get signUp => 'Sign up';

  @override
  String get continueAsGuest => 'Continue as guest';

  @override
  String get home => 'Home';

  @override
  String get explore => 'Explore';

  @override
  String get create => 'Create';

  @override
  String get matches => 'Matches';

  @override
  String get favorites => 'Favorites';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search auctions & wanted';

  @override
  String get filters => 'Filters';

  @override
  String get placeBid => 'Place bid';

  @override
  String get addWanted => 'Add wanted';

  @override
  String get aiInfo => 'AI info';

  @override
  String get darkMode => 'Dark mode';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'Arabic';

  @override
  String get systemDefault => 'System';

  @override
  String get tabForYou => 'For you';

  @override
  String get tabAuctions => 'Auctions';

  @override
  String get tabWanted => 'Wanted';

  @override
  String get wantedDraftSavedMock => 'Wanted draft saved (mock publish soon)';

  @override
  String get specs => 'Specs';

  @override
  String get budget => 'Budget';

  @override
  String get category => 'Category';

  @override
  String get publish => 'Publish';

  @override
  String get publishMock => 'Publish mock';

  @override
  String get auctionDraftSavedMock => 'Auction draft saved (mock publish soon)';

  @override
  String get images => 'Images';

  @override
  String mockImageLabel({ required int index }) => 'Mock image ${index}';

  @override
  String get addPlaceholderImage => 'Add placeholder image';

  @override
  String get atLeastOneImageRequired => 'At least one image required';

  @override
  String get errorEmailRequired => 'Email required';

  @override
  String get errorEmailInvalid => 'Enter a valid email';

  @override
  String get errorPasswordRequired => 'Password required';

  @override
  String errorPasswordMin({ required int min }) => 'Password must be at least ${min} characters';

  @override
  String get errorNameShort => 'Name too short';

  @override
  String get errorPasswordsMismatch => 'Passwords do not match';

  @override
  String get errorTitleShort => 'Title too short';

  @override
  String errorValueMustBePositive({ required String label }) => '${label} must be positive';

  @override
  String get errorAddImage => 'Add at least one image';

  @override
  String get details => 'Details';

  @override
  String get pricing => 'Pricing';

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get done => 'Done';

  @override
  String get sort => 'Sort:';

  @override
  String get sortBy => 'Sort by:';

  @override
  String get sortScore => 'Score';

  @override
  String get sortBuyerId => 'Buyer ID';

  @override
  String buyerLabel({ required String id }) => 'Buyer ${id}';

  @override
  String get invite => 'Invite';

  @override
  String get offer => 'Offer';

  @override
  String currentBidValue({ required String amount }) => 'Current bid: ${amount}';

  @override
  String get submitBid => 'Submit bid';

  @override
  String get aiInsights => 'AI insights';

  @override
  String approxPrice({ required String amount }) => 'Approx price: ${amount}';

  @override
  String get prosDescription => 'Pros: Industrial minimal build, lime-accented detailing.';

  @override
  String get consDescription => 'Cons: Mock data, confirm condition.';

  @override
  String aiSummaryTemplate({ required String title }) => 'AI summary: ${title} with lime aesthetic ready for industrial setups.';

  @override
  String get auctionDetails => 'Auction details';

  @override
  String get auctionNotFound => 'Auction not found';

  @override
  String endsIn({ required String time }) => 'Ends in ${time}';

  @override
  String bidPlaced({ required String amount }) => 'Bid placed: ${amount}';

  @override
  String get bidHistory => 'Bid history';

  @override
  String bidderLabel({ required int number }) => 'Bidder #${number}';

  @override
  String get mockTimestamp => 'Mock timestamp';

  @override
  String usdAmount({ required String amount }) => '${amount} USD';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get loggedInMock => 'Logged in (mock)';

  @override
  String get resetLinkSentMock => 'Reset link sent (mock)';

  @override
  String get accountCreatedMock => 'Account created (mock)';

  @override
  String get guestModeActivated => 'Guest mode activated';

  @override
  String get guestSession => 'Guest session';

  @override
  String get member => 'Member';

  @override
  String get helpFaq => 'Help & FAQ';

  @override
  String get onboardingIndustrial => 'Industrial introductions';

  @override
  String get onboardingSell => 'Sell with auctions';

  @override
  String get onboardingFind => 'Find wanted buyers';

  @override
  String get onboardingAi => 'AI ready insights';

  @override
  String get faqHowBid => 'How to place a bid?';

  @override
  String get faqHowBidAnswer => 'Open an auction, tap place bid, confirm mock bid.';

  @override
  String get faqHowWanted => 'How to add wanted post?';

  @override
  String get faqHowWantedAnswer => 'Navigate to create tab and fill the wanted wizard.';

  @override
  String get faqContactSupport => 'Contact support (placeholder)';

  @override
  String get wantedBoard => 'Wanted board';

  @override
  String budgetValue({ required String amount }) => 'Budget: ${amount} USD';

  @override
  String budgetShort({ required String amount }) => 'Budget ${amount} USD';

  @override
  String locationValue({ required String location }) => 'Location: ${location}';

  @override
  String get suggestItem => 'Suggest item';

  @override
  String get suggestItemMock => 'Suggest item (mock)';

  @override
  String get relevance => 'Relevance';

  @override
  String get price => 'Price';

  @override
  String get endTime => 'End time';

  @override
  String get noResults => 'No results';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationAuctionEnding => 'Auction ending soon';

  @override
  String get notificationNewBid => 'You received a new bid';

  @override
  String get notificationWantedMatch => 'New wanted match for your listing';

  @override
  String get notificationPriceDrop => 'Price drop detected';

  @override
  String get notificationSystem => 'System maintenance scheduled';

  @override
  String get timeJustNow => 'just now';

  @override
  String timeMinutesAgo({ required int minutes }) => '${minutes}m ago';

  @override
  String timeHoursAgo({ required int hours }) => '${hours}h ago';

  @override
  String timeDaysAgo({ required int days }) => '${days}d ago';

  @override
  String get notificationSettingsSoon => 'Notification settings coming soon';

  @override
  String get logout => 'Logout';

  @override
  String get logoutMock => 'Logout mock (stay guest)';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full name';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get startPrice => 'Start price';

  @override
  String get maxPrice => 'Max price';

  @override
  String get location => 'Location';

  @override
  String get yourBid => 'Your bid';

  @override
  String get allCategories => 'All';

  @override
  String get bidMustExceedCurrent => 'Bid must be higher than current bid';

  @override
  String bidsAndLocation({ required int bids, required String location }) => '${bids} bids · ${location}';
}

class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr() : super(const Locale('ar'));

  @override
  String get appTitle => 'بازار إكس';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get continueAsGuest => 'الدخول كضيف';

  @override
  String get home => 'الرئيسية';

  @override
  String get explore => 'استكشاف';

  @override
  String get create => 'إنشاء';

  @override
  String get matches => 'التوفيق';

  @override
  String get favorites => 'المفضلة';

  @override
  String get profile => 'الحساب';

  @override
  String get search => 'ابحث في المزادات والطلبات';

  @override
  String get filters => 'فلاتر';

  @override
  String get placeBid => 'قدّم مزايدة';

  @override
  String get addWanted => 'أضف طلب شراء';

  @override
  String get aiInfo => 'معلومات بالذكاء';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get systemDefault => 'النظام';

  @override
  String get tabForYou => 'لك';

  @override
  String get tabAuctions => 'مزادات';

  @override
  String get tabWanted => 'طلبات';

  @override
  String get wantedDraftSavedMock => 'تم حفظ مسودة الطلب (نشر تجريبي قريباً)';

  @override
  String get specs => 'المواصفات';

  @override
  String get budget => 'الميزانية';

  @override
  String get category => 'الفئة';

  @override
  String get publish => 'نشر';

  @override
  String get publishMock => 'نشر تجريبي';

  @override
  String get auctionDraftSavedMock => 'تم حفظ مسودة المزاد (نشر تجريبي قريباً)';

  @override
  String get images => 'الصور';

  @override
  String mockImageLabel({ required int index }) => 'صورة تجريبية ${index}';

  @override
  String get addPlaceholderImage => 'أضف صورة بديلة';

  @override
  String get atLeastOneImageRequired => 'يلزم صورة واحدة على الأقل';

  @override
  String get errorEmailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get errorEmailInvalid => 'أدخل بريداً صالحاً';

  @override
  String get errorPasswordRequired => 'كلمة المرور مطلوبة';

  @override
  String errorPasswordMin({ required int min }) => 'يجب أن تكون كلمة المرور ${min} أحرف على الأقل';

  @override
  String get errorNameShort => 'الاسم قصير جداً';

  @override
  String get errorPasswordsMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get errorTitleShort => 'العنوان قصير جداً';

  @override
  String errorValueMustBePositive({ required String label }) => '${label} يجب أن يكون موجباً';

  @override
  String get errorAddImage => 'أضف صورة واحدة على الأقل';

  @override
  String get details => 'التفاصيل';

  @override
  String get pricing => 'التسعير';

  @override
  String get skip => 'تخطي';

  @override
  String get next => 'التالي';

  @override
  String get done => 'تم';

  @override
  String get sort => 'ترتيب:';

  @override
  String get sortBy => 'ترتيب حسب:';

  @override
  String get sortScore => 'النتيجة';

  @override
  String get sortBuyerId => 'معرف المشتري';

  @override
  String buyerLabel({ required String id }) => 'المشتري ${id}';

  @override
  String get invite => 'دعوة';

  @override
  String get offer => 'عرض';

  @override
  String currentBidValue({ required String amount }) => 'أعلى مزايدة: ${amount}';

  @override
  String get submitBid => 'إرسال المزايدة';

  @override
  String get aiInsights => 'رؤى الذكاء';

  @override
  String approxPrice({ required String amount }) => 'السعر التقديري: ${amount}';

  @override
  String get prosDescription => 'الإيجابيات: تصميم صناعي بسيط مع لمسات ليمونية.';

  @override
  String get consDescription => 'السلبيات: بيانات تجريبية، يرجى تأكيد الحالة.';

  @override
  String aiSummaryTemplate({ required String title }) => 'ملخص بالذكاء: ${title} بلمسة ليمونية جاهزة للبيئات الصناعية.';

  @override
  String get auctionDetails => 'تفاصيل المزاد';

  @override
  String get auctionNotFound => 'لم يتم العثور على المزاد';

  @override
  String endsIn({ required String time }) => 'ينتهي خلال ${time}';

  @override
  String bidPlaced({ required String amount }) => 'تم تقديم مزايدة بقيمة ${amount}';

  @override
  String get bidHistory => 'سجل المزايدات';

  @override
  String bidderLabel({ required int number }) => 'المزايد #${number}';

  @override
  String get mockTimestamp => 'توقيت تجريبي';

  @override
  String usdAmount({ required String amount }) => '${amount} دولار';

  @override
  String get noFavoritesYet => 'لا توجد عناصر مفضلة بعد';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get loggedInMock => 'تم تسجيل الدخول (تجريبي)';

  @override
  String get resetLinkSentMock => 'تم إرسال رابط إعادة التعيين (تجريبي)';

  @override
  String get accountCreatedMock => 'تم إنشاء الحساب (تجريبي)';

  @override
  String get guestModeActivated => 'تم تفعيل وضع الضيف';

  @override
  String get guestSession => 'جلسة ضيف';

  @override
  String get member => 'عضو';

  @override
  String get helpFaq => 'المساعدة والأسئلة الشائعة';

  @override
  String get onboardingIndustrial => 'تعريفات صناعية';

  @override
  String get onboardingSell => 'بع بسهولة عبر المزادات';

  @override
  String get onboardingFind => 'اعثر على المشترين الباحثين';

  @override
  String get onboardingAi => 'رؤى جاهزة بالذكاء الاصطناعي';

  @override
  String get faqHowBid => 'كيف أقدّم مزايدة؟';

  @override
  String get faqHowBidAnswer => 'افتح مزاداً، اضغط على زر تقديم المزايدة ثم أكد العملية التجريبية.';

  @override
  String get faqHowWanted => 'كيف أضيف طلب شراء؟';

  @override
  String get faqHowWantedAnswer => 'انتقل إلى تبويب الإنشاء وأكمل خطوات معالج الطلب.';

  @override
  String get faqContactSupport => 'التواصل مع الدعم (تجريبي)';

  @override
  String get wantedBoard => 'لوحة الطلبات';

  @override
  String budgetValue({ required String amount }) => 'الميزانية: ${amount} دولار';

  @override
  String budgetShort({ required String amount }) => 'الميزانية ${amount} دولار';

  @override
  String locationValue({ required String location }) => 'الموقع: ${location}';

  @override
  String get suggestItem => 'اقترح عنصراً';

  @override
  String get suggestItemMock => 'اقتراح عنصر (تجريبي)';

  @override
  String get relevance => 'الملاءمة';

  @override
  String get price => 'السعر';

  @override
  String get endTime => 'وقت الانتهاء';

  @override
  String get noResults => 'لا توجد نتائج';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get notificationAuctionEnding => 'المزاد ينتهي قريباً';

  @override
  String get notificationNewBid => 'استلمت مزايدة جديدة';

  @override
  String get notificationWantedMatch => 'تطابق جديد لطلبك';

  @override
  String get notificationPriceDrop => 'تم رصد خفض في السعر';

  @override
  String get notificationSystem => 'صيانة للنظام مجدولة';

  @override
  String get timeJustNow => 'الآن';

  @override
  String timeMinutesAgo({ required int minutes }) => 'قبل ${minutes} دقيقة';

  @override
  String timeHoursAgo({ required int hours }) => 'قبل ${hours} ساعة';

  @override
  String timeDaysAgo({ required int days }) => 'قبل ${days} يوم';

  @override
  String get notificationSettingsSoon => 'إعدادات الإشعارات قريباً';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get logoutMock => 'تسجيل خروج تجريبي (ابقَ كضيف)';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get title => 'العنوان';

  @override
  String get description => 'الوصف';

  @override
  String get startPrice => 'سعر البدء';

  @override
  String get maxPrice => 'الحد الأقصى للسعر';

  @override
  String get location => 'الموقع';

  @override
  String get yourBid => 'مزايدتك';

  @override
  String get allCategories => 'الكل';

  @override
  String get bidMustExceedCurrent => 'يجب أن تكون المزايدة أعلى من الحالية';

  @override
  String bidsAndLocation({ required int bids, required String location }) => '${bids} مزايدة · ${location}';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((supported) => supported.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
