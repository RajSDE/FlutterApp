import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_dummy_id.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_mobile_and_password.dart';
import 'package:flutter_app/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
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
  })  : _loginWithDummyId = loginWithDummyId,
        _requestLoginOtp = requestLoginOtp,
        _verifyLoginOtp = verifyLoginOtp,
        _registerUser = registerUser,
        _loginWithMobileAndPassword = loginWithMobileAndPassword,
        super(const AuthInitial()) {
    on<DummyLoginRequested>(_onDummyLoginRequested);
    on<LoginRequested>(_onLoginRequested);
    on<OtpVerificationRequested>(_onOtpVerificationRequested);
    on<SignupRequested>(_onSignupRequested);
    on<LoginWithPasswordRequested>(_onLoginWithPasswordRequested);
  }

  final LoginWithDummyId _loginWithDummyId;
  final RequestLoginOtp _requestLoginOtp;
  final VerifyLoginOtp _verifyLoginOtp;
  final RegisterUser _registerUser;
  final LoginWithMobileAndPassword _loginWithMobileAndPassword;

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
    emit(
      result.when(
        success: AuthRegistered.new,
        failure: AuthFailure.new,
      ),
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
}
