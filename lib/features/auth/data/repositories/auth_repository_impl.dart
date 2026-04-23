import 'package:flutter_app/core/constants/storage_keys.dart';
import 'package:flutter_app/core/error/app_exception.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorageService,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorageService = secureStorageService;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  @override
  Future<Result<Unit>> requestLoginOtp({
    required String phoneNumber,
  }) async {
    try {
      await _remoteDataSource.requestLoginOtp(phoneNumber: phoneNumber);
      return const Success<Unit>(unit);
    } on AppException catch (exception) {
      return Error<Unit>(exception.message);
    } catch (_) {
      return const Error<Unit>('errorRequestOtpFailed');
    }
  }

  @override
  Future<Result<User>> signupWithEmail({
    required String email,
  }) async {
    try {
      final user = await _remoteDataSource.signupWithEmail(email: email);
      await _secureStorageService.write(
        key: StorageKeys.authToken,
        value: user.token,
      );
      await _secureStorageService.write(
        key: StorageKeys.refreshToken,
        value: user.refreshToken,
      );
      return Success<User>(user);
    } on AppException catch (exception) {
      return Error<User>(exception.message);
    } catch (_) {
      return const Error<User>('errorSignupFailed');
    }
  }

  @override
  Future<Result<User>> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    try {
      final user = await _remoteDataSource.verifyLoginOtp(
        phoneNumber: phoneNumber,
        otp: otp,
      );
      await _secureStorageService.write(
        key: StorageKeys.authToken,
        value: user.token,
      );
      await _secureStorageService.write(
        key: StorageKeys.refreshToken,
        value: user.refreshToken,
      );
      return Success<User>(user);
    } on AppException catch (exception) {
      return Error<User>(exception.message);
    } catch (_) {
      return const Error<User>('errorVerifyOtpFailed');
    }
  }
}
