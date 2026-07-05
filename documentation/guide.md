# Flutter Enterprise Architecture Guide — Intern Friendly Deep Dive

Welcome! This expanded guide is written for new developers and interns. It explains the project's architecture and provides step-by-step, copy-paste friendly instructions for adding APIs, screens, flows, widgets, and tests. Follow the examples and file paths exactly for quick success.

---

## Quick Navigation
- **Architecture & patterns** — Overview and how files map to responsibilities
- **Core components** — BLoC, Use Cases, Repositories, DataSources, Models
- **Dependency injection (GetIt)** — How and where to register things
- **Networking** — Dio client, interceptors, error handling, retries
- **Auth & Verification flow** — State machine, common pitfalls, and restore
- **Add a new API** — full code recipe (models → UI) with examples
- **Create a new screen** — template, route registration, and navigation
- **Widgets & UI best practices** — stateless/stateful decisions and styling
- **Testing & debugging** — unit, bloc, widget tests and useful tips
- **Onboarding checklist for interns** — short actionable list

---

## 1. Architecture & File Responsibilities (Concrete mapping)

High-level: Clean Architecture + BLoC + GetIt.

- Presentation (UI): `lib/features/<feature>/presentation/`
  - `screens/` — top-level pages
  - `widgets/` — reusable UI pieces
  - `bloc/` — `event.dart`, `state.dart`, `bloc.dart`

- Domain: `lib/features/<feature>/domain/`
  - `entities/` — plain Dart models used across layers
  - `usecases/` — single responsibility classes that call repository contracts
  - `repositories/` — abstract interface contracts

- Data: `lib/features/<feature>/data/`
  - `models/` — JSON (de)serializable classes, conversion to Entities
  - `datasource/` — `remote` and `local` (network, sqlite, secure storage)
  - `repositories/` — implementations of domain repository interfaces

Example mapping for user profile:
- Entity: `lib/features/auth/domain/entities/user.dart`
- Model: `lib/features/auth/data/models/user_model.dart`
- Remote DS: `lib/features/auth/data/datasource/auth_remote_datasource.dart`
- Repo impl: `lib/features/auth/data/repositories/auth_repository_impl.dart`
- Use case: `lib/features/auth/domain/usecases/get_user_profile.dart`
- Bloc: `lib/features/auth/presentation/bloc/auth_bloc.dart`
- Screen: `lib/features/home/presentation/screens/home_screen.dart`

Why this mapping? It keeps the business rules (domain) free of Flutter and HTTP details and makes code easier to test.

---

## 2. Core Component Patterns (with short code snippets)

- Entities: simple immutable classes used in domain layer.
  ```dart
  class User {
    final String userProfileId;
    final String name;
    const User({required this.userProfileId, required this.name});
  }
  ```

- Models: convert JSON to Entities and back.
  ```dart
  class UserModel extends User {
    const UserModel({required super.userProfileId, required super.name});

    factory UserModel.fromJson(Map<String,dynamic> json) => UserModel(
      userProfileId: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
  ```

- Repository interface (domain):
  ```dart
  abstract class AuthRepository {
    Future<Result<User>> getUserProfile(String id);
  }
  ```

- Use case (domain):
  ```dart
  class GetUserProfile {
    final AuthRepository repo;
    GetUserProfile(this.repo);
    Future<Result<User>> call(String id) => repo.getUserProfile(id);
  }
  ```

- BLoC event → use case → emit state pattern:
  - UI dispatches `GetUserProfileRequested(userId)`
  - `AuthBloc` handles event: calls `GetUserProfile(userId)` and emits `AuthAuthenticated` on success or `AuthFailure` on error.

---

## 3. Dependency Injection (GetIt)

- Single place: `lib/core/di/injection_container.dart` where you `registerLazySingleton` or `registerFactory`.
  - Use `registerLazySingleton` for long lived singletons (network client, use-cases)
  - Use `registerFactory` for Blocs so each widget gets its own instance

Example registrations:
```dart
final sl = GetIt.instance;
void init() {
  // external
  sl.registerLazySingleton(() => Dio());

  // data
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(sl()));

  // repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remote: sl()));

  // use cases
  sl.registerLazySingleton(() => GetUserProfile(sl()));

  // bloc
  sl.registerFactory(() => AuthBloc(getUserProfile: sl(), ...));
}
```

Best practice: keep the container small and split into modules per feature when the app grows.

---

## 4. Networking (Dio, Interceptors, Error Handling)

- Central client: `lib/core/network/network_service.dart` or similar.
- Interceptors:
  - `auth_interceptor.dart` — attaches `Authorization` headers
  - `logging_interceptor.dart` — logs requests/responses during debug
  - `mock_backend_interceptor.dart` — used in dev for local fake responses

Sample interceptor usage:
```dart
dio.interceptors.add(AuthInterceptor(secureStorage));
dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
```

Error handling pattern:
- In remote datasource, wrap network calls in `try/catch` and map DioError to domain `Failure` objects.
- Return a simple `Result<T>` (success/failure) from repository to use-cases for deterministic control flow.

Retries and timeouts:
- Use Dio `Options` and custom retry interceptor for idempotent calls. Keep retry count small (2-3).

---

## 5. Auth & Verification Flow (detailed)

Key states we use in `AuthBloc` (examples):
- `AuthInitial`, `AuthLoading`, `AuthAuthenticated`, `OtpSent`, `VerificationCodeSent`, `VerificationOtpValidated`, `AuthFailure`.

