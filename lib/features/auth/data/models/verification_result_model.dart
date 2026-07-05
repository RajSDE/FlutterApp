import 'package:flutter_app/features/auth/domain/entities/verification_result.dart';

class VerificationResultModel extends VerificationResult {
  const VerificationResultModel({
    required super.uniqueId,
    required super.message,
  });

  factory VerificationResultModel.fromJson(Map<String, dynamic> json) {
    return VerificationResultModel(
      uniqueId: json['uniqueId'] as String? ?? '',
      message: json['message'] as String? ?? '',
    );
  }
}
