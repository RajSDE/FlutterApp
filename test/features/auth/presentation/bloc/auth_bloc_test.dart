import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_dummy_id.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRequestLoginOtp extends Mock implements RequestLoginOtp {}

class _MockLoginWithDummyId extends Mock implements LoginWithDummyId {}

class _MockVerifyLoginOtp extends Mock implements VerifyLoginOtp {}

class _MockSignupWithEmail extends Mock implements SignupWithEmail {}

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
  late SignupWithEmail signupWithEmail;

  setUp(() {
    loginWithDummyId = _MockLoginWithDummyId();
    requestLoginOtp = _MockRequestLoginOtp();
    verifyLoginOtp = _MockVerifyLoginOtp();
    signupWithEmail = _MockSignupWithEmail();
  });

  AuthBloc buildBloc() {
    return AuthBloc(
      loginWithDummyId: loginWithDummyId,
      requestLoginOtp: requestLoginOtp,
      verifyLoginOtp: verifyLoginOtp,
      signupWithEmail: signupWithEmail,
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
    'emits loading then failure when signup fails',
    build: () {
      when(
        () => signupWithEmail(email: 'bad-email'),
      ).thenAnswer((_) async => const Error<User>('errorInvalidEmail'));
      return buildBloc();
    },
    act: (bloc) => bloc.add(const SignupRequested(email: 'bad-email')),
    expect: () => <AuthState>[
      const AuthLoading(),
      const AuthFailure('errorInvalidEmail'),
    ],
  );
}
