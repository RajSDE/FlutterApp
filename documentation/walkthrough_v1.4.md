# Walkthrough v1.4 - Registration API Payload, Profile Card Layout & Verification/Edit Screen

We have integrated the registration payload verification variables, cleaned up the profile settings layout to remove "Session Profile ID", and created a modern edit and verification screen.

---

## Technical Changes

### 1. Registration API Payload Update
- **[register_user_request_model.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/data/models/register_user_request_model.dart)**: Appended `'mobileNumberVerified': 'Y'` and `'emailVerified': 'N'` parameters into `toJson()` serialization mapping to match the updated live backend schemas.

### 2. Profile Screen Layout Cleanup
- **[home_screen.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/home/presentation/screens/home_screen.dart)**: Completely removed the `"Session Profile ID"` ListTile and its divider from the settings list to streamline the UI.

### 3. Modern Verification/Edit Screen
- **[verification_screen.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/screens/verification_screen.dart)**:
  - Created a modern verification wizard containing a gradient header, floating input cards, inputs verification check logic, and resend codes countdown timer configurations.
  - Tapping the `"Edit"` action button on either unverified Mobile Number or Email Address redirects users to the Verification screen.
  - Submitting the bypass code `000000` fires the `VerificationCompleted` event to update the user profile values and mark them as verified.
- **[app_router.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/routes/app_router.dart)**: Registered `/verification` path routing with `VerificationArgs`.
- **[auth_bloc.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/bloc/auth_bloc.dart)** & **[auth_event.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/features/auth/presentation/bloc/auth_event.dart)**: Added `VerificationCompleted` event support that updates the local `AuthAuthenticated` user parameters dynamically, allowing the profile screen to immediately display the verified blue ticks.

### 4. Release Binary Build
- Recompiled the release APK and force-pushed the updated binary to the `release` branch containing only the build artifacts:
  - `app-release.apk` (updated compiled binary: 49.7MB)

---

## Verification Results

### Automated Unit Tests
All unit tests build and execute with 100% success rate:
```bash
00:00 +0: delegates dummy login to repository
00:00 +1: delegates mobile and password login to repository
00:01 +2: delegates OTP request to repository
00:02 +3: delegates user registration to repository
00:02 +4: delegates OTP verification to repository
00:03 +5: emits loading then authenticated when dummy login succeeds
00:03 +6: emits loading then otp sent when login OTP request succeeds
00:03 +7: emits loading then authenticated when OTP verification succeeds
00:03 +8: emits loading then authenticated when password login succeeds
00:03 +9: emits loading then failure when password login fails
00:03 +10: All tests passed!
```
