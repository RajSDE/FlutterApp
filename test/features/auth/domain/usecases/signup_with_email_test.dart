import 'package:flutter_app/core/result/result.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
import 'package:flutter_app/features/auth/domain/entities/registration_result.dart';
import 'package:flutter_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_app/features/auth/domain/usecases/register_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late AuthRepository repository;
  late RegisterUser useCase;

  setUp(() {
    repository = _MockAuthRepository();
    useCase = RegisterUser(repository);
  });

  test('delegates user registration to repository', () async {
    const request = RegisterUserRequest(
      username: 'john_doe',
      email: 'john.doe@example.com',
      password: 'SecurePassword123!',
      firstName: 'John',
      lastName: 'Doe',
      mobileNumber: '+1234567890',
      preferredLanguage: 'en',
      gender: 'MALE',
    );

    const expectedResult = RegistrationResult(
      traceId: 'trace-123',
      status: 'SUCCESS',
      message: 'Registration successful',
      userProfileId: 'profile-123',
      username: 'john_doe',
      email: 'john.doe@example.com',
    );

    when(
      () => repository.registerUser(request: request),
    ).thenAnswer((_) async => const Success<RegistrationResult>(expectedResult));

    final result = await useCase(request: request);

    expect(result, isA<Success<RegistrationResult>>());
    verify(() => repository.registerUser(request: request)).called(1);
  });
}
