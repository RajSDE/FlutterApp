// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'App name';

  @override
  String get loginTitle => 'Login to your account';

  @override
  String get loginSubtitle =>
      'Enter your mobile number to receive a one-time password';

  @override
  String get dummyLoginTitle => 'Development login';

  @override
  String get dummyLoginSubtitle =>
      'Use a dummy user ID while backend APIs are being prepared';

  @override
  String get dummyUserIdHint => 'Dummy user ID';

  @override
  String get loginWithDummyId => 'Login with Dummy ID';

  @override
  String get otpTitle => 'Enter verification code';

  @override
  String get otpSubtitle => 'We sent a 6-digit OTP to your mobile number';

  @override
  String get mobileNumberHint => 'Enter mobile number';

  @override
  String get otpHint => 'Enter 6-digit OTP';

  @override
  String get continueText => 'Continue';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get resendOtp => 'Resend OTP';

  @override
  String get orText => 'or';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithApple => 'Continue with Apple';

  @override
  String get signupPrompt => 'Don\'t have an account? Sign up';

  @override
  String get loginPrompt => 'Already have an account? Login';

  @override
  String get signupTitle => 'Create an account';

  @override
  String get signupSubtitle => 'Enter your email to sign up for this app';

  @override
  String get emailHint => 'email@domain.com';

  @override
  String get termsPrefix => 'By clicking continue, you agree to our ';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get andText => ' and ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get homeWelcome => 'Welcome! You are logged in.';

  @override
  String get pageNotFound => 'Page not found';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'Hindi';

  @override
  String get errorInvalidEmail => 'Please provide a valid email address.';

  @override
  String get errorInvalidMobile => 'Enter a valid mobile number.';

  @override
  String get errorInvalidOtpRequest => 'Invalid OTP verification request.';

  @override
  String get errorRequestOtpFailed => 'Unable to request OTP right now.';

  @override
  String get errorVerifyOtpFailed => 'Unable to verify OTP right now.';

  @override
  String get errorSignupFailed => 'Unable to complete signup right now.';

  @override
  String get errorInvalidDummyId => 'Enter a valid dummy user ID.';

  @override
  String get errorDummyLoginFailed =>
      'Unable to login with dummy ID right now.';

  @override
  String otpSentMessage(String phone) {
    return 'OTP sent to +91 $phone';
  }

  @override
  String get otpResent => 'OTP resent successfully';

  @override
  String get homeDeliveryTime => '10 min delivery';

  @override
  String get homeLocationTitle => 'Delivering to';

  @override
  String get homeLocationValue => 'Home, Sector 21';

  @override
  String get homeSearchHint => 'Search milk, fruits, snacks';

  @override
  String get homeHeroTitle => 'Fresh picks at your door';

  @override
  String get homeHeroSubtitle =>
      'Daily essentials, snacks, and instant cravings delivered fast.';

  @override
  String get homeCategoriesTitle => 'Shop by category';

  @override
  String get homeDealsTitle => 'Today’s quick deals';

  @override
  String get homeEssentialsTitle => 'Daily essentials';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get homeCart => 'Cart';

  @override
  String get categoryFruits => 'Fruits';

  @override
  String get categoryDairy => 'Dairy';

  @override
  String get categorySnacks => 'Snacks';

  @override
  String get categoryBakery => 'Bakery';

  @override
  String get categoryDrinks => 'Drinks';

  @override
  String get categoryPersonalCare => 'Care';

  @override
  String get dealMorningSaver => 'Morning saver';

  @override
  String get dealMorningSaverSubtitle => 'Up to 30% off breakfast basics';

  @override
  String get dealSnackRush => 'Snack rush';

  @override
  String get dealSnackRushSubtitle => 'Chips, dips, and cold drinks';

  @override
  String get productBanana => 'Fresh Banana';

  @override
  String get productMilk => 'Toned Milk';

  @override
  String get productBread => 'Whole Wheat Bread';

  @override
  String get productEggs => 'Farm Eggs';

  @override
  String get productPotatoChips => 'Potato Chips';

  @override
  String get productAdd => 'Add';
}
