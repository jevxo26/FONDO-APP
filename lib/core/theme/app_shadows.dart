import 'package:flutter/material.dart';

/// Multi-layer directional physics shadows
class AppShadows {
  AppShadows._();

  // Subtle single-layer flat surface
  static const List<BoxShadow> surfaceFlat = [
    BoxShadow(
      color: Color(0x0A1E1A16), // ambient 4%
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  // 3-layer 3D Card: Ambient + Key + Rim
  static const List<BoxShadow> card3D = [
    BoxShadow(
      color: Color(0x0A1E1A16), // ambient
      offset: Offset(0, 2),
      blurRadius: 12,
    ),
    BoxShadow(
      color: Color(0x0F1E1A16), // key
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
    BoxShadow(
      color: Color(0x051E1A16), // rim
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> card = card3D;

  // Floating Island navigation bar & floating action surfaces
  static const List<BoxShadow> floatingIsland = [
    BoxShadow(
      color: Color(0x1F0D1528), // 12% deep ambient
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

  static const List<BoxShadow> elevated = floatingIsland;

  // Gold radiant underglow
  static const List<BoxShadow> glowGold = [
    BoxShadow(
      color: Color(0x40CEA359), // primary gold 25%
      offset: Offset(0, 6),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Color(0x1ACEA359),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

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
