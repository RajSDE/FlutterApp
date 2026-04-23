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
  String otpSentMessage(String phone) {
    return 'OTP sent to +91 $phone';
  }

  @override
  String get otpResent => 'OTP resent successfully';
}
