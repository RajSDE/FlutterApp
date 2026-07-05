# BUG: Verification Flow State Restore Failure

## Summary
When a user requests a verification code and then cancels or navigates back before completing OTP verification, the app fails to restore the prior authenticated state. As a result, the profile screen can show stale or dummy fallback values instead of the real authenticated user profile.

## Bug Name
`verification-state-restore`

## Impact
- User loses access to the authenticated profile state after beginning verification
- Profile view may display dummy fallback values instead of real user data
- Back navigation from the verification screen does not reliably restore the previous state
- The flow becomes inconsistent and may confuse users who expect to return to the app unchanged

## Root Cause Analysis (RCA)
1. The verification flow transitions the app into a temporary state: `VerificationCodeSent`.
2. The current authenticated state was not reliably restored if the user canceled or used back navigation before OTP validation.
3. The profile view contained fallback defaults (`John Doe`, `john.doe@example.com`, `9631341874`) for non-authenticated states, so stale values could appear when state restoration failed.
4. `verification_screen.dart` attempted to handle back navigation with `PopScope`, but used an incorrect callback parameter (`onPop`), meaning the restore logic was not wired correctly.

## Fix Implemented
### `verification_screen.dart`
- Replaced deprecated `WillPopScope` with the newer `PopScope` widget.
- Used the correct callback parameter: `onPopInvokedWithResult`.
- Added restore logic so when a back navigation occurs and verification is not complete, the app dispatches `RestorePreviousAuthStateRequested()` to `AuthBloc`.
- Preserved the same restore behavior for the top-left cancel button and system/hardware back navigation.

### `home_screen.dart`
- Removed hardcoded dummy fallback profile values.
- Updated the profile view to render only real `AuthAuthenticated.user` data.
- Added a proper safe placeholder for non-authenticated state instead of stale dummy data.
- Kept profile refresh dispatch when returning from verification or selecting the profile tab.

## Why This Fix Works
- It ensures the app returns to a valid authenticated state if verification is abandoned.
- It prevents the profile UI from showing dummy values when auth state is unavailable.
- It makes back navigation behavior consistent and correct during verification.

## Key Concepts Explained
- `WillPopScope`: older Flutter widget used to intercept back navigation and decide whether to allow popping the route.
- `PopScope`: newer Flutter widget for handling back navigation, especially with Android predictive back gestures.
- `AuthAuthenticated`: state representing a logged-in user.
- `VerificationCodeSent`: temporary state during identifier verification.
- `RestorePreviousAuthStateRequested`: event used to restore the last good authenticated state.

## Notes
This document should help developers understand why the bug happened, what changed, and how the fix restores user experience for the verification flow.
