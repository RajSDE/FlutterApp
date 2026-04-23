import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/request_login_otp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late RequestLoginOtp useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = RequestLoginOtp(repository);
  });

  test('delegates OTP request to repository', () async {
    when(
      () => repository.requestLoginOtp(phoneNumber: '9876543210'),
    ).thenAnswer((_) async => const Success<Unit>(unit));

    final result = await useCase(phoneNumber: '9876543210');

    expect(result, isA<Success<Unit>>());
    verify(() => repository.requestLoginOtp(phoneNumber: '9876543210'))
        .called(1);
  });
}
