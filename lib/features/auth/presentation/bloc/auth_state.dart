import 'package:equatable/equatable.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading({
    this.isOtpStep = false,
  });

  final bool isOtpStep;

  @override
  List<Object?> get props => <Object?>[isOtpStep];
}

class OtpSent extends AuthState {
  const OtpSent(this.phoneNumber);

  final String phoneNumber;

  @override
  List<Object?> get props => <Object?>[phoneNumber];
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => <Object?>[user];
}

class AuthRegistered extends AuthState {
  const AuthRegistered(this.registrationResult);

  final RegistrationResult registrationResult;

  @override
  List<Object?> get props => <Object?>[registrationResult];
}

class AuthFailure extends AuthState {
  const AuthFailure(
    this.message, {
    this.isOtpStep = false,
  });

  final String message;
  final bool isOtpStep;

  @override
  List<Object?> get props => <Object?>[message, isOtpStep];
}

class VerificationCodeSent extends AuthState {
  const VerificationCodeSent({
    required this.uniqueId,
    required this.message,
  });

  final String uniqueId;
  final String message;

  @override
  List<Object?> get props => <Object?>[uniqueId, message];
}

class VerificationOtpValidated extends AuthState {
  const VerificationOtpValidated({
    required this.isEmail,
    required this.identifierValue,
  });

  final bool isEmail;
  final String identifierValue;

  @override
  List<Object?> get props => <Object?>[isEmail, identifierValue];
}

class VerificationFailure extends AuthState {
  const VerificationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
