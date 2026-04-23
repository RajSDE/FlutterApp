import 'package:flutter_app/core/network/api_client.dart';
import 'package:flutter_app/core/utils/constants.dart';
import 'package:flutter_app/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  final ApiClient _apiClient;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      AppConstants.loginEndpoint,
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    );

    return UserModel.fromJson(response);
  }
}
