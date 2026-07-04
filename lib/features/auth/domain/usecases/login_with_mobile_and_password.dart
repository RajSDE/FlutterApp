import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class LoginWithMobileAndPassword {
  LoginWithMobileAndPassword(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call({
    required String mobileNumber,
    required String password,
  }) {
    return _repository.loginWithMobileAndPassword(
      mobileNumber: mobileNumber,
      password: password,
    );
  }
}
