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
      'वन-टाइम पासवर्ड पाने के लिए अपना मोबाइल नंबर दर्ज करें';

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
  String get signupSubtitle =>
      'इस ऐप के लिए साइन अप करने हेतु अपना ईमेल दर्ज करें';

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
  String otpSentMessage(String phone) {
    return '+91 $phone पर ओटीपी भेज दिया गया है';
  }

  @override
  String get otpResent => 'ओटीपी फिर भेज दिया गया है';
}
