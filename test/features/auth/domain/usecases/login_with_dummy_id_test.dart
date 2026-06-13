import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/user.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/login_with_dummy_id.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late LoginWithDummyId useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = LoginWithDummyId(repository);
  });

  test('delegates dummy login to repository', () async {
    const user = User(
      id: 999,
      name: 'Demo Shopper',
      email: 'demo-user-001@demo.quickcommerce',
      token: 'token',
      refreshToken: 'refresh-token',
    );
    when(
      () => repository.loginWithDummyId(dummyUserId: 'demo-user-001'),
    ).thenAnswer((_) async => const Success<User>(user));

    final result = await useCase(dummyUserId: 'demo-user-001');

    expect(result, isA<Success<User>>());
    verify(
      () => repository.loginWithDummyId(dummyUserId: 'demo-user-001'),
    ).called(1);
  });
}
