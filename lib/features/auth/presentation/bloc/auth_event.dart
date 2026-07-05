import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

class DummyLoginRequested extends AuthEvent {
  const DummyLoginRequested({
    required this.dummyUserId,
  });

  final String dummyUserId;

  @override
  List<Object?> get props => <Object?>[dummyUserId];
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
    required this.request,
  });

  final RegisterUserRequest request;

  @override
  List<Object?> get props => <Object?>[request];
}

class LoginWithPasswordRequested extends AuthEvent {
  const LoginWithPasswordRequested({
    required this.mobileNumber,
    required this.password,
  });

  final String mobileNumber;
  final String password;

  @override
  List<Object?> get props => <Object?>[mobileNumber, password];
}

class VerificationCompleted extends AuthEvent {
  const VerificationCompleted({
    required this.isEmail,
    required this.newValue,
  });

  final bool isEmail;
  final String newValue;

  @override
  List<Object?> get props => <Object?>[isEmail, newValue];
}
