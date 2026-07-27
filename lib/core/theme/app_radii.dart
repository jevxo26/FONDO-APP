import 'package:flutter/material.dart';

/// Border radii definitions from `docs/DESIGN.md` §6
class AppRadii {
  AppRadii._();

  static const double smVal = 6.0; // 0.375rem
  static const double mdVal = 8.0; // 0.5rem
  static const double lgVal = 10.0; // 0.625rem (default cards, inputs)
  static const double xlVal = 14.0; // 0.875rem
  static const double radius2xlVal = 18.0; // 1.125rem (buttons, food cards)
  static const double radius3xlVal = 22.0; // 1.375rem (dashboards, premium containers)
  static const double radius4xlVal = 26.0; // 1.625rem (hero containers)
  static const double fullVal = 9999.0;

  static const BorderRadius sm = BorderRadius.all(Radius.circular(smVal));
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdVal));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgVal));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlVal));
  static const BorderRadius radius2xl = BorderRadius.all(Radius.circular(radius2xlVal));
  static const BorderRadius radius3xl = BorderRadius.all(Radius.circular(radius3xlVal));
  static const BorderRadius radius4xl = BorderRadius.all(Radius.circular(radius4xlVal));
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullVal));
}
