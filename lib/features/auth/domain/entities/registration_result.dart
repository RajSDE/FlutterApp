import 'package:equatable/equatable.dart';

class RegistrationResult extends Equatable {
  const RegistrationResult({
    required this.traceId,
    required this.status,
    required this.message,
    required this.userProfileId,
    required this.email,
    this.username,
  });

  final String traceId;
  final String status;
  final String message;
  final String userProfileId;
  final String? username;
  final String email;

  @override
  List<Object?> get props {
    return <Object?>[
      traceId,
      status,
      message,
      userProfileId,
      username,
      email,
    ];
  }
}
