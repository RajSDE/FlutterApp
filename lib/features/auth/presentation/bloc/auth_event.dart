import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginRequested extends AuthEvent {
  const LoginRequested({
    required this.phoneNumber,
  });

  final String phoneNumber;

  @override
  List<Object?> get props => <Object?>[phoneNumber];
}

class OtpVerificationRequested extends AuthEvent {
  const OtpVerificationRequested({
    required this.phoneNumber,
    required this.otp,
  });

  final String phoneNumber;
  final String otp;

  @override
  List<Object?> get props => <Object?>[phoneNumber, otp];
}

class SignupRequested extends AuthEvent {
  const SignupRequested({
    required this.email,
  });

  final String email;

  @override
  List<Object?> get props => <Object?>[email];
}
