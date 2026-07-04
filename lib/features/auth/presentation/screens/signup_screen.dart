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
  final TextEditingController _otpController = TextEditingController();

  String _gender = 'MALE';
  bool _obscurePassword = true;
  int _signupStep = 1; // 1 = Mobile, 2 = OTP Verification, 3 = Details Form

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileNumberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _handleSendOtp() {
    final phone = _mobileNumberController.text.trim();
    if (phone.isEmpty) {
      _showMessage(context.l10n.errorInvalidMobile);
      return;
    }
    // Transition to step 2 (OTP Entry)
    setState(() {
      _signupStep = 2;
    });
    _showMessage('OTP code sent successfully to +91 $phone');
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();
    if (otp.length != 6) {
      _showMessage('Please enter a 6-digit OTP code');
      return;
    }

    // Bypass code validation check
    if (otp == '000000') {
      setState(() {
        _signupStep = 3;
      });
      _showMessage('Mobile number verified successfully');
    } else {
      _showMessage('Invalid OTP verification code. Use 000000 to bypass.');
    }
  }

  void _handleSignup() {
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _mobileNumberController.text.trim();

    if (username.isEmpty) {
      _showMessage('Please enter a username');
      return;
    }
    if (email.isEmpty || !email.contains('@')) {
      _showMessage(context.l10n.errorInvalidEmail);
      return;
    }
    if (password.length < 6) {
      _showMessage('Password must be at least 6 characters');
      return;
    }
    if (firstName.isEmpty) {
      _showMessage('Please enter your first name');
      return;
    }
    if (lastName.isEmpty) {
      _showMessage('Please enter your last name');
      return;
    }

    final preferredLanguage = Localizations.localeOf(context).languageCode;

    context.read<AuthBloc>().add(
          SignupRequested(
            request: RegisterUserRequest(
              username: username,
              email: email,
              password: password,
              firstName: firstName,
              lastName: lastName,
              mobileNumber: phone,
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
      backgroundColor: AppColors.scaffold,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegistered) {
            // After successful registration, navigate to Home
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
              
              // Dynamic header depending on the wizard step
              if (_signupStep == 1) ...[
                const AuthSectionHeader(
                  title: 'Verify Mobile',
                  subtitle: 'Enter your mobile number to receive a verification code',
                ),
              ] else if (_signupStep == 2) ...[
                const AuthSectionHeader(
                  title: 'Enter Verification Code',
                  subtitle: 'We sent a 6-digit verification code to your mobile number. Enter 000000 to bypass.',
                ),
              ] else ...[
                AuthSectionHeader(
                  title: l10n.signupTitle,
                  subtitle: l10n.signupSubtitle,
                ),
              ],
              
              const SizedBox(height: AppSpacing.xxl),

              // Step 1: Mobile Entry
              if (_signupStep == 1) ...[
                TextField(
                  controller: _mobileNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: authInputDecoration(
                    hintText: l10n.mobileNumberSignupHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.phone_iphone_outlined, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Send OTP',
                  onPressed: _handleSendOtp,
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.buttonOnPrimary,
                ),
              ],

              // Step 2: OTP Verification
              if (_signupStep == 2) ...[
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: authInputDecoration(
                    hintText: '6-digit OTP code',
                    counterText: '',
                  ).copyWith(
                    prefixIcon: const Icon(Icons.security_outlined, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: 'Verify OTP',
                  onPressed: _handleVerifyOtp,
                  backgroundColor: AppColors.buttonPrimary,
                  foregroundColor: AppColors.buttonOnPrimary,
                ),
                const SizedBox(height: AppSpacing.md),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _signupStep = 1;
                    });
                  },
                  child: const Text(
                    'Change Mobile Number',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],

              // Step 3: Registration Details Form
              if (_signupStep == 3) ...[
                // Disabled mobile number to show it is verified
                TextField(
                  controller: _mobileNumberController,
                  enabled: false,
                  decoration: authInputDecoration(
                    hintText: l10n.mobileNumberSignupHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.phone_iphone_outlined, color: AppColors.textSecondary),
                    filled: true,
                    fillColor: AppColors.mutedSurface,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _usernameController,
                  decoration: authInputDecoration(
                    hintText: l10n.usernameHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.account_circle_outlined, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: authInputDecoration(
                    hintText: l10n.emailHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
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
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _firstNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: authInputDecoration(
                    hintText: l10n.firstNameHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _lastNameController,
                  textCapitalization: TextCapitalization.words,
                  decoration: authInputDecoration(
                    hintText: l10n.lastNameHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  decoration: authInputDecoration(
                    hintText: l10n.genderHint,
                  ).copyWith(
                    prefixIcon: const Icon(Icons.people_outline, color: AppColors.textSecondary),
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
              ],

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
                  Navigator.of(context).pushReplacementNamed(AppRouter.login);
                },
                child: Text(
                  l10n.loginPrompt,
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
