import 'package:flutter/material.dart';

/// Directional multi-layer shadow system based on physical light scattering.
class AppShadows {
  AppShadows._();

  /// Subtle single-layer shadow for flat surfaces and baseline cards.
  static const List<BoxShadow> surfaceFlat = [
    BoxShadow(
      color: Color(0x0A1E1A16),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Tri-layer directional 3D card shadow combining ambient, key, and rim light effects.
  static const List<BoxShadow> card3D = [
    BoxShadow(
      color: Color(0x0A1E1A16),
      offset: Offset(0, 2),
      blurRadius: 12,
    ),
    BoxShadow(
      color: Color(0x0F1E1A16),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
    BoxShadow(
      color: Color(0x051E1A16),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  /// Standard card elevation (alias for [card3D]).
  static const List<BoxShadow> card = card3D;

  /// High-altitude shadow configured for floating navigation islands and pinned action bars.
  static const List<BoxShadow> floatingIsland = [
    BoxShadow(
      color: Color(0x1F0D1528),
      offset: Offset(0, 12),
      blurRadius: 36,
      spreadRadius: -4,
    ),
    BoxShadow(
      color: Color(0x0A0D1528),
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
  ];

  /// Standard elevated component shadow (alias for [floatingIsland]).
  static const List<BoxShadow> elevated = floatingIsland;

  /// Radiant gold luminescence underglow for active cards and featured badges.
  static const List<BoxShadow> glowGold = [
    BoxShadow(
      color: Color(0x40CEA359),
      offset: Offset(0, 6),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Color(0x1ACEA359),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  /// Floating badge and pill component shadow.
  static const List<BoxShadow> badge = [
    BoxShadow(
      color: Color(0x0D1E1A16),
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x2E1E1A16),
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];

  /// Deep backdrop shadow for bottom sheets, alert dialogs, and overlays.
  static const List<BoxShadow> modalDeep = [
    BoxShadow(
      color: Color(0x2C0D1528),
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x140D1528),
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];
}
