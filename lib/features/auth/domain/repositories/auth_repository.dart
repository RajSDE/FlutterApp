import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/core/result/result.dart';

abstract class AuthRepository {
  Future<Result<Unit>> requestLoginOtp({
    required String phoneNumber,
  });

  Future<Result<User>> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<Result<User>> signupWithEmail({
    required String email,
  });
}
