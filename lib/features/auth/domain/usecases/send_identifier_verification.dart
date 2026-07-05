import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class SendIdentifierVerification {
  SendIdentifierVerification(this._repository);

  final AuthRepository _repository;

  Future<Result<String>> call({
    required String identifierType,
    required String identifierValue,
  }) {
    return _repository.sendIdentifierVerification(
      identifierType: identifierType,
      identifierValue: identifierValue,
    );
  }
}
