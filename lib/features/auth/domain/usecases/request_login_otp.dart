import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class RequestLoginOtp {
  RequestLoginOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<Unit>> call({
    required String phoneNumber,
  }) {
    return _repository.requestLoginOtp(phoneNumber: phoneNumber);
  }
}
