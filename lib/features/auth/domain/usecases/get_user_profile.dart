import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';

class GetUserProfile {
  GetUserProfile(this._repository);

  final AuthRepository _repository;

  Future<Result<User>> call({
    required String userProfileId,
  }) {
    return _repository.getUserProfile(
      userProfileId: userProfileId,
    );
  }
}
