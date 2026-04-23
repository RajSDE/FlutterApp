import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/config/routes/app_router.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_widgets.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_spacing.dart';
import 'package:flutter_app/shared/widgets/primary_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    context.read<AuthBloc>().add(
          SignupRequested(
            email: _emailController.text.trim(),
          ),
        );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.resolveMessage(message))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (state is AuthFailure) {
            _showMessage(state.message);
          }
        },
        child: AuthPageLayout(
          child: Column(
            children: <Widget>[
              const AuthLanguageSwitcher(),
              const SizedBox(height: AppSpacing.heroGap),
              Text(
                l10n.appName,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: AppSpacing.authHeaderGap),
              AuthSectionHeader(
                title: l10n.signupTitle,
                subtitle: l10n.signupSubtitle,
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: authInputDecoration(
                  hintText: l10n.emailHint,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    label: l10n.continueText,
                    isLoading: state is AuthLoading,
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonOnPrimary,
                    onPressed: _handleSignup,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.section),
              const AuthDivider(),
              const SizedBox(height: AppSpacing.section),
              AuthSocialButton(
                label: l10n.continueWithGoogle,
                icon: const BrandCircle(
                  label: 'G',
                  textColor: Color(0xFF4285F4),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AuthSocialButton(
                label: l10n.continueWithApple,
                icon: const Icon(Icons.apple, size: 34, color: Colors.black),
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRouter.login);
                },
                child: Text(
                  l10n.loginPrompt,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const AuthTermsText(),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
