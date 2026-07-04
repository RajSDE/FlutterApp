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
import 'package:flutter_app/shared/theme/app_radii.dart';
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
      SnackBar(
        content: Text(context.resolveMessage(message)),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(3, (index) {
        final stepNum = index + 1;
        final isActive = _signupStep == stepNum;
        final isCompleted = _signupStep > stepNum;

        return Row(
          children: <Widget>[
            Container(
              width: 34,
              height: 34,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? AppColors.primary
                    : (isCompleted ? Colors.green : Colors.grey.shade300),
                boxShadow: isActive
                    ? <BoxShadow>[
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                      '$stepNum',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
            if (index < 2)
              Container(
                width: 36,
                height: 3,
                color: isCompleted ? Colors.green : Colors.grey.shade300,
              ),
          ],
        );
      }),
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
            Navigator.of(context).pushReplacementNamed(AppRouter.home);
          } else if (state is AuthFailure) {
            _showMessage(state.message);
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              height: 280,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: <Widget>[
                    const SizedBox(height: 12),
                    const Align(
                      alignment: Alignment.topRight,
                      child: AuthLanguageSwitcher(),
                    ),
                    const SizedBox(height: 36),
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.flash_on,
                        size: 38,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.appName.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 420),
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadii.lg),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _buildStepIndicator(),
                          const SizedBox(height: AppSpacing.xl),
                          if (_signupStep == 1) ...<Widget>[
                            const AuthSectionHeader(
                              title: 'Verify Mobile',
                              subtitle:
                                  'Enter your mobile number to get verification code',
                            ),
                          ] else if (_signupStep == 2) ...<Widget>[
                            const AuthSectionHeader(
                              title: 'Enter Verification Code',
                              subtitle:
                                  'Enter 000000 code to bypass verification locally',
                            ),
                          ] else ...<Widget>[
                            AuthSectionHeader(
                              title: l10n.signupTitle,
                              subtitle: l10n.signupSubtitle,
                            ),
                          ],
                          const SizedBox(height: AppSpacing.xl),

                          // Step 1: Mobile Entry
                          if (_signupStep == 1) ...<Widget>[
                            TextField(
                              controller: _mobileNumberController,
                              keyboardType: TextInputType.phone,
                              decoration: authInputDecoration(
                                hintText: l10n.mobileNumberSignupHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.phone_iphone_outlined,
                                  color: AppColors.textSecondary,
                                ),
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
                          if (_signupStep == 2) ...<Widget>[
                            TextField(
                              controller: _otpController,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              decoration: authInputDecoration(
                                hintText: '6-digit OTP code',
                                counterText: '',
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.security_outlined,
                                  color: AppColors.textSecondary,
                                ),
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
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _signupStep = 1;
                                  });
                                },
                                child: const Text(
                                  'Change Mobile Number',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          // Step 3: Profile Form
                          if (_signupStep == 3) ...<Widget>[
                            TextField(
                              controller: _mobileNumberController,
                              enabled: false,
                              decoration: authInputDecoration(
                                hintText: l10n.mobileNumberSignupHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.phone_iphone_outlined,
                                  color: AppColors.textSecondary,
                                ),
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
                                prefixIcon: const Icon(
                                  Icons.account_circle_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: authInputDecoration(
                                hintText: l10n.emailHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: authInputDecoration(
                                hintText: l10n.passwordHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.lock_outline,
                                  color: AppColors.textSecondary,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
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
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            TextField(
                              controller: _lastNameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: authInputDecoration(
                                hintText: l10n.lastNameHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.person_outline,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            DropdownButtonFormField<String>(
                              initialValue: _gender,
                              decoration: authInputDecoration(
                                hintText: l10n.genderHint,
                              ).copyWith(
                                prefixIcon: const Icon(
                                  Icons.people_outline,
                                  color: AppColors.textSecondary,
                                ),
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
                            const SizedBox(height: AppSpacing.xl),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 420),
                      child: Column(
                        children: <Widget>[
                          const AuthDivider(),
                          const SizedBox(height: AppSpacing.lg),
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
                            icon: const Icon(
                              Icons.apple,
                              size: 32,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xxl),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pushReplacementNamed(AppRouter.login);
                            },
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              backgroundColor: Colors.white,
                              elevation: 2,
                              shadowColor: Colors.black.withValues(alpha: 0.1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              l10n.loginPrompt,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          const AuthTermsText(),
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
