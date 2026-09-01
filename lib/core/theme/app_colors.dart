import 'package:flutter/material.dart';

/// FONDO Color Palette according to `docs/DESIGN.md` §2
class AppColors {
  AppColors._();

  // CSS Variable Tokens (Light / Dark)
  // 10% Radiant Accents (Gold & Pro Purple)
  static const Color primary = Color(0xFFCEA359);
  static const Color primaryForeground = Color(0xFF1B0E08);
  static const Color goldShine = Color(0xFFF3D08B);
  static const Color goldDeep = Color(0xFF99732B);
  static const Color proPurple = Color(0xFF5E17EB);
  static const Color proPurpleDark = Color(0xFF3B0764);

  // 60% Dominant Canvas (Background)
  static const Color backgroundLight = Color(0xFFFAF5EB);
  static const Color backgroundDark = Color(0xFF121212);

  // Foreground (Main Text)
  static const Color foregroundLight = Color(0xFF16100C);
  static const Color foregroundDark = Color(0xFFFAF5EB);

  // 30% Structural Surfaces & Cards
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color glassBorderLight = Color(0x33CEA359);
  static const Color glassBorderDark = Color(0x26FFFFFF);

  static const Color cardForegroundLight = Color(0xFF16100C);
  static const Color cardForegroundDark = Color(0xFFFAF5EB);

  // Secondary (Warm Cream / Dark Velvet)
  static const Color secondaryLight = Color(0xFFFBF5EB);
  static const Color secondaryDark = Color(0xFF222222);

  static const Color secondaryForegroundLight = Color(0xFF1B1612);
  static const Color secondaryForegroundDark = Color(0xFFFAF5EB);

  // Muted
  static const Color mutedLight = Color(0xFFF5F0E8);
  static const Color mutedDark = Color(0xFF282828);

  static const Color mutedForegroundLight = Color(0xFF635C57);
  static const Color mutedForegroundDark = Color(0xFF9CA3AF);

  // Accent
  static const Color accentLight = Color(0xFFFBF5EB);
  static const Color accentDark = Color(0xFF282828);

  static const Color accentForegroundLight = Color(0xFF1B1612);
  static const Color accentForegroundDark = Color(0xFFFAF5EB);

  // Semantic Status Colors
  static const Color destructive = Color(0xFFEF4444);
  static const Color error = Color(0xFFEF4444); // Legacy alias for destructive
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Borders & Inputs
  static const Color borderLight = Color(0xFFDDD6CF);
  static const Color borderDark = Color(0xFF333333);

  static const Color inputLight = Color(0xFFDDD6CF);
  static const Color inputDark = Color(0xFF333333);

  static const Color ring = Color(0xFFCEA359);

  // Sidebar
  static const Color sidebarLight = Color(0xFFFFFFFF);
  static const Color sidebarDark = Color(0xFF161616);
  static const Color sidebarForegroundLight = Color(0xFF16100C);
  static const Color sidebarForegroundDark = Color(0xFFFAF5EB);

  // Legacy Aliases for backward compatibility across existing screens
  static const Color textPrimaryLight = Color(0xFF16100C);
  static const Color textPrimaryDark = Color(0xFFFAF5EB);
  static const Color textSecondaryLight = Color(0xFF635C57);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);
  static const Color textMutedLight = Color(0xFF635C57);
  static const Color textMutedDark = Color(0xFF9CA3AF);
  static const Color inputFillLight = Color(0xFFFBF5EB);
  static const Color inputFillDark = Color(0xFF282828);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF222222);
  static const Color primarySurface = Color(0x1ACEA359);

  // Specular Border & Gold Gradients
  static const Gradient specularBorderLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40F3D08B), // gold shine 25%
      Color(0x10CEA359), // subtle gold
      Colors.transparent,
    ],
    stops: [0.0, 0.4, 1.0],
  );

  static const Gradient specularBorderDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x40FFFFFF), // specular white highlight
      Color(0x1AFFFFFF),
      Colors.transparent,
    ],
    stops: [0.0, 0.35, 1.0],
  );

  static const Gradient warmGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFCEA359),
      Color(0xFFF3D08B),
    ],
  );

  static const Gradient goldDividerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0x66CEA359), // primary 40%
      Color(0x4DCEA359), // primary 30%
      Colors.transparent,
    ],
  );

  static const Gradient specularRimGradient = specularBorderLight;
}
