import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:flutter_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_radii.dart';
import 'package:flutter_app/shared/theme/app_spacing.dart';
import 'package:flutter_app/features/auth/presentation/widgets/auth_widgets.dart';

class VerificationArgs {
  final bool isEmail;
  final String currentValue;

  const VerificationArgs({required this.isEmail, required this.currentValue});
}

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({
    super.key,
    required this.args,
  });

  final VerificationArgs args;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late final TextEditingController _valueController;
  final TextEditingController _otpController = TextEditingController();
  late AuthBloc _authBloc;
  bool _didInitBloc = false;
  bool _codeSent = false;
  bool _hasVerified = false;
  bool _isLoading = false;
  int _timerSeconds = 0;
  Timer? _timer;
  String? _uniqueId;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController(text: widget.args.currentValue);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitBloc) {
      _authBloc = context.read<AuthBloc>();
      _didInitBloc = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _valueController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _timerSeconds = 30;
    });
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_timerSeconds == 0) {
        timer.cancel();
      } else {
        setState(() {
          _timerSeconds--;
        });
      }
    });
  }

  void _handleSendCode() {
    final value = _valueController.text.trim();
    if (value.isEmpty) {
      _showMessage(widget.args.isEmail
          ? 'Please enter your email address'
          : 'Please enter your mobile number');
      return;
    }

    if (widget.args.isEmail && !value.contains('@')) {
      _showMessage('Please enter a valid email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    context.read<AuthBloc>().add(
          SendVerificationCodeRequested(
            identifierType: widget.args.isEmail ? 'EMAIL' : 'MOBILE',
            identifierValue: value,
          ),
        );
  }

  void _handleCancel() {
    if (_codeSent && !_hasVerified) {
      _authBloc.add(const RestorePreviousAuthStateRequested());
    }
    Navigator.of(context).pop();
  }

  void _handleVerifyOtp() {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage('Please enter the 6-digit verification code');
      return;
    }

    if (_uniqueId == null) {
      _showMessage('Please send the verification code first');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    context.read<AuthBloc>().add(
          ValidateVerificationOtpRequested(
            uniqueId: _uniqueId!,
            otp: otp,
            isEmail: widget.args.isEmail,
            identifierValue: _valueController.text.trim(),
          ),
        );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.args.isEmail ? 'Verify Email' : 'Verify Mobile';
    final labelText = widget.args.isEmail ? 'Email Address' : 'Mobile Number';
    final inputHint =
        widget.args.isEmail ? 'enter.email@domain.com' : 'Mobile number';

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is VerificationCodeSent) {
          setState(() {
            _isLoading = false;
            _codeSent = true;
            _uniqueId = state.uniqueId;
          });
          _startTimer();
          _showMessage('Verification code sent successfully!');
        } else if (state is VerificationOtpValidated) {
          setState(() {
            _isLoading = false;
            _hasVerified = true;
          });
          // Fire VerificationCompleted to update the user profile in AuthBloc
          context.read<AuthBloc>().add(
                VerificationCompleted(
                  isEmail: state.isEmail,
                  newValue: state.identifierValue,
                ),
              );
          _showMessage(state.isEmail
              ? 'Email address verified and updated successfully!'
              : 'Mobile number verified and updated successfully!');
          Navigator.of(context).pop();
        } else if (state is VerificationFailure) {
          setState(() {
            _isLoading = false;
          });
          _showMessage(state.message);
        } else if (state is AuthLoading) {
          setState(() {
            _isLoading = true;
          });
        }
      },
      child: PopScope(
        onPopInvokedWithResult: (_, __) {
          if (_codeSent && !_hasVerified) {
            _authBloc.add(const RestorePreviousAuthStateRequested());
          }
        },
        child: Scaffold(
          body: Stack(
            children: [
              // Background Gradient Header
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 220,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, AppColors.secondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: _handleCancel,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Main Body container overlapping the header
              Positioned.fill(
                top: 150,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadii.lg),
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Update and verify your $labelText below to secure your account.',
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            TextField(
                              controller: _valueController,
                              enabled: !_codeSent,
                              keyboardType: widget.args.isEmail
                                  ? TextInputType.emailAddress
                                  : TextInputType.phone,
                              decoration: authInputDecoration(
                                hintText: inputHint,
                              ).copyWith(
                                prefixIcon: Icon(
                                  widget.args.isEmail
                                      ? Icons.email_outlined
                                      : Icons.phone_iphone_outlined,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                            if (_codeSent) ...[
                              const SizedBox(height: AppSpacing.md),
                              TextField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                decoration: authInputDecoration(
                                  hintText: 'Enter 6-digit OTP code',
                                  counterText: '',
                                ).copyWith(
                                  prefixIcon: const Icon(
                                    Icons.security_outlined,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: AppSpacing.xl),
                            if (_isLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.buttonPrimary,
                                    foregroundColor: AppColors.buttonOnPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(AppRadii.md),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: _codeSent
                                      ? _handleVerifyOtp
                                      : _handleSendCode,
                                  child: Text(
                                    _codeSent ? 'Verify & Update' : 'Send Code',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            if (_codeSent) ...[
                              const SizedBox(height: AppSpacing.md),
                              Center(
                                child: TextButton(
                                  onPressed: _timerSeconds == 0
                                      ? _handleSendCode
                                      : null,
                                  child: Text(
                                    _timerSeconds == 0
                                        ? 'Resend Verification Code'
                                        : 'Resend code in ${_timerSeconds}s',
                                    style: TextStyle(
                                      color: _timerSeconds == 0
                                          ? AppColors.primary
                                          : AppColors.textSecondary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
