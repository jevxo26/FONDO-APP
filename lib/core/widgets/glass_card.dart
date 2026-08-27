import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'press_scale.dart';

/// Glassmorphic surface layer with Apple-tier optical physics:
/// - 28px Backdrop blur
/// - Top-left 1px specular gradient rim
/// - Optional 45-degree diamond corner accent
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final bool showDiamondAccent;
  final bool enablePressScale;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    this.onTap,
    this.color,
    this.borderColor,
    this.showDiamondAccent = false,
    this.enablePressScale = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = color ??
        (isDark ? AppColors.cardDark : AppColors.cardLight).withValues(
          alpha: isDark ? 0.75 : 0.82,
        );

    final effectiveBorder = borderColor ??
        (isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight);

    final cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: effectiveBorder,
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );

    final cardWithSpecular = Stack(
      children: [
        cardContent,
        // Top-left specular gradient rim highlight
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 1.2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
              gradient: isDark
                  ? AppColors.specularBorderDark
                  : AppColors.specularBorderLight,
            ),
          ),
        ),
        // Optional top-right geometric diamond detail
        if (showDiamondAccent)
          Positioned(
            top: 10,
            right: 10,
            child: Transform.rotate(
              angle: 0.785398, // 45 degrees
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
            ),
          ),
      ],
    );

    if (onTap != null && enablePressScale) {
      return PressScale(
        onTap: onTap,
        child: cardWithSpecular,
      );
    } else if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: cardWithSpecular,
      );
    }

    return cardWithSpecular;
  }
}
