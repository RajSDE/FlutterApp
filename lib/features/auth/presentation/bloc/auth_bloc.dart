import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_dummy_id.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_mobile_and_password.dart';
import 'package:flutter_app/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/send_identifier_verification.dart';
import 'package:flutter_app/features/auth/domain/usecases/validate_identifier_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required LoginWithDummyId loginWithDummyId,
    required RequestLoginOtp requestLoginOtp,
    required VerifyLoginOtp verifyLoginOtp,
    required RegisterUser registerUser,
    required LoginWithMobileAndPassword loginWithMobileAndPassword,
    required SendIdentifierVerification sendIdentifierVerification,
    required ValidateIdentifierOtp validateIdentifierOtp,
  })  : _loginWithDummyId = loginWithDummyId,
        _requestLoginOtp = requestLoginOtp,
        _verifyLoginOtp = verifyLoginOtp,
        _registerUser = registerUser,
        _loginWithMobileAndPassword = loginWithMobileAndPassword,
        _sendIdentifierVerification = sendIdentifierVerification,
        _validateIdentifierOtp = validateIdentifierOtp,
        super(const AuthInitial()) {
    on<DummyLoginRequested>(_onDummyLoginRequested);
    on<LoginRequested>(_onLoginRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LoginWithPasswordRequested>(_onLoginWithPasswordRequested);
    on<VerificationCompleted>(_onVerificationCompleted);
    on<SendVerificationCodeRequested>(_onSendVerificationCodeRequested);
    on<ValidateVerificationOtpRequested>(_onValidateVerificationOtpRequested);
  }

  final LoginWithDummyId _loginWithDummyId;
  final RequestLoginOtp _requestLoginOtp;
  final VerifyLoginOtp _verifyLoginOtp;
  final RegisterUser _registerUser;
  final LoginWithMobileAndPassword _loginWithMobileAndPassword;
  final SendIdentifierVerification _sendIdentifierVerification;
  final ValidateIdentifierOtp _validateIdentifierOtp;

  /// Stores the authenticated state so we can restore it after verification
  AuthState? _savedAuthState;

  Future<void> _onDummyLoginRequested(
    DummyLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginWithDummyId(dummyUserId: event.dummyUserId);
    emit(
      result.when(
        success: AuthAuthenticated.new,
        failure: AuthFailure.new,
      ),
    );
  }

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

    final result = await _registerUser(request: event.request);

    await result.when(
      success: (registrationResult) async {
        final loginResult = await _loginWithMobileAndPassword(
          mobileNumber: event.request.mobileNumber,
          password: event.request.password,
        );
        emit(
          loginResult.when(
            success: (user) => AuthAuthenticated(user),
            failure: (message) => AuthFailure(message),
          ),
        );
      },
      failure: (message) async {
        emit(AuthFailure(message));
      },
    );
  }

  Future<void> _onLoginWithPasswordRequested(
    LoginWithPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _loginWithMobileAndPassword(
      mobileNumber: event.mobileNumber,
      password: event.password,
    );
    emit(
      result.when(
        success: AuthAuthenticated.new,
        failure: AuthFailure.new,
      ),
    );
  }

  Future<void> _onVerificationCompleted(
    VerificationCompleted event,
    Emitter<AuthState> emit,
  ) async {
    // Restore saved auth state if available, otherwise use current state
    final authState = _savedAuthState ?? state;
    if (authState is AuthAuthenticated) {
      final updatedUser = authState.user.copyWith(
        email: event.isEmail ? event.newValue : authState.user.email,
        mobileNumber:
            !event.isEmail ? event.newValue : authState.user.mobileNumber,
        emailVerified: event.isEmail ? 'Y' : authState.user.emailVerified,
        mobileNumberVerified:
            !event.isEmail ? 'Y' : authState.user.mobileNumberVerified,
      );
      _savedAuthState = null;
      emit(AuthAuthenticated(updatedUser));
    }
  }

  Future<void> _onSendVerificationCodeRequested(
    SendVerificationCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    // Save current auth state before emitting verification-specific states
    if (state is AuthAuthenticated) {
      _savedAuthState = state;
    }
    emit(const AuthLoading());

    final result = await _sendIdentifierVerification(
      identifierType: event.identifierType,
      identifierValue: event.identifierValue,
    );
    emit(
      result.when(
        success: VerificationCodeSent.new,
        failure: VerificationFailure.new,
      ),
    );
  }

  Future<void> _onValidateVerificationOtpRequested(
    ValidateVerificationOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await _validateIdentifierOtp(
      uniqueId: event.uniqueId,
      otp: event.otp,
    );
    emit(
      result.when(
        success: (_) => VerificationOtpValidated(
          isEmail: event.isEmail,
          identifierValue: event.identifierValue,
        ),
        failure: VerificationFailure.new,
      ),
    );
  }
}
