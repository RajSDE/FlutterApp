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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    final phone = _phoneController.text.trim();
    final password = _passwordController.text.trim();

    if (phone.isEmpty) {
      _showMessage(context.l10n.errorInvalidMobile);
      return;
    }
    if (password.isEmpty) {
      _showMessage('Please enter your password');
      return;
    }

    context.read<AuthBloc>().add(
          LoginWithPasswordRequested(
            mobileNumber: phone,
            password: password,
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
      backgroundColor: AppColors.scaffold,
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
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
              ),
              const SizedBox(height: AppSpacing.authHeaderGap),
              AuthSectionHeader(
                title: l10n.loginTitle,
                subtitle: l10n.loginSubtitle,
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: authInputDecoration(
                  hintText: l10n.mobileNumberHint,
                ).copyWith(
                  prefixIcon: const Icon(Icons.phone_iphone_outlined, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: authInputDecoration(
                  hintText: l10n.passwordHint,
                ).copyWith(
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
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
                    onPressed: _handleContinue,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.lg),
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
                  Navigator.of(context).pushNamed(AppRouter.signup);
                },
                child: Text(
                  l10n.signupPrompt,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
