import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';

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

  Future<Result<RegistrationResult>> registerUser({
    required RegisterUserRequest request,
  });
}
