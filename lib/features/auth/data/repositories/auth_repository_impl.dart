import 'package:flutter_app/core/constants/storage_keys.dart';
import 'package:flutter_app/core/error/app_exception.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';
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
  Future<Result<User>> loginWithDummyId({
    required String dummyUserId,
  }) async {
    try {
      final user =
          await _remoteDataSource.loginWithDummyId(dummyUserId: dummyUserId);
      await _persistSession(user);
      return Success<User>(user);
    } on AppException catch (exception) {
      return Error<User>(exception.message);
    } catch (_) {
      return const Error<User>('errorDummyLoginFailed');
    }
  }

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
  Future<Result<RegistrationResult>> registerUser({
    required RegisterUserRequest request,
  }) async {
    try {
      final result = await _remoteDataSource.registerUser(request: request);
      return Success<RegistrationResult>(result);
    } on AppException catch (exception) {
      return Error<RegistrationResult>(exception.message);
    } catch (_) {
      return const Error<RegistrationResult>('errorSignupFailed');
    }
  }

  @override
  Future<Result<User>> loginWithMobileAndPassword({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.loginWithMobileAndPassword(
        mobileNumber: mobileNumber,
        password: password,
      );
      await _persistSession(user);

      // Fetch complete user profile details
      try {
        final profile = await _remoteDataSource.getUserProfile(
          userProfileId: user.userProfileId,
        );
        final fullUser = user.copyWith(
          name: profile.name,
          email: profile.email,
          mobileNumber: profile.mobileNumber,
          gender: profile.gender,
          preferredLanguage: profile.preferredLanguage,
          mobileNumberVerified: profile.mobileNumberVerified,
          emailVerified: profile.emailVerified,
          userProfileId: profile.userProfileId,
        );
        return Success<User>(fullUser);
      } catch (_) {
        // Fallback to login user model if profile endpoint fails
        return Success<User>(user);
      }
    } on AppException catch (exception) {
      return Error<User>(exception.message);
    } catch (_) {
      return const Error<User>('errorLoginFailed');
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
      await _persistSession(user);

      if (user.userProfileId.isNotEmpty) {
        try {
          final profile = await _remoteDataSource.getUserProfile(
            userProfileId: user.userProfileId,
          );
          final fullUser = user.copyWith(
            name: profile.name,
            email: profile.email,
            mobileNumber: profile.mobileNumber,
            gender: profile.gender,
            preferredLanguage: profile.preferredLanguage,
            mobileNumberVerified: profile.mobileNumberVerified,
            emailVerified: profile.emailVerified,
            userProfileId: profile.userProfileId,
          );
          return Success<User>(fullUser);
        } catch (_) {
          return Success<User>(user);
        }
      }
      return Success<User>(user);
    } on AppException catch (exception) {
      return Error<User>(exception.message);
    } catch (_) {
      return const Error<User>('errorVerifyOtpFailed');
    }
  }

  Future<void> _persistSession(User user) async {
    await _secureStorageService.write(
      key: StorageKeys.authToken,
      value: user.token,
    );
    await _secureStorageService.write(
      key: StorageKeys.refreshToken,
      value: user.refreshToken,
    );
  }

  @override
  Future<Result<String>> sendIdentifierVerification({
    required String identifierType,
    required String identifierValue,
  }) async {
    try {
      final uniqueId = await _remoteDataSource.sendIdentifierVerification(
        identifierType: identifierType,
        identifierValue: identifierValue,
      );
      return Success<String>(uniqueId);
    } on AppException catch (exception) {
      return Error<String>(exception.message);
    } catch (_) {
      return const Error<String>('errorSendVerificationFailed');
    }
  }

  @override
  Future<Result<Unit>> validateIdentifierOtp({
    required String uniqueId,
    required String otp,
  }) async {
    try {
      await _remoteDataSource.validateIdentifierOtp(
        uniqueId: uniqueId,
        otp: otp,
      );
      return const Success<Unit>(unit);
    } on AppException catch (exception) {
      return Error<Unit>(exception.message);
    } catch (_) {
      return const Error<Unit>('errorValidateOtpFailed');
    }
  }
}
