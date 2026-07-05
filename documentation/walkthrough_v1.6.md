# Walkthrough v1.6 - Identifier Verification & OTP Validation API Integration

Integrated the `identifier-verification` and `validate-otp` backend APIs across the full clean architecture stack, replacing the previously simulated verification flows with real API calls.

---

## Technical Changes

### 1. API Endpoint Constants
- **[api_endpoints.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/environment/api_endpoints.dart)**: Added `identifierVerification` (`/v1/user/identifier-verification`) and `validateOtp` (`/v1/user/validate-otp`).

---

### 2. Domain Layer

#### Use Cases (NEW)
- **[send_identifier_verification.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/domain/usecases/send_identifier_verification.dart)**: `SendIdentifierVerification` — delegates `identifierType` (`MOBILE`/`EMAIL`) and `identifierValue` to the repository. Returns `Result<String>` with the `uniqueId` on success.
- **[validate_identifier_otp.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/domain/usecases/validate_identifier_otp.dart)**: `ValidateIdentifierOtp` — delegates `uniqueId` and `otp` to the repository. Returns `Result<Unit>` on success.

#### Repository Interface
- **[auth_repository.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/domain/repositories/auth_repository.dart)**: Added `sendIdentifierVerification()` and `validateIdentifierOtp()` abstract methods.

---

### 3. Data Layer

#### Remote Datasource
- **[auth_remote_datasource.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/data/datasource/auth_remote_datasource.dart)**: Added interface and implementation for both endpoints using `ApiClient.post()`. The `sendIdentifierVerification` returns `uniqueId` from the response; `validateIdentifierOtp` is a fire-and-forget call.

#### Repository Implementation
- **[auth_repository_impl.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/data/repositories/auth_repository_impl.dart)**: Added try/catch wrappers for both new datasource methods, returning typed `Result<T>` values.

---

### 4. Presentation Layer

#### Events
- **[auth_event.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/bloc/auth_event.dart)**: Added `SendVerificationCodeRequested` and `ValidateVerificationOtpRequested` events.

#### States
- **[auth_state.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/bloc/auth_state.dart)**: Added `VerificationCodeSent` (carries `uniqueId`), `VerificationOtpValidated` (carries `isEmail` and `identifierValue`), and `VerificationFailure` (carries error `message`).

#### BLoC
- **[auth_bloc.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/bloc/auth_bloc.dart)**: Registered handlers for the two new events. Uses `_savedAuthState` to preserve the `AuthAuthenticated` state during verification flows, restoring it after successful `VerificationCompleted`.

#### Verification Screen
- **[verification_screen.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/screens/verification_screen.dart)**: Completely rewired to use `BlocListener<AuthBloc, AuthState>` instead of simulated `Future.delayed` calls. Send Code dispatches `SendVerificationCodeRequested`, Verify dispatches `ValidateVerificationOtpRequested`, and successful OTP validation fires `VerificationCompleted` to update the user profile.

---

### 5. Dependency Injection
- **[injection_container.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/di/injection_container.dart)**: Registered `SendIdentifierVerification` and `ValidateIdentifierOtp` use cases and passed them to `AuthBloc` factory.

### 6. Mock Backend
- **[mock_backend_interceptor.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/network/interceptors/mock_backend_interceptor.dart)**: Added mock handlers for `/v1/user/identifier-verification` and `/v1/user/validate-otp`.

### 7. Test Updates
- **[auth_bloc_test.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/test/features/auth/presentation/bloc/auth_bloc_test.dart)**: Added mock classes for `SendIdentifierVerification` and `ValidateIdentifierOtp` and passed them to the `buildBloc()` helper.

---

## API Contract Reference

### Send Verification Code
```
POST /v1/user/identifier-verification
Headers: X-Tenant-Id: DEFAULT
Body: { "identifierType": "MOBILE" | "EMAIL", "identifierValue": "<value>" }
Success: { "status": "SUCCESS", "uniqueId": "<uuid>" }
```

### Validate OTP
```
POST /v1/user/validate-otp
Headers: X-Tenant-Id: DEFAULT
Body: { "uniqueId": "<uuid>", "otp": "<6-digit-code>" }
Success: { "status": "SUCCESS", "message": "OTP verified successfully" }
Failures: INVALID_OTP, OTP_MAX_ATTEMPTS_EXCEEDED
```

---

## Verification Results

### Automated Unit Tests
All 10 tests pass with 100% success:
```
00:01 +10: All tests passed!
```
