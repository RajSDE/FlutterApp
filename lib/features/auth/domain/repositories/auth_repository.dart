import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';
import 'package:flutter_app/features/auth/domain/entities/verification_result.dart';

abstract class AuthRepository {
  Future<Result<User>> loginWithDummyId({
    required String dummyUserId,
  });

  Future<Result<Unit>> requestLoginOtp({
    required String phoneNumber,
  });

  Future<Result<User>> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<Result<User>> loginWithMobileAndPassword({
    required String mobileNumber,
    required String password,
  });

  Future<Result<RegistrationResult>> registerUser({
    required RegisterUserRequest request,
  });

  Future<Result<User>> getUserProfile({
    required String userProfileId,
  });

  Future<Result<VerificationResult>> sendIdentifierVerification({
    required String identifierType,
    required String identifierValue,
  });

  Future<Result<Unit>> validateIdentifierOtp({
    required String uniqueId,
    required String otp,
  });
}
