import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';

class RegistrationResultModel extends RegistrationResult {
  const RegistrationResultModel({
    required super.traceId,
    required super.status,
    required super.message,
    required super.userProfileId,
    required super.email,
    super.username,
  });

  factory RegistrationResultModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResultModel(
      traceId: json['traceId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      message: json['message'] as String? ?? '',
      userProfileId: json['userProfileId'] as String? ?? '',
      username: json['username'] as String?,
      email: json['email'] as String? ?? '',
    );
  }
}
