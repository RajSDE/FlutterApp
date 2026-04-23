import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/signup_with_email.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late SignupWithEmail useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = SignupWithEmail(repository);
  });

  test('delegates signup to repository', () async {
    const user = User(
      id: 1,
      name: 'Tester',
      email: 'tester@example.com',
      token: 'token',
      refreshToken: 'refresh-token',
    );
    when(
      () => repository.signupWithEmail(email: 'tester@example.com'),
    ).thenAnswer((_) async => const Success<User>(user));

    final result = await useCase(email: 'tester@example.com');

    expect(result, isA<Success<User>>());
    verify(() => repository.signupWithEmail(email: 'tester@example.com'))
        .called(1);
  });
}
