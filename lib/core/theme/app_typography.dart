import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typography hierarchy from `docs/DESIGN.md` §3
class AppTypography {
  AppTypography._();

  // Fraunces Headings
  static TextStyle display({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        height: 1.1,
      );

  static TextStyle headlineLarge({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        height: 1.2,
      );

  static TextStyle headlineMedium({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        height: 1.25,
      );

  static TextStyle cardTitle({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.cardForegroundDark : AppColors.cardForegroundLight,
      );

  static TextStyle statValue({bool isDark = false}) => GoogleFonts.fraunces(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.5,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        height: 1.1,
      );

  // Inter Body & UI Labels
  static TextStyle bodyLarge({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
        height: 1.5,
      );

  static TextStyle bodyMedium({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
        height: 1.43,
      );

  static TextStyle small({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
        height: 1.33,
      );

  static TextStyle price({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
      );

  static TextStyle label({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.28,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
      );

  static TextStyle badge({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
        color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
      );

  /// §7.9 Label Convention: text-[10px] uppercase tracking-widest text-muted-foreground
  static TextStyle labelConvention({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
        color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
      );

  static TextStyle buttonText({bool isDark = false}) => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryForeground,
      );
}
