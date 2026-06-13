import 'package:flutter/material.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_app/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static const String login = '/';
  static const String signup = '/signup';
  static const String home = '/home';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute<void>(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case signup:
        return MaterialPageRoute<void>(
          builder: (_) => const SignupScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute<void>(
          builder: (_) => const HomeScreen(),
          settings: settings,
        );
      default:
        return MaterialPageRoute<void>(
          builder: (context) => Scaffold(
            body: Center(child: Text(context.l10n.pageNotFound)),
          ),
          settings: settings,
        );
    }
  }
}
