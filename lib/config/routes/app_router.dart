import 'package:flutter/material.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter_app/features/auth/presentation/screens/signup_screen.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';

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
          builder: (_) => const _HomeScreen(),
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

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color(0xFFFFE0CF),
              AppColors.scaffold,
            ],
          ),
        ),
        child: const Center(
          child: _HomeTitle(),
        ),
      ),
    );
  }
}

class _HomeTitle extends StatelessWidget {
  const _HomeTitle();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.homeWelcome,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
    );
  }
}
