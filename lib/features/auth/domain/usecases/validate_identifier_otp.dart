import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class ValidateIdentifierOtp {
  ValidateIdentifierOtp(this._repository);

  final AuthRepository _repository;

  Future<Result<Unit>> call({
    required String uniqueId,
    required String otp,
  }) {
    return _repository.validateIdentifierOtp(
      uniqueId: uniqueId,
      otp: otp,
    );
  }
}
