import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A horizontal divider that uses the gold gradient defined in the design system (§7.5).
///
/// Usage: Place inside a Column or Row where a visual separation is needed.
class GoldDivider extends StatelessWidget {
  const GoldDivider({
    super.key,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
  });

  final double thickness;
  final double indent;
  final double endIndent;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.only(start: indent, end: endIndent),
      height: thickness,
      decoration: const BoxDecoration(
        gradient: AppColors.goldDividerGradient,
      ),
    );
  }
}
