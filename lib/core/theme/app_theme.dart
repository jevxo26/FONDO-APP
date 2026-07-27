import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// App ThemeData configuration derived strictly from `docs/DESIGN.md`
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.secondaryForegroundLight,
        surface: AppColors.cardLight,
        onSurface: AppColors.cardForegroundLight,
        error: AppColors.destructive,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.foregroundLight),
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium(isDark: false),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.radius2xl),
          textStyle: AppTypography.buttonText(),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.borderLight, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.ring, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.destructive, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.destructive, width: 2),
        ),
        labelStyle: AppTypography.labelConvention(isDark: false),
        hintStyle: AppTypography.bodyMedium(isDark: false),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.primaryForeground,
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.secondaryForegroundDark,
        surface: AppColors.cardDark,
        onSurface: AppColors.cardForegroundDark,
        error: AppColors.destructive,
        onError: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.foregroundDark),
        centerTitle: true,
        titleTextStyle: AppTypography.headlineMedium(isDark: true),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          minimumSize: const Size.fromHeight(52),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.radius2xl),
          textStyle: AppTypography.buttonText(isDark: true),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.borderDark, width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.ring, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.destructive, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.lg,
          borderSide: BorderSide(color: AppColors.destructive, width: 2),
        ),
        labelStyle: AppTypography.labelConvention(isDark: true),
        hintStyle: AppTypography.bodyMedium(isDark: true),
      ),
    );
  }
}
