import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_mobile_and_password.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late LoginWithMobileAndPassword useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = LoginWithMobileAndPassword(repository);
  });

  test('delegates mobile and password login to repository', () async {
    const user = User(
      id: 100,
      name: 'John Doe',
      email: 'john.doe@example.com',
      token: 'token',
      refreshToken: 'refresh-token',
    );
    when(
      () => repository.loginWithMobileAndPassword(
        mobileNumber: '+1234567890',
        password: 'SecurePassword123!',
      ),
    ).thenAnswer((_) async => const Success<User>(user));

    final result = await useCase(
      mobileNumber: '+1234567890',
      password: 'SecurePassword123!',
    );

    expect(result, isA<Success<User>>());
    verify(
      () => repository.loginWithMobileAndPassword(
        mobileNumber: '+1234567890',
        password: 'SecurePassword123!',
      ),
    ).called(1);
  });
}
