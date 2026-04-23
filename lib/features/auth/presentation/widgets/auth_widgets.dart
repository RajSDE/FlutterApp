import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/core/extensions/localization_extension.dart';
import 'package:flutter_app/shared/cubit/app_locale_cubit.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_radii.dart';
import 'package:flutter_app/shared/theme/app_spacing.dart';

class AuthPageLayout extends StatelessWidget {
  const AuthPageLayout({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xl,
              vertical: AppSpacing.md,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AuthLanguageSwitcher extends StatelessWidget {
  const AuthLanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadii.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Locale>(
              value: Localizations.localeOf(context),
              borderRadius: BorderRadius.circular(12),
              items: <DropdownMenuItem<Locale>>[
                DropdownMenuItem<Locale>(
                  value: const Locale('en'),
                  child: Text(context.l10n.languageEnglish),
                ),
                DropdownMenuItem<Locale>(
                  value: const Locale('hi'),
                  child: Text(context.l10n.languageHindi),
                ),
              ],
              onChanged: (locale) {
                if (locale != null) {
                  context.read<AppLocaleCubit>().updateLocale(locale);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class AuthSectionHeader extends StatelessWidget {
  const AuthSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.9),
              ),
        ),
      ],
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            context.l10n.orText,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.divider, thickness: 1),
        ),
      ],
    );
  }
}

class AuthSocialButton extends StatelessWidget {
  const AuthSocialButton({
    super.key,
    required this.label,
    required this.icon,
  });

  final String label;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BrandCircle extends StatelessWidget {
  const BrandCircle({
    super.key,
    required this.label,
    required this.textColor,
  });

  final String label;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class AuthTermsText extends StatelessWidget {
  const AuthTermsText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(
          fontSize: 16,
          height: 1.5,
          color: AppColors.textSecondary,
        ),
        children: <InlineSpan>[
          TextSpan(text: context.l10n.termsPrefix),
          TextSpan(
            text: context.l10n.termsOfService,
            style: const TextStyle(color: Colors.black),
          ),
          TextSpan(text: context.l10n.andText),
          TextSpan(
            text: context.l10n.privacyPolicy,
            style: const TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

InputDecoration authInputDecoration({
  required String hintText,
  String? prefixText,
  String? counterText,
}) {
  return InputDecoration(
    hintText: hintText,
    prefixText: prefixText,
    counterText: counterText,
    hintStyle: const TextStyle(
      color: Color(0xFF8E8E93),
      fontSize: 17,
    ),
    prefixStyle: const TextStyle(
      color: Colors.black,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 20,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: Colors.black),
    ),
  );
}
