import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> requestLoginOtp({
    required String phoneNumber,
  });

  Future<UserModel> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<UserModel> signupWithEmail({
    required String email,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<void> requestLoginOtp({
    required String phoneNumber,
  }) async {
    await _apiClient.post(
      '/auth/request-otp',
      data: <String, dynamic>{'phone': phoneNumber},
    );
  }

  @override
  Future<UserModel> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      '/auth/verify-otp',
      data: <String, dynamic>{
        'phone': phoneNumber,
        'otp': otp,
      },
    );

    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> signupWithEmail({
    required String email,
  }) async {
    final response = await _apiClient.post(
      '/auth/signup',
      data: <String, dynamic>{'email': email},
    );
    return UserModel.fromJson(response);
  }
}
