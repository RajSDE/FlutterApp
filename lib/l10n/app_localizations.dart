import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Little Mart'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your mobile number and password to login'**
  String get loginSubtitle;

  /// No description provided for @dummyLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Development login'**
  String get dummyLoginTitle;

  /// No description provided for @dummyLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a dummy user ID while backend APIs are being prepared'**
  String get dummyLoginSubtitle;

  /// No description provided for @dummyUserIdHint.
  ///
  /// In en, this message translates to:
  /// **'Dummy user ID'**
  String get dummyUserIdHint;

  /// No description provided for @loginWithDummyId.
  ///
  /// In en, this message translates to:
  /// **'Login with Dummy ID'**
  String get loginWithDummyId;

  /// No description provided for @otpTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter verification code'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit OTP to your mobile number'**
  String get otpSubtitle;

  /// No description provided for @mobileNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter mobile number'**
  String get mobileNumberHint;

  /// No description provided for @otpHint.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get otpHint;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @resendOtp.
  ///
  /// In en, this message translates to:
  /// **'Resend OTP'**
  String get resendOtp;

  /// No description provided for @orText.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get orText;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get continueWithApple;

  /// No description provided for @signupPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? Sign up'**
  String get signupPrompt;

  /// No description provided for @loginPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Login'**
  String get loginPrompt;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register with your profile details'**
  String get signupSubtitle;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get usernameHint;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordHint;

  /// No description provided for @firstNameHint.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameHint;

  /// No description provided for @lastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameHint;

  /// No description provided for @mobileNumberSignupHint.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileNumberSignupHint;

  /// No description provided for @genderHint.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderHint;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'email@domain.com'**
  String get emailHint;

  /// No description provided for @termsPrefix.
  ///
  /// In en, this message translates to:
  /// **'By clicking continue, you agree to our '**
  String get termsPrefix;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @andText.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get andText;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @homeWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome! You are logged in.'**
  String get homeWelcome;

  /// No description provided for @pageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFound;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageHindi.
  ///
  /// In en, this message translates to:
  /// **'Hindi'**
  String get languageHindi;

  /// No description provided for @errorInvalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please provide a valid email address.'**
  String get errorInvalidEmail;

  /// No description provided for @errorInvalidMobile.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid mobile number.'**
  String get errorInvalidMobile;

  /// No description provided for @errorInvalidOtpRequest.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP verification request.'**
  String get errorInvalidOtpRequest;

  /// No description provided for @errorRequestOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to request OTP right now.'**
  String get errorRequestOtpFailed;

  /// No description provided for @errorVerifyOtpFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to verify OTP right now.'**
  String get errorVerifyOtpFailed;

  /// No description provided for @errorSignupFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to complete signup right now.'**
  String get errorSignupFailed;

  /// No description provided for @errorLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Invalid mobile number or password.'**
  String get errorLoginFailed;

  /// No description provided for @errorInvalidDummyId.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid dummy user ID.'**
  String get errorInvalidDummyId;

  /// No description provided for @errorDummyLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Unable to login with dummy ID right now.'**
  String get errorDummyLoginFailed;

  /// No description provided for @otpSentMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP sent to +91 {phone}'**
  String otpSentMessage(String phone);

  /// No description provided for @otpResent.
  ///
  /// In en, this message translates to:
  /// **'OTP resent successfully'**
  String get otpResent;

  /// No description provided for @homeDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'10 min delivery'**
  String get homeDeliveryTime;

  /// No description provided for @homeLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivering to'**
  String get homeLocationTitle;

  /// No description provided for @homeLocationValue.
  ///
  /// In en, this message translates to:
  /// **'Home, Sector 21'**
  String get homeLocationValue;

  /// No description provided for @homeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search milk, fruits, snacks'**
  String get homeSearchHint;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh picks at your door'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily essentials, snacks, and instant cravings delivered fast.'**
  String get homeHeroSubtitle;

  /// No description provided for @homeCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Shop by category'**
  String get homeCategoriesTitle;

  /// No description provided for @homeDealsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today’s quick deals'**
  String get homeDealsTitle;

  /// No description provided for @homeEssentialsTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily essentials'**
  String get homeEssentialsTitle;

  /// No description provided for @homeSeeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get homeSeeAll;

  /// No description provided for @homeCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get homeCart;

  /// No description provided for @categoryFruits.
  ///
  /// In en, this message translates to:
  /// **'Fruits'**
  String get categoryFruits;

  /// No description provided for @categoryDairy.
  ///
  /// In en, this message translates to:
  /// **'Dairy'**
  String get categoryDairy;

  /// No description provided for @categorySnacks.
  ///
  /// In en, this message translates to:
  /// **'Snacks'**
  String get categorySnacks;

  /// No description provided for @categoryBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get categoryBakery;

  /// No description provided for @categoryDrinks.
  ///
  /// In en, this message translates to:
  /// **'Drinks'**
  String get categoryDrinks;

  /// No description provided for @categoryPersonalCare.
  ///
  /// In en, this message translates to:
  /// **'Care'**
  String get categoryPersonalCare;

  /// No description provided for @dealMorningSaver.
  ///
  /// In en, this message translates to:
  /// **'Morning saver'**
  String get dealMorningSaver;

  /// No description provided for @dealMorningSaverSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to 30% off breakfast basics'**
  String get dealMorningSaverSubtitle;

  /// No description provided for @dealSnackRush.
  ///
  /// In en, this message translates to:
  /// **'Snack rush'**
  String get dealSnackRush;

  /// No description provided for @dealSnackRushSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chips, dips, and cold drinks'**
  String get dealSnackRushSubtitle;

  /// No description provided for @productBanana.
  ///
  /// In en, this message translates to:
  /// **'Fresh Banana'**
  String get productBanana;

  /// No description provided for @productMilk.
  ///
  /// In en, this message translates to:
  /// **'Toned Milk'**
  String get productMilk;

  /// No description provided for @productBread.
  ///
  /// In en, this message translates to:
  /// **'Whole Wheat Bread'**
  String get productBread;

  /// No description provided for @productEggs.
  ///
  /// In en, this message translates to:
  /// **'Farm Eggs'**
  String get productEggs;

  /// No description provided for @productPotatoChips.
  ///
  /// In en, this message translates to:
  /// **'Potato Chips'**
  String get productPotatoChips;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get productAdd;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
