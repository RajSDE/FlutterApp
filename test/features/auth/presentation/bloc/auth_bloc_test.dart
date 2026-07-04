import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_dummy_id.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_mobile_and_password.dart';
import 'package:flutter_app/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestLoginOtp extends Mock implements RequestLoginOtp {}

class _MockLoginWithDummyId extends Mock implements LoginWithDummyId {}

class _MockVerifyLoginOtp extends Mock implements VerifyLoginOtp {}

class _MockRegisterUser extends Mock implements RegisterUser {}

class _MockLoginWithMobileAndPassword extends Mock implements LoginWithMobileAndPassword {}

void main() {
  const user = User(
    id: 1,
    name: 'Tester',
    email: 'tester@example.com',
    token: 'token',
    refreshToken: 'refresh-token',
  );

  late RequestLoginOtp requestLoginOtp;
  late LoginWithDummyId loginWithDummyId;
  late VerifyLoginOtp verifyLoginOtp;
  late RegisterUser registerUser;
  late LoginWithMobileAndPassword loginWithMobileAndPassword;

  setUp(() {
    loginWithDummyId = _MockLoginWithDummyId();
    requestLoginOtp = _MockRequestLoginOtp();
    verifyLoginOtp = _MockVerifyLoginOtp();
    registerUser = _MockRegisterUser();
    loginWithMobileAndPassword = _MockLoginWithMobileAndPassword();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      loginWithDummyId: loginWithDummyId,
      requestLoginOtp: requestLoginOtp,
      verifyLoginOtp: verifyLoginOtp,
      registerUser: registerUser,
      loginWithMobileAndPassword: loginWithMobileAndPassword,
    );
  }

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when dummy login succeeds',
    build: () {
      when(
        () => loginWithDummyId(dummyUserId: 'demo-user-001'),
      ).thenAnswer((_) async => const Success<User>(user));
      return buildBloc();
    },
    act: (bloc) => bloc.add(
      const DummyLoginRequested(dummyUserId: 'demo-user-001'),
    ),
    expect: () => <AuthState>[
      const AuthLoading(),
      const AuthAuthenticated(user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then otp sent when login OTP request succeeds',
    build: () {
      when(
        () => requestLoginOtp(phoneNumber: '9876543210'),
      ).thenAnswer((_) async => const Success<Unit>(unit));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const LoginRequested(phoneNumber: '9876543210')),
    expect: () => <AuthState>[
      const AuthLoading(),
      const OtpSent('9876543210'),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when OTP verification succeeds',
    build: () {
      when(
        () => verifyLoginOtp(phoneNumber: '9876543210', otp: '123456'),
      ).thenAnswer((_) async => const Success<User>(user));
      return buildBloc();
    },
    act: (bloc) => bloc.add(
      const OtpVerificationRequested(
        phoneNumber: '9876543210',
        otp: '123456',
      ),
    ),
    expect: () => <AuthState>[
      const AuthLoading(isOtpStep: true),
      const AuthAuthenticated(user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then authenticated when password login succeeds',
    build: () {
      when(
        () => loginWithMobileAndPassword(
          mobileNumber: '+1234567890',
          password: 'SecurePassword123!',
        ),
      ).thenAnswer((_) async => const Success<User>(user));
      return buildBloc();
    },
    act: (bloc) => bloc.add(
      const LoginWithPasswordRequested(
        mobileNumber: '+1234567890',
        password: 'SecurePassword123!',
      ),
    ),
    expect: () => <AuthState>[
      const AuthLoading(),
      const AuthAuthenticated(user),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'emits loading then failure when password login fails',
    build: () {
      when(
        () => loginWithMobileAndPassword(
          mobileNumber: '+1234567890',
          password: 'WrongPassword',
        ),
      ).thenAnswer((_) async => const Error<User>('errorLoginFailed'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(
      const LoginWithPasswordRequested(
        mobileNumber: '+1234567890',
        password: 'WrongPassword',
      ),
    ),
    expect: () => <AuthState>[
      const AuthLoading(),
      const AuthFailure('errorLoginFailed'),
    ],
  );
}
