# Flutter Enterprise Architecture Guide

Welcome to the **Quick Commerce Flutter Application** technical guide. This document is designed to help new team members quickly understand the project's architecture, patterns, and workflows, enabling a seamless development experience.

---

## Table of Contents
1. [Architecture Overview](#1-architecture-overview)
2. [Constants & Configuration](#2-constants--configuration)
3. [Changing Strings & Localization (i18n)](#3-changing-strings--localization-i18n)
4. [Adding a Field to a Model/Form](#4-adding-a-field-to-a-modelform)
5. [Creating a Screen & Registering Routes](#5-creating-a-screen--registering-routes)
6. [Integrating a New API](#6-integrating-a-new-api)
7. [Authentication & Token Management](#7-authentication--token-management)
8. [Creating a New Feature](#8-creating-a-new-feature)

---

## 1. Architecture Overview

This project adheres to **Clean Architecture** combined with **BLoC (Business Logic Component)** for state management and **GetIt** for Dependency Injection. The codebase is modularized by features, located under `lib/features/`.

Each feature is divided into three layers:

```
                  ┌─────────────────────────────────┐
                  │       PRESENTATION LAYER        │
                  │  (UI Screens, Widgets, BLoCs)   │
                  └────────────────┬────────────────┘
                                   │ Dispatches events / Observes states
                                   ▼
                  ┌─────────────────────────────────┐
                  │          DOMAIN LAYER           │
                  │   (Entities, Use Cases, Repos)  │
                  └────────────────┬────────────────┘
                                   │ Invokes contracts
                                   ▼
                  ┌─────────────────────────────────┐
                  │           DATA LAYER            │
                  │ (Models, DataSources, RepoImpl) │
                  └─────────────────────────────────┘
```

1. **Presentation Layer**: Responsible for visual representation.
   - **Screens / Widgets**: Flutter widgets expressing the UI state.
   - **BLoC / Cubit**: Listens to UI events, talks to Use Cases, and emits new UI states.
2. **Domain Layer**: The business heart of the application. It is completely independent of external packages, databases, or APIs.
   - **Entities**: Simple Dart objects representing core models.
   - **Use Cases**: Specific business operations (e.g. `LoginWithMobileAndPassword`).
   - **Repositories (Abstract Interfaces)**: Contracts defining data retrieval.
3. **Data Layer**: Concrete implementation of data operations.
   - **Models**: Extensions of Entities adding serialization logic (JSON mapping).
   - **Data Sources**: Retrieves data from APIs (Remote) or Cache/Database (Local).
   - **Repository Implementations**: Coordinates local/remote data sources.

---

## 2. Constants & Configuration

All configurations are centralized to ensure maintainability:

- **Environment Configs** ([app_environment.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/environment/app_environment.dart)): Controls API base URLs, feature toggles, logging status, and flavors (Development, Staging, Production).
- **API Endpoints** ([api_endpoints.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/environment/api_endpoints.dart)): Central mapping of REST endpoint paths (e.g., `/v1/user/login`).
- **Colors** ([app_colors.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/shared/theme/app_colors.dart)): Stores color palettes (`scaffold`, `primary`, `surface`, etc.).
- **Typography & Text Styles** ([app_text_styles.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/shared/theme/app_text_styles.dart)): Configures Font Families (Outfit), weights, sizes, and line heights.
- **Radii & Spacing** ([app_radii.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/shared/theme/app_radii.dart) & [app_spacing.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/shared/theme/app_spacing.dart)): Houses layout sizing conventions (`AppSpacing.md`, `AppRadii.lg`).

---

## 3. Changing Strings & Localization (i18n)

This application supports localization using standard Flutter `.arb` files.

### Where to Find Translations
Translations are located in:
- English: [app_en.arb](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/l10n/app_en.arb)
- Hindi: [app_hi.arb](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/l10n/app_hi.arb)

### Step-by-Step: Adding or Modifying a String

1. Open the ARB file (e.g., [app_en.arb](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/l10n/app_en.arb)) and add your key-value pair:
   ```json
   "welcomeUser": "Welcome, {name}!",
   "@welcomeUser": {
     "description": "Welcome message for logged in user",
     "placeholders": {
       "name": {
         "type": "String"
       }
     }
   }
   ```
2. Open the matching translation files (like [app_hi.arb](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/l10n/app_hi.arb)) and translate:
   ```json
   "welcomeUser": "स्वागत है, {name}!"
   ```
3. Run the localization builder in your terminal to generate class bindings:
   ```bash
   flutter gen-l10n
   ```
4. Access the generated string in your UI widget code:
   ```dart
   Text(context.l10n.welcomeUser(userName))
   ```

---

## 4. Adding a Field to a Model/Form

If you need to introduce a new property (e.g., adding `birthDate` to registration):

### Step 1: Update the Domain Entity
Modify the core entity class in `domain/entities/`:
```dart
class User extends Equatable {
  final String birthDate; // Add the field
  
  const User({required this.birthDate, ...});
}
```

### Step 2: Update the Data Model
Add JSON serialization mapping in `data/models/`:
```dart
class UserModel extends User {
  const UserModel({required super.birthDate, ...});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      birthDate: json['birthDate'] as String? ?? '',
      ...
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'birthDate': birthDate,
      ...
    };
  }
}
```

### Step 3: Integrate into the UI Form
1. Create a `TextEditingController` or state tracker in the screen:
   ```dart
   final TextEditingController _birthDateController = TextEditingController();
   ```
2. Place a form input field in the layout tree:
   ```dart
   TextField(
     controller: _birthDateController,
     decoration: authInputDecoration(hintText: 'YYYY-MM-DD'),
   )
   ```
3. Read the text value when submitting and pass it to the BLoC dispatch event.

---

## 5. Creating a Screen & Registering Routes

To add a new screen (e.g., `SettingsScreen`):

### Step 1: Create the Screen Widget
Create a new file under the feature's presentation folder, for example `lib/features/settings/presentation/screens/settings_screen.dart`:
```dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Settings')),
    );
  }
}
```

### Step 2: Define the Route Path
Add a route identifier in [app_router.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/routes/app_router.dart):
```dart
class AppRouter {
  static const String login = '/login';
  static const String home = '/home';
  static const String settings = '/settings'; // New path
  
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      ...
    }
  }
}
```

### Step 3: Navigate in Code
Trigger the navigation call from any button click:
```dart
Navigator.of(context).pushNamed(AppRouter.settings);
```

---

## 6. Integrating a New API

To integrate a new API (e.g., `/v1/user/profile`):

```
API Endpoint ➔ Data Source ➔ Repository ➔ Use Case ➔ BLoC ➔ UI
```

### Step 1: Define the Endpoint
Add the path configuration to [api_endpoints.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/config/environment/api_endpoints.dart):
```dart
static const String userProfile = '/v1/user/profile';
```

### Step 2: Define Data Models
Create the request/response models in `data/models/` matching the API specs.

### Step 3: Update the Data Source
Introduce a network call method in `data/datasource/auth_remote_datasource.dart`:
```dart
Future<UserModel> fetchUserProfile();
```
Implement it in `AuthRemoteDataSourceImpl`:
```dart
@override
Future<UserModel> fetchUserProfile() async {
  final response = await _apiClient.get(
    ApiEndpoints.userProfile,
  );
  return UserModel.fromJson(response);
}
```

### Step 4: Map through the Repository
1. Add the abstraction to `domain/repositories/auth_repository.dart`:
   ```dart
   Future<Result<User>> getUserProfile();
   ```
2. Implement it in `data/repositories/auth_repository_impl.dart` (incorporating network error handling wrappers):
   ```dart
   @override
   Future<Result<User>> getUserProfile() async {
     try {
       final remoteData = await remoteDataSource.fetchUserProfile();
       return Result.success(remoteData);
     } catch (e) {
       return Result.failure(ServerFailure(e.toString()));
     }
   }
   ```

### Step 5: Define a Use Case
Create a class representing this specific action in `domain/usecases/`:
```dart
class GetUserProfile {
  final AuthRepository repository;
  GetUserProfile(this.repository);

  Future<Result<User>> call() async {
    return await repository.getUserProfile();
  }
}
```

### Step 6: Inject and Connect in BLoC
1. Register the new Use Case in the dependency locator [injection_container.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/di/injection_container.dart):
   ```dart
   sl.registerLazySingleton(() => GetUserProfile(sl()));
   ```
2. Inject it into the BLoC constructor and dispatch state updates upon event trigger.

---

## 7. Authentication & Token Management

Auth tokens are automatically handled at the network level, ensuring developers don't have to manually attach them to individual API requests.

### Key Components

1. **Secure Storage Service** ([secure_storage.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/security/secure_storage.dart)): Coordinates saving, reading, and clearing authorization headers, access tokens, and credentials securely.
2. **Auth Interceptor** ([auth_interceptor.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/network/interceptors/auth_interceptor.dart)): A Dio interceptor that runs before requests leave. It reads the token from `SecureStorageService` and dynamically injects:
   ```http
   Authorization: Bearer <accessToken>
   X-Tenant-Id: DEFAULT
   ```
3. **Session Cleanses**: Upon hitting `logout` or receiving a `401 Unauthorized` token expiry response, a helper triggers standard resets clearing storage and directing the user back to `/login`.

---

## 8. Creating a New Feature

When creating a brand new module, construct the following file tree:

```
lib/features/cart/
│
├── data/
│   ├── datasource/
│   │   ├── cart_local_datasource.dart
│   │   └── cart_remote_datasource.dart
│   ├── models/
│   │   └── cart_item_model.dart
│   └── repositories/
│       └── cart_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   └── cart_item.dart
│   ├── repositories/
│   │   └── cart_repository.dart
│   └── usecases/
│       └── add_to_cart.dart
│
└── presentation/
    ├── bloc/
    │   ├── cart_bloc.dart
    │   ├── cart_event.dart
    │   └── cart_state.dart
    ├── screens/
    │   └── cart_screen.dart
    └── widgets/
        └── cart_tile.dart
```

Ensure all new DataSources, Repositories, and BLoCs are registered in the main GetIt [injection_container.dart](file:///c:/Users/heyra/AndroidStudioProjects/FultterApp/lib/core/di/injection_container.dart) file before launching.
