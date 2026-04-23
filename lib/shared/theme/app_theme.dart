import 'package:flutter/material.dart';
import 'package:flutter_app/shared/theme/app_colors.dart';
import 'package:flutter_app/shared/theme/app_radii.dart';
import 'package:flutter_app/shared/theme/app_text_styles.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.scaffold,
        onPrimary: AppColors.buttonOnPrimary,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.scaffold,
      textTheme: AppTextStyles.textTheme(),
      dividerColor: AppColors.divider,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
          borderSide: const BorderSide(color: AppColors.textPrimary),
        ),
      ),
      useMaterial3: true,
    );
  }
}
