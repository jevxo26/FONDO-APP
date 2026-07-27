import 'package:flutter/material.dart';

/// FONDO Color Palette according to `docs/DESIGN.md` §2
class AppColors {
  AppColors._();

  // CSS Variable Tokens (Light / Dark)
  // Primary (Gold)
  static const Color primary = Color(0xFFCEA359);
  static const Color primaryForeground = Color(0xFF1B0E08);

  // Background
  static const Color backgroundLight = Color(0xFFFAF5EB);
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Foreground (Main Text)
  static const Color foregroundLight = Color(0xFF16100C);
  static const Color foregroundDark = Color(0xFFFAF5EB);

  // Card
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF2C2C2C);

  static const Color cardForegroundLight = Color(0xFF16100C);
  static const Color cardForegroundDark = Color(0xFFFAF5EB);

  // Secondary (Cream)
  static const Color secondaryLight = Color(0xFFFBF5EB);
  static const Color secondaryDark = Color(0xFF2C2C2C);

  static const Color secondaryForegroundLight = Color(0xFF1B1612);
  static const Color secondaryForegroundDark = Color(0xFFFAF5EB);

  // Muted
  static const Color mutedLight = Color(0xFFF5F0E8);
  static const Color mutedDark = Color(0xFF2C2C2C);

  static const Color mutedForegroundLight = Color(0xFF635C57);
  static const Color mutedForegroundDark = Color(0xFF9CA3AF);

  // Accent
  static const Color accentLight = Color(0xFFFBF5EB);
  static const Color accentDark = Color(0xFF2C2C2C);

  static const Color accentForegroundLight = Color(0xFF1B1612);
  static const Color accentForegroundDark = Color(0xFFFAF5EB);

  // Semantic Status Colors
  static const Color destructive = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);

  // Borders & Inputs
  static const Color borderLight = Color(0xFFDDD6CF);
  static const Color borderDark = Color(0xFF3A3A3A);

  static const Color inputLight = Color(0xFFDDD6CF);
  static const Color inputDark = Color(0xFF3A3A3A);

  static const Color ring = Color(0xFFCEA359);

  // Sidebar
  static const Color sidebarLight = Color(0xFFFFFFFF);
  static const Color sidebarDark = Color(0xFF1A1A1A);
  static const Color sidebarForegroundLight = Color(0xFF16100C);
  static const Color sidebarForegroundDark = Color(0xFFFAF5EB);

  // Gold Gradients & Warm Accents (§7.1, §7.5)
  static const Gradient warmGoldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0x08CEA359), // primary / 3%
      Color(0x00CEA359),
      Color(0x03CEA359), // primary / 1%
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
}
