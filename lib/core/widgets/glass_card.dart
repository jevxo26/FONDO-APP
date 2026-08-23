import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glassmorphic surface layer.
/// Backdrop blur with a translucent fill and a 5%-opacity primary border.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.radius = 16,
    this.onTap,
    this.color,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface =
        color ??
        (isDark ? AppColors.cardDark : AppColors.cardLight).withValues(
          alpha: 0.72,
        );

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: borderColor ?? AppColors.primary.withValues(alpha: 0.05),
            ),
          ),
          child: child,
        ),
      ),
    );

    if (onTap == null) {
      return Stack(
        children: [
          card,
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 1,
              height: radius,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66FFFFFF),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    }
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          card,
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 1,
              height: radius,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x66FFFFFF),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
