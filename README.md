# Release Artifacts

This branch contains **only** the compiled release APK artifacts. It is automatically updated when a successful build completes on the `main` branch.

> **Do not commit source code to this branch.**

## Current Artifacts

| File | Platform | Build Type |
|------|----------|------------|
| `app-release.apk` | Android | Release |

## How It Works

1. Code changes are pushed to `main`.
2. CI pipeline runs tests and `dart format` checks.
3. On successful build, `flutter build apk --release` is executed.
4. The resulting APK is committed to this `release` branch (orphan, no source code history).

## Download

Download the latest APK directly:
- [app-release.apk](./app-release.apk)
