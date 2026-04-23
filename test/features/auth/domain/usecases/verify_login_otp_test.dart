import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/verify_login_otp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late VerifyLoginOtp useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = VerifyLoginOtp(repository);
  });

  test('delegates OTP verification to repository', () async {
    const user = User(
      id: 1,
      name: 'Tester',
      email: 'tester@example.com',
      token: 'token',
      refreshToken: 'refresh-token',
    );
    when(
      () => repository.verifyLoginOtp(
        phoneNumber: '9876543210',
        otp: '123456',
      ),
    ).thenAnswer((_) async => const Success<User>(user));

    final result = await useCase(
      phoneNumber: '9876543210',
      otp: '123456',
    );

    expect(result, isA<Success<User>>());
    verify(
      () => repository.verifyLoginOtp(
        phoneNumber: '9876543210',
        otp: '123456',
      ),
    ).called(1);
  });
}
