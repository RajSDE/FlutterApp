// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appName => 'ऐप नाम';

  @override
  String get loginTitle => 'अपने अकाउंट में लॉगिन करें';

  @override
  String get loginSubtitle =>
      'लॉगिन करने के लिए अपना मोबाइल नंबर और पासवर्ड दर्ज करें';

  @override
  String get dummyLoginTitle => 'डेवलपमेंट लॉगिन';

  @override
  String get dummyLoginSubtitle =>
      'बैकएंड API तैयार होने तक डमी यूज़र ID इस्तेमाल करें';

  @override
  String get dummyUserIdHint => 'डमी यूज़र ID';

  @override
  String get loginWithDummyId => 'डमी ID से लॉगिन करें';

  @override
  String get otpTitle => 'वेरिफिकेशन कोड दर्ज करें';

  @override
  String get otpSubtitle => 'हमने आपके मोबाइल नंबर पर 6 अंकों का ओटीपी भेजा है';

  @override
  String get mobileNumberHint => 'मोबाइल नंबर दर्ज करें';

  @override
  String get otpHint => '6 अंकों का ओटीपी दर्ज करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String get resendOtp => 'ओटीपी फिर भेजें';

  @override
  String get orText => 'या';

  @override
  String get continueWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get continueWithApple => 'Apple के साथ जारी रखें';

  @override
  String get signupPrompt => 'क्या आपका अकाउंट नहीं है? साइन अप करें';

  @override
  String get loginPrompt => 'क्या आपका अकाउंट है? लॉगिन करें';

  @override
  String get signupTitle => 'अकाउंट बनाएं';

  @override
  String get signupSubtitle => 'अपनी प्रोफाइल जानकारी के साथ रजिस्टर करें';

  @override
  String get usernameHint => 'यूज़रनेम (वैकल्पिक)';

  @override
  String get passwordHint => 'पासवर्ड';

  @override
  String get firstNameHint => 'पहला नाम';

  @override
  String get lastNameHint => 'अंतिम नाम';

  @override
  String get mobileNumberSignupHint => 'मोबाइल नंबर';

  @override
  String get genderHint => 'लिंग';

  @override
  String get genderMale => 'पुरुष';

  @override
  String get genderFemale => 'महिला';

  @override
  String get genderOther => 'अन्य';

  @override
  String get emailHint => 'email@domain.com';

  @override
  String get termsPrefix => 'जारी रखने पर आप हमारी ';

  @override
  String get termsOfService => 'सेवा की शर्तों';

  @override
  String get andText => ' और ';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get homeWelcome => 'स्वागत है! आप लॉगिन हो चुके हैं।';

  @override
  String get pageNotFound => 'पेज नहीं मिला';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageHindi => 'हिंदी';

  @override
  String get errorInvalidEmail => 'कृपया सही ईमेल पता दर्ज करें।';

  @override
  String get errorInvalidMobile => 'कृपया सही मोबाइल नंबर दर्ज करें।';

  @override
  String get errorInvalidOtpRequest => 'ओटीपी सत्यापन अनुरोध अमान्य है।';

  @override
  String get errorRequestOtpFailed => 'अभी ओटीपी अनुरोध नहीं किया जा सका।';

  @override
  String get errorVerifyOtpFailed => 'अभी ओटीपी सत्यापित नहीं किया जा सका।';

  @override
  String get errorSignupFailed => 'अभी साइन अप पूरा नहीं हो सका।';

  @override
  String get errorLoginFailed => 'अमान्य मोबाइल नंबर या पासवर्ड।';

  @override
  String get errorInvalidDummyId => 'कृपया सही डमी यूज़र ID दर्ज करें।';

  @override
  String get errorDummyLoginFailed => 'अभी डमी ID से लॉगिन नहीं किया जा सका।';

  @override
  String otpSentMessage(String phone) {
    return '+91 $phone पर ओटीपी भेज दिया गया है';
  }

  @override
  String get otpResent => 'ओटीपी फिर भेज दिया गया है';

  @override
  String get homeDeliveryTime => '10 मिनट डिलीवरी';

  @override
  String get homeLocationTitle => 'डिलीवरी यहां';

  @override
  String get homeLocationValue => 'घर, सेक्टर 21';

  @override
  String get homeSearchHint => 'दूध, फल, स्नैक्स खोजें';

  @override
  String get homeHeroTitle => 'ताज़ा सामान आपके दरवाज़े पर';

  @override
  String get homeHeroSubtitle =>
      'रोज़मर्रा की ज़रूरतें, स्नैक्स और तुरंत cravings तेज़ डिलीवरी के साथ।';

  @override
  String get homeCategoriesTitle => 'कैटेगरी से खरीदें';

  @override
  String get homeDealsTitle => 'आज की तेज़ डील्स';

  @override
  String get homeEssentialsTitle => 'डेली एसेंशियल्स';

  @override
  String get homeSeeAll => 'सभी देखें';

  @override
  String get homeCart => 'कार्ट';

  @override
  String get categoryFruits => 'फल';

  @override
  String get categoryDairy => 'डेयरी';

  @override
  String get categorySnacks => 'स्नैक्स';

  @override
  String get categoryBakery => 'बेकरी';

  @override
  String get categoryDrinks => 'ड्रिंक्स';

  @override
  String get categoryPersonalCare => 'केयर';

  @override
  String get dealMorningSaver => 'मॉर्निंग सेवर';

  @override
  String get dealMorningSaverSubtitle => 'ब्रेकफास्ट बेसिक्स पर 30% तक छूट';

  @override
  String get dealSnackRush => 'स्नैक रश';

  @override
  String get dealSnackRushSubtitle => 'चिप्स, डिप्स और ठंडी ड्रिंक्स';

  @override
  String get productBanana => 'ताज़ा केला';

  @override
  String get productMilk => 'टोन्ड दूध';

  @override
  String get productBread => 'होल व्हीट ब्रेड';

  @override
  String get productEggs => 'फार्म अंडे';

  @override
  String get productPotatoChips => 'पोटैटो चिप्स';

  @override
  String get productAdd => 'जोड़ें';
}
