import 'package:flutter_app/config/environment/api_endpoints.dart';
import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/features/auth/data/models/register_user_request_model.dart';
import 'package:flutter_app/features/auth/data/models/registration_result_model.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> loginWithDummyId({
    required String dummyUserId,
  });

  Future<void> requestLoginOtp({
    required String phoneNumber,
  });

  Future<UserModel> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  });

  Future<UserModel> loginWithMobileAndPassword({
    required String mobileNumber,
    required String password,
  });

  Future<RegistrationResultModel> registerUser({
    required RegisterUserRequest request,
  });

  Future<UserModel> getUserProfile({required String userProfileId});

  Future<String> sendIdentifierVerification({
    required String identifierType,
    required String identifierValue,
  });

  Future<void> validateIdentifierOtp({
    required String uniqueId,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserModel> loginWithDummyId({
    required String dummyUserId,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.dummyLogin,
      data: <String, dynamic>{'dummyUserId': dummyUserId},
    );

    return UserModel.fromJson(response);
  }

  @override
  Future<void> requestLoginOtp({
    required String phoneNumber,
  }) async {
    await _apiClient.post(
      ApiEndpoints.requestOtp,
      data: <String, dynamic>{'phone': phoneNumber},
    );
  }

  @override
  Future<UserModel> verifyLoginOtp({
    required String phoneNumber,
    required String otp,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.verifyOtp,
      data: <String, dynamic>{
        'phone': phoneNumber,
        'otp': otp,
      },
    );

    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> loginWithMobileAndPassword({
    required String mobileNumber,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.loginUser,
      data: <String, dynamic>{
        'mobileNumber': mobileNumber,
        'password': password,
      },
      headers: <String, dynamic>{
        'X-Tenant-Id': 'DEFAULT',
      },
    );

    return UserModel.fromJson(response);
  }

  @override
  Future<RegistrationResultModel> registerUser({
    required RegisterUserRequest request,
  }) async {
    final model = RegisterUserRequestModel.fromEntity(request);
    final response = await _apiClient.post(
      ApiEndpoints.registerUser,
      data: model.toJson(),
      headers: <String, dynamic>{
        'Accept-Language': request.preferredLanguage,
        'X-Tenant-Id': 'DEFAULT',
      },
    );
    return RegistrationResultModel.fromJson(response);
  }

  @override
  Future<UserModel> getUserProfile({required String userProfileId}) async {
    final response = await _apiClient.get(
      '/v1/user/$userProfileId',
    );
    return UserModel.fromJson(response);
  }

  @override
  Future<String> sendIdentifierVerification({
    required String identifierType,
    required String identifierValue,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.identifierVerification,
      data: <String, dynamic>{
        'identifierType': identifierType,
        'identifierValue': identifierValue,
      },
      headers: <String, dynamic>{
        'X-Tenant-Id': 'DEFAULT',
      },
    );
    return response['uniqueId'] as String;
  }

  @override
  Future<void> validateIdentifierOtp({
    required String uniqueId,
    required String otp,
  }) async {
    await _apiClient.post(
      ApiEndpoints.validateOtp,
      data: <String, dynamic>{
        'uniqueId': uniqueId,
        'otp': otp,
      },
      headers: <String, dynamic>{
        'X-Tenant-Id': 'DEFAULT',
      },
    );
  }
}
