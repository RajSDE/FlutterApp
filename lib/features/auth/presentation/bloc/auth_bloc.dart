import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RequestLoginOtp requestLoginOtp,
    required VerifyLoginOtp verifyLoginOtp,
    required SignupWithEmail signupWithEmail,
  })  : _requestLoginOtp = requestLoginOtp,
        _verifyLoginOtp = verifyLoginOtp,
        _signupWithEmail = signupWithEmail,
        super(const AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<SignupRequested>(_onSignupRequested);
  }

  final RequestLoginOtp _requestLoginOtp;
  final VerifyLoginOtp _verifyLoginOtp;
  final SignupWithEmail _signupWithEmail;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _requestLoginOtp(phoneNumber: event.phoneNumber);
    emit(
      result.when(
        success: (_) => OtpSent(event.phoneNumber),
        failure: (message) => AuthFailure(message),
      ),
    );
  }

  Future<void> _onOtpVerificationRequested(
    OtpVerificationRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading(isOtpStep: true));

    final result = await _verifyLoginOtp(
      phoneNumber: event.phoneNumber,
      otp: event.otp,
    );
    emit(
      result.when(
        success: AuthAuthenticated.new,
        failure: (message) => AuthFailure(message, isOtpStep: true),
      ),
    );
  }

  Future<void> _onSignupRequested(
    SignupRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _signupWithEmail(email: event.email);
    emit(
      result.when(
        success: AuthAuthenticated.new,
        failure: AuthFailure.new,
      ),
    );
  }
}
