import 'package:flutter_app/core/security/secure_storage.dart';
import 'package:flutter_app/core/utils/constants.dart';
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
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final user = await _remoteDataSource.login(
      email: email,
      password: password,
    );

    await _secureStorageService.write(
      key: AppConstants.tokenKey,
      value: user.token,
    );

    return user;
  }
}
