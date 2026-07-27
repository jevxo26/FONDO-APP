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
}