Flow for identifier verification (email or phone):
1. UI dispatches `SendVerificationCodeRequested(identifierType, identifierValue)`
2. `AuthBloc` saves the current `AuthAuthenticated` state into a private variable `_savedAuthState` and emits `VerificationCodeSent` on success
3. UI shows OTP input; if the user completes OTP, `ValidateVerificationOtpRequested` is sent → `VerificationOtpValidated` → `VerificationCompleted` event updates user
4. If the user cancels/back before OTP, we must restore `_savedAuthState` by dispatching `RestorePreviousAuthStateRequested`

Common pitfall: using stub/dummy fallback values in the profile UI when `AuthAuthenticated` is missing. Always prefer: show loader or an explicit non-authenticated placeholder.

Why we save state before verification: the verification step is transient; you must not destroy the user's authenticated session while verifying an identifier.

Implementation note (PopScope):
- Newer Flutter uses `PopScope` for system back gestures; use `onPopInvokedWithResult` to be notified after pop and restore the auth state there.

---

## 6. Add a New API — Full Recipe (copy-paste friendly)

Goal: Add endpoint `/v1/user/profile` that returns user profile.

Step 0: Contract & Spec
- Confirm request/response JSON keys with backend. Example response:
```json
{
  "id": "abc",
  "name": "Jane",
  "email": "jane@example.com",
  "mobileNumber": "9999999999",
  "emailVerified": "Y"
}
```

Step 1: Add endpoint constant
- Edit `lib/config/environment/api_endpoints.dart`:
```dart
static const String userProfile = '/v1/user/{id}';
```

Step 2: Data model
- Create `lib/features/auth/data/models/user_profile_model.dart`:
```dart
class UserProfileModel extends User {
  const UserProfileModel({required super.userProfileId, required super.name, required super.email});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) => UserProfileModel(
    userProfileId: json['id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );
}
```

Step 3: Remote datasource
- Add method in `auth_remote_datasource.dart`:
```dart
Future<UserProfileModel> fetchUserProfile(String id) async {
  final res = await _networkService.get('/v1/user/$id');
  return UserProfileModel.fromJson(res as Map<String, dynamic>);
}
```

Step 4: Repository
- Add to `lib/features/auth/domain/repositories/auth_repository.dart`:
```dart
Future<Result<User>> getUserProfile({required String userProfileId});
```
- Implement in `auth_repository_impl.dart` using the new datasource. Map model → entity.

Step 5: Use-case
- Create `lib/features/auth/domain/usecases/get_user_profile.dart`:
```dart
class GetUserProfile {
  final AuthRepository repo;
  GetUserProfile(this.repo);
  Future<Result<User>> call({required String userProfileId}) => repo.getUserProfile(userProfileId: userProfileId);
}
```

Step 6: Register DI
- Add `sl.registerLazySingleton(() => GetUserProfile(sl()));` to `injection_container.dart`.

Step 7: BLoC wiring (example event & handler)
- Event: `RefreshUserProfileRequested(userProfileId)`
- Handler: call `_getUserProfile(userProfileId)`, merge fields with current user, emit updated `AuthAuthenticated`.

Step 8: UI call sites
- When entering profile screen: if state `AuthAuthenticated`, call `RefreshUserProfileRequested(userId)`
- When returning from verification flow, check if `AuthAuthenticated` then call refresh.

Step 9: Test
- Unit test the use-case mocking repository; widget/bloc tests for the flow.

---

## 7. Create a New Screen — Developer Template

File location: `lib/features/<feature>/presentation/screens/<name>_screen.dart`

Simple template:
```dart
import 'package:flutter/material.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Example')),
    body: const Center(child: Text('Hello')),
  );
}
```

Routing: add a route constant to `lib/config/routes/app_router.dart` and handle it in `onGenerateRoute`.

Navigation: prefer typed `arguments` objects rather than loose maps.

---

## 8. Widgets & UI Best Practices

- Prefer small, composable widgets: a widget should do one thing and do it well.
- Use `StatelessWidget` unless you need lifecycle or local mutable state; prefer `Provider`/`Bloc` for shared state.
- Reuse `authInputDecoration()` and theme tokens from `shared/theme`.
- Accessibility: always provide `semanticsLabel` for icons used as meaningful UI.

Performance tips:
- Avoid rebuilding large subtrees. Use `const` where possible.
- Use `BlocBuilder` selectively (scope to the subtree that needs the state).

---

## 9. Testing & Debugging

Unit test flow:
- Use `mockito` or `mocktail` to mock repositories and datasources.
- Test Use Cases in isolation (mock the repo)
- Test Bloc: feed events and assert state sequences

Widget tests:
- Pump the widget wrapped in `BlocProvider` with mocked BLoC.

Manual debugging tips:
- Use `flutter run` with `--verbose` to inspect logs
- Add `LogInterceptor` to Dio in dev
- Use the `debugPrintRebuildDirtyWidgets` option when chasing rebuilds

---

## 10. Onboarding checklist for interns

1. Run the app: install dependencies and launch the app on a device/emulator:
```bash
flutter pub get
flutter run -d <device>
```
2. Find `AuthBloc` and follow the verification flow in code
3. Add a small unit test for a use-case to get comfortable with tooling
4. Update a UI string via `lib/l10n/app_en.arb` and run `flutter gen-l10n`

---

If you want, I can also:
- generate a ready-to-use example feature repository branch
- add tests for `GetUserProfile`
- create a PR-ready checklist for code review

End of guide.
