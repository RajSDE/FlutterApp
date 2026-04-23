import 'package:flutter/widgets.dart';
import 'package:flutter_app/l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);

  String resolveMessage(String key) {
    switch (key) {
      case 'errorInvalidEmail':
        return l10n.errorInvalidEmail;
      case 'errorInvalidMobile':
        return l10n.errorInvalidMobile;
      case 'errorInvalidOtpRequest':
        return l10n.errorInvalidOtpRequest;
      case 'errorRequestOtpFailed':
        return l10n.errorRequestOtpFailed;
      case 'errorVerifyOtpFailed':
        return l10n.errorVerifyOtpFailed;
      case 'errorSignupFailed':
        return l10n.errorSignupFailed;
      default:
        return key;
    }
  }
}
