# Dart & Flutter Technical Learning Guide

This guide is designed for interns and newcomers to quickly master **Dart** syntax, conventions, and **Flutter** development patterns used in this application.

---

## Table of Contents
1. [Introduction to Dart](#1-introduction-to-dart)
2. [Sound Null Safety](#2-sound-null-safety)
3. [Object-Oriented Programming (OOP) in Dart](#3-object-oriented-programming-oop-in-dart)
4. [Asynchronous Programming (Futures & Streams)](#4-asynchronous-programming-futures--streams)
5. [Functional Dart & Collections](#5-functional-dart--collections)
6. [Core Flutter Concepts](#6-core-flutter-concepts)
7. [Enterprise Best Practices in this App](#7-enterprise-best-practices-in-this-app)

---

## 1. Introduction to Dart

Dart is a client-optimized, type-safe language. Key aspects to know:
- **Statically Typed**: Types are evaluated at compile time, reducing runtime crashes.
- **Event-Loop Driven**: Runs on a single thread (the Main/UI thread) by default, using an event loop to handle UI interactions and asynchronous IO without lock issues.

### Variables: `final` vs. `const`
- `final`: Set once, initialized at runtime (when execution reaches it).
- `const`: Compile-time constant. It is immutable and resolved at compile time.

```dart
final DateTime now = DateTime.now(); // Runtime evaluation (Allowed)
// const DateTime error = DateTime.now(); // Compile error!

const String appName = 'Little Mart'; // Resolved at compilation
```

---

## 2. Sound Null Safety

Dart has **Sound Null Safety**, meaning variables cannot contain `null` unless you explicitly state they can. This prevents the infamous "Null Pointer Exception."

### Syntax Reference

| Feature | Syntax | Explanation | Example |
|---|---|---|---|
| **Non-Nullable** | `String name;` | Must always contain a String. Cannot be null. | `name = 'John';` |
| **Nullable** | `String? email;` | Can hold a String or `null`. | `email = null;` |
| **Assertion (Bang)** | `email!` | Asserts that `email` is not null. Throws error if null. | `print(email!.length);` |
| **Conditional Access**| `email?.length` | Accesses property only if not null, otherwise returns null. | `int? len = email?.length;` |
| **Null-Coalescing** | `email ?? 'N/A'` | Returns fallback value if expression is null. | `String display = email ?? '';` |
| **Late Init** | `late String token;`| Declares a variable initialized later, before read. | `late final TextEditingController ctrl;` |

---

## 3. Object-Oriented Programming (OOP) in Dart

Dart is fully object-oriented. Below are advanced features frequently used in our architecture.

### Constructors
Dart supports shorthand constructors, initializer lists, and **Factory Constructors**:

```dart
class UserModel {
  final int id;
  final String name;

  // Shorthand parameter assignment
  const UserModel({required this.id, required this.name});

  // Factory constructor: returns an instance of UserModel (or subclass)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'User',
    );
  }
}
```

### Extensions
Extensions add functionality to existing classes without modifying the source:

```dart
// Custom extension to capitalize string values
extension StringExtensions on String {
  String toCapitalized() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

// Usage:
String title = 'orange'.toCapitalized(); // Returns 'Orange'
```

### Mixins
Mixins allow sharing behaviors across unrelated classes without inheriting:

```dart
mixin LoggerMixin {
  void logMessage(String msg) {
    print('[LOG] ${DateTime.now()}: $msg');
  }
}

class ApiClient with LoggerMixin {
  void fetchData() {
    logMessage('Fetching API data...'); // Accessible from mixin
  }
}
```

---

## 4. Asynchronous Programming (Futures & Streams)

Asynchronous operations return a `Future<T>` or `Stream<T>`.

### Futures: async / await
A `Future` represents a delayed calculation. We use `async` and `await` to handle them synchronously:

```dart
Future<void> fetchAndSaveData() async {
  try {
    // Wait for the asynchronous network call to complete
    final data = await apiService.getUserData();
    await localStorage.saveData(data);
  } catch (error) {
    print('Failed to process data: $error');
  }
}
```

### Streams
A `Stream` delivers a sequence of events. **BLoCs** use streams under the hood to emit state changes to the UI over time.

---

## 5. Functional Dart & Collections

Dart collections (`List`, `Map`, `Set`) have powerful functional extensions.

### Cascade Operator (`..`)
Allows you to perform a sequence of operations on the same object:

```dart
final path = Path()
  ..moveTo(0, 0)
  ..lineTo(100, 200)
  ..close();
```

### Spread Operators (`...` and `...?`)
Inserts multiple elements into a collection:

```dart
final listA = [1, 2];
final listB = [0, ...listA, 3]; // Result: [0, 1, 2, 3]
```

### Collection manipulation methods
- `map`: Transforms elements.
- `where`: Filters elements (like filter in JS).

```dart
final List<int> numbers = [1, 2, 3, 4, 5];
final evenNumbers = numbers.where((n) => n % 2 == 0).toList(); // [2, 4]
final strings = numbers.map((n) => 'Item $n').toList(); // ['Item 1', 'Item 2'...]
```

---

## 6. Core Flutter Concepts

### 1. The Declarative UI paradigm
In Flutter, the user interface reflects the current state of the application. You do not mutate widgets directly. Instead, you update the state (e.g. via BLoC), and Flutter rebuilds the UI:

$$\text{UI} = f(\text{State})$$

### 2. BuildContext
`BuildContext` is a handle to the location of a widget in the widget tree. It is used to look up configurations and ancestor widgets, such as localizations and themes:
```dart
// Look up localization strings from the nearest Localizations widget
final String label = context.l10n.appName;

// Look up theme specifications from the nearest Theme widget
final Color primaryColor = Theme.of(context).primaryColor;
```

---

## 7. Enterprise Best Practices in this App

To maintain clean code quality, follow these practices:

### 1. Strict Immutability with Equatable
By default, Dart checks equality by object reference. In Clean Architecture, we require value equality for states and entities. We use `Equatable` to compare values:

```dart
class User extends Equatable {
  final int id;
  final String name;

  const User({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name]; // Value equality checked on these properties
}
```

### 2. Always Clean Up Resources
To prevent memory leaks, clean up controllers, streams, and controllers when a widget is disposed:

```dart
class MyFormWidget extends StatefulWidget {
  const MyFormWidget({super.key});

  @override
  State<MyFormWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends State<MyFormWidget> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose(); // CRITICAL: Free memory
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) => Container();
}
```

### 3. Use Dependency Injection (GetIt)
Never instantiate classes manually. Fetch them through `sl` (Service Locator):

```dart
// CORRECT: Fetching using Dependency Injection locator
final authRepository = sl<AuthRepository>();

// INCORRECT: Creating tight coupling
// final authRepository = AuthRepositoryImpl(remoteDataSource: ...);
```
