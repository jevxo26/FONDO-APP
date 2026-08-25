import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A reusable pill-shaped badge widget for status indicators.
///
/// Example usage:
/// ```dart
/// AppBadgePill(
///   label: 'Active',
///   variant: BadgeVariant.success,
/// )
/// ```
/// The widget follows the design guidelines from `DESIGN.md` §7.10.
class AppBadgePill extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  const AppBadgePill({
    super.key,
    required this.label,
    this.variant = BadgeVariant.defaultVariant,
  });

  Color get _backgroundColor => switch (variant) {
        BadgeVariant.success => AppColors.success.withValues(alpha: 0.10),
        BadgeVariant.warning => AppColors.warning.withValues(alpha: 0.10),
        BadgeVariant.danger => AppColors.destructive.withValues(alpha: 0.10),
        BadgeVariant.defaultVariant => AppColors.primary.withValues(alpha: 0.10),
      };

  Color get _textColor => switch (variant) {
        BadgeVariant.success => AppColors.success,
        BadgeVariant.warning => AppColors.warning,
        BadgeVariant.danger => AppColors.destructive,
        BadgeVariant.defaultVariant => AppColors.primary,
      };

  Color get _ringColor => switch (variant) {
        BadgeVariant.success => AppColors.success.withValues(alpha: 0.20),
        BadgeVariant.warning => AppColors.warning.withValues(alpha: 0.20),
        BadgeVariant.danger => AppColors.destructive.withValues(alpha: 0.20),
        BadgeVariant.defaultVariant => AppColors.primary.withValues(alpha: 0.20),
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(color: _ringColor, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
      ),
    );
  }
}

enum BadgeVariant { defaultVariant, success, warning, danger }
