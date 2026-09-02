import 'package:flutter/material.dart';

/// Central design system border radii constants.
class AppRadii {
  AppRadii._();

  /// Small corner radius scalar value (6.0px).
  static const double smVal = 6.0;

  /// Medium corner radius scalar value (10.0px).
  static const double mdVal = 10.0;

  /// Large corner radius scalar value (16.0px).
  static const double lgVal = 16.0;

  /// Extra large corner radius scalar value (20.0px).
  static const double xlVal = 20.0;

  /// 2XL corner radius scalar value (26.0px).
  static const double radius2xlVal = 26.0;

  /// 3XL corner radius scalar value (36.0px).
  static const double radius3xlVal = 36.0;

  /// Full circular pill radius scalar value.
  static const double fullVal = 9999.0;

  /// Small border radius (6px) used for tags and small badges.
  static const BorderRadius sm = BorderRadius.all(Radius.circular(smVal));

  /// Medium border radius (10px) used for chips and inner inputs.
  static const BorderRadius md = BorderRadius.all(Radius.circular(mdVal));

  /// Large border radius (16px) used for buttons and standard cards.
  static const BorderRadius lg = BorderRadius.all(Radius.circular(lgVal));

  /// Extra large border radius (20px) used for modal surfaces and cards.
  static const BorderRadius xl = BorderRadius.all(Radius.circular(xlVal));

  /// 2XL border radius (26px) used for large hero cards and sheets.
  static const BorderRadius radius2xl = BorderRadius.all(Radius.circular(radius2xlVal));

  /// 3XL border radius (36px) used for prominent floating containers.
  static const BorderRadius radius3xl = BorderRadius.all(Radius.circular(radius3xlVal));

  /// Fully rounded circular border radius for stadium buttons and pills.
  static const BorderRadius full = BorderRadius.all(Radius.circular(fullVal));
}
