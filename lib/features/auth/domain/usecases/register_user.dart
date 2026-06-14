import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser {
  RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<Result<RegistrationResult>> call({
    required RegisterUserRequest request,
  }) {
    return _repository.registerUser(request: request);
  }
}
