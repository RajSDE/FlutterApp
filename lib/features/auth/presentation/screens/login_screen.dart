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
  final TextEditingController _otpController = TextEditingController();
  bool _isOtpStep = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleContinue() {
    if (_isOtpStep) {
      context.read<AuthBloc>().add(
            OtpVerificationRequested(
              phoneNumber: _phoneController.text.trim(),
              otp: _otpController.text.trim(),
            ),
          );
      return;
    }

    context.read<AuthBloc>().add(
          LoginRequested(
            phoneNumber: _phoneController.text.trim(),
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
          if (state is OtpSent) {
            setState(() {
              _isOtpStep = true;
            });
            _showMessage(l10n.otpSentMessage(state.phoneNumber));
          } else if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (state is AuthFailure) {
            if (!state.isOtpStep) {
              setState(() {
                _isOtpStep = false;
              });
            }
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
                title: _isOtpStep ? l10n.otpTitle : l10n.loginTitle,
                subtitle: _isOtpStep ? l10n.otpSubtitle : l10n.loginSubtitle,
              ),
              const SizedBox(height: AppSpacing.xxl),
              TextField(
                controller: _phoneController,
                enabled: !_isOtpStep,
                keyboardType: TextInputType.phone,
                decoration: authInputDecoration(
                  hintText: l10n.mobileNumberHint,
                  prefixText: '+91  ',
                ),
              ),
              if (_isOtpStep) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: authInputDecoration(
                    hintText: l10n.otpHint,
                    counterText: '',
                  ),
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    label: _isOtpStep ? l10n.verifyOtp : l10n.continueText,
                    isLoading: state is AuthLoading,
                    backgroundColor: AppColors.buttonPrimary,
                    foregroundColor: AppColors.buttonOnPrimary,
                    onPressed: _handleContinue,
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),
              if (_isOtpStep)
                TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          LoginRequested(
                            phoneNumber: _phoneController.text.trim(),
                          ),
                        );
                    _showMessage(l10n.otpResent);
                  },
                  child: Text(
                    l10n.resendOtp,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              if (!_isOtpStep) ...<Widget>[
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
              ],
              const SizedBox(height: AppSpacing.xxl),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRouter.signup);
                },
                child: Text(
                  l10n.signupPrompt,
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
