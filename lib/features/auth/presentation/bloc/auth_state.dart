import 'package:equatable/equatable.dart';
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
