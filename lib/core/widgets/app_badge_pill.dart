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
    Key? key,
    required this.label,
    this.variant = BadgeVariant.defaultVariant,
  }) : super(key: key);

  Color get _backgroundColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.success.withOpacity(0.10);
      case BadgeVariant.warning:
        return AppColors.warning.withOpacity(0.10);
      case BadgeVariant.danger:
        return AppColors.destructive.withOpacity(0.10);
      case BadgeVariant.defaultVariant:
      default:
        return AppColors.primary.withOpacity(0.10);
    }
  }

  Color get _textColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.success;
      case BadgeVariant.warning:
        return AppColors.warning;
      case BadgeVariant.danger:
        return AppColors.destructive;
      case BadgeVariant.defaultVariant:
      default:
        return AppColors.primary;
    }
  }

  Color get _ringColor {
    switch (variant) {
      case BadgeVariant.success:
        return AppColors.success.withOpacity(0.20);
      case BadgeVariant.warning:
        return AppColors.warning.withOpacity(0.20);
      case BadgeVariant.danger:
        return AppColors.destructive.withOpacity(0.20);
      case BadgeVariant.defaultVariant:
      default:
        return AppColors.primary.withOpacity(0.20);
    }
  }

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
