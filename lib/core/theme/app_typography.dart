import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTypography {
  AppTypography._();

  static TextStyle displayHeadline({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.2,
      );

  static TextStyle titleLarge({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        height: 1.25,
      );

  static TextStyle titleMedium({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyLarge({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      );

  static TextStyle bodyMedium({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      );

  static TextStyle label({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
      );

  static TextStyle buttonText({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      );
}
