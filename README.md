# Flutter App Quick Setup

This project is a Flutter application with a clean folder structure and an auth starter flow.

## 1. Open the project

```powershell
cd C:\Users\heyra\AndroidStudioProjects\FultterApp
```

Use this when you want to work from the project folder before running any Flutter command.

## 2. Check Flutter installation

```powershell
flutter doctor
```

Use this to verify whether Flutter, Android SDK, licenses, Chrome, and desktop tooling are correctly installed.

## 3. Enable Windows Developer Mode

```powershell
start ms-settings:developers
```

Use this when Flutter shows:

`Building with plugins requires symlink support.`

After opening Settings:

1. Turn on `Developer Mode`
2. Accept the prompt
3. Retry the Flutter command

## 4. Create missing platform files

```powershell
flutter create .
```

Use this when the project only has Dart files like `lib/` and `pubspec.yaml`, but is missing Flutter platform folders such as `android/`, `web/`, or `windows/`.

This command generates the standard Flutter project files in the current folder.

## 5. Install dependencies

```powershell
flutter pub get
```

Use this after creating the project or after changing `pubspec.yaml`.

This downloads and resolves all packages used by the app.

## 6. Accept Android licenses

```powershell
flutter doctor --android-licenses
```

Use this if `flutter doctor` reports:

`Android license status unknown`

This accepts required Android SDK licenses so Android builds can run properly.

## 7. See available emulators

```powershell
flutter emulators
```

Use this to list emulators configured on your system.

## 8. Launch an emulator

```powershell
flutter emulators --launch <emulator-id>
```

Use this to start a saved Android emulator from terminal.

Replace `<emulator-id>` with the emulator ID shown by `flutter emulators`.

## 9. See connected devices

```powershell
flutter devices
```

Use this to check which physical devices, emulators, or web targets Flutter can currently use.

## 10. Run the app

```powershell
flutter run
```

Use this to build and launch the app on the default supported device.

If you want a specific device:

```powershell
flutter run -d emulator-5554
```

Use this to run the app on a specific emulator or device ID.

Other examples:

```powershell
flutter run -d chrome
flutter run -d edge
```

Use these when web support is configured and the browser is available.

## Android Studio note

You can start the emulator from Android Studio and keep only the emulator running.

You do not need to keep Android Studio open after the emulator starts.

## `flutter run` interactive keys

When `flutter run` is active, these keys can be used in the terminal:

`r`
Hot reload.
Use this after small UI or logic changes to update the running app quickly without restarting everything.

`R`
Hot restart.
Use this when a full app restart is needed but you still want faster feedback than stopping and rerunning manually.

`h`
List all available interactive commands.
Use this if you forget the terminal shortcuts available during `flutter run`.

`d`
Detach.
Use this to stop the terminal session but keep the app running on the device.

`c`
Clear the screen.
Use this to clean up terminal output while keeping `flutter run` active.

`q`
Quit.
Use this to stop the running app and end the `flutter run` session.

## Common command flow

For a fresh setup:

```powershell
cd C:\Users\heyra\AndroidStudioProjects\FultterApp
flutter doctor
start ms-settings:developers
flutter create .
flutter pub get
flutter doctor --android-licenses
flutter emulators
flutter devices
flutter run -d emulator-5554
```

For day-to-day development:

```powershell
cd C:\Users\heyra\AndroidStudioProjects\FultterApp
flutter pub get
flutter devices
flutter run -d emulator-5554
```
