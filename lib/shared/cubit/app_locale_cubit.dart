import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/constants/storage_keys.dart';
import 'package:flutter_app/core/security/secure_storage.dart';

class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit({
    required SecureStorageService secureStorageService,
  })  : _secureStorageService = secureStorageService,
        super(const Locale('en'));

  final SecureStorageService _secureStorageService;

  Future<void> loadSavedLocale() async {
    final languageCode =
        await _secureStorageService.read(StorageKeys.languageCode);
    if (languageCode != null && languageCode.isNotEmpty) {
      emit(Locale(languageCode));
    }
  }

  Future<void> updateLocale(Locale locale) async {
    await _secureStorageService.write(
      key: StorageKeys.languageCode,
      value: locale.languageCode,
    );
    emit(locale);
  }
}
