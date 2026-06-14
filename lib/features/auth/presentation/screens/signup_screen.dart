import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/config/routes/app_router.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/features/auth/domain/entities/register_user_request.dart';
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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  String _gender = 'MALE';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    final preferredLanguage = Localizations.localeOf(context).languageCode;
    context.read<AuthBloc>().add(
          SignupRequested(
            request: RegisterUserRequest(
              username: _usernameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              mobileNumber: _mobileNumberController.text.trim(),
              preferredLanguage: preferredLanguage,
              gender: _gender,
            ),
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
          if (state is AuthRegistered) {
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
                controller: _usernameController,
                decoration: authInputDecoration(
                  hintText: l10n.usernameHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: authInputDecoration(
                  hintText: l10n.emailHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: authInputDecoration(
                  hintText: l10n.passwordHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _firstNameController,
                textCapitalization: TextCapitalization.words,
                decoration: authInputDecoration(
                  hintText: l10n.firstNameHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _lastNameController,
                textCapitalization: TextCapitalization.words,
                decoration: authInputDecoration(
                  hintText: l10n.lastNameHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: _mobileNumberController,
                keyboardType: TextInputType.phone,
                decoration: authInputDecoration(
                  hintText: l10n.mobileNumberSignupHint,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: authInputDecoration(
                  hintText: l10n.genderHint,
                ),
                items: <DropdownMenuItem<String>>[
                  DropdownMenuItem<String>(
                    value: 'MALE',
                    child: Text(l10n.genderMale),
                  ),
                  DropdownMenuItem<String>(
                    value: 'FEMALE',
                    child: Text(l10n.genderFemale),
                  ),
                  DropdownMenuItem<String>(
                    value: 'OTHER',
                    child: Text(l10n.genderOther),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _gender = value;
                    });
                  }
                },
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
