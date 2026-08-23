import 'package:flutter/material.dart';

/// Shadow tokens from `docs/DESIGN.md` §5
class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0A1E1A16), // rgba(30,26,22,0.04)
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
    BoxShadow(
      color: Color(0x0F1E1A16), // rgba(30,26,22,0.06)
      offset: Offset(0, 8),
      blurRadius: 24,
    ),
  ];

  static const List<BoxShadow> badge = [
    BoxShadow(
      color: Color(0x0D1E1A16), // rgba(30,26,22,0.05)
      offset: Offset(0, 4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: Color(0x2E1E1A16), // rgba(30,26,22,0.18)
      offset: Offset(0, 24),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];

  static const List<BoxShadow> elevated = [
    BoxShadow(
      color: Color(0x1F0D1528), // rgba(13,21,40,0.12)
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -8,
    ),
    BoxShadow(
      color: Color(0x0F0D1528), // rgba(13,21,40,0.06)
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: -4,
    ),
  ];
  // New shadow tokens per DESIGN.md §5
  static const List<BoxShadow> surfaceFlat = [
    BoxShadow(
      color: Color(0x0A0A0A0A), // subtle flat surface shadow
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];

  static const List<BoxShadow> card3D = [
    BoxShadow(
      color: Color(0x1A1E1A16), // deeper shadow for 3D card effect
      offset: Offset(0, 4),
      blurRadius: 12,
    ),
    BoxShadow(
      color: Color(0x0F1E1A16),
      offset: Offset(0, 12),
      blurRadius: 32,
    ),
  ];

  static const List<BoxShadow> floatingIsland = [
    BoxShadow(
      color: Color(0x0C0D1528),
      offset: Offset(0, 6),
      blurRadius: 20,
    ),
    BoxShadow(
      color: Color(0x060D1528),
      offset: Offset(0, 2),
      blurRadius: 8,
    ),
  ];

  static const List<BoxShadow> glowGold = [
    BoxShadow(
      color: Color(0x33FFB800), // gold glow, 20% opacity
      offset: Offset(0, 0),
      blurRadius: 12,
    ),
    BoxShadow(
      color: Color(0x19FFB800), // softer outer glow
      offset: Offset(0, 0),
      blurRadius: 24,
    ),
  ];

  static const List<BoxShadow> modalDeep = [
    BoxShadow(
      color: Color(0x2C0D1528), // deep modal backdrop shadow
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
