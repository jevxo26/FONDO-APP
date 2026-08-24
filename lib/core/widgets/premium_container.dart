import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';

/// A premium container that applies the warm‑gold gradient background,
/// depth‑layer blur orbs, a diamond corner, and rounded‑3xl corners.
/// All content is clipped to the rounded border.
class PremiumContainer extends StatelessWidget {
  const PremiumContainer({
    super.key,
    required this.child,
    this.isDark = false,
  });

  final Widget child;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    // Gradient background (warm gold) as defined in DESIGN.md §7.1
    final gradient = AppColors.warmGoldGradient;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Gradient background with rounded corners
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: AppRadii.radius3xl,
          ),
        ),
        // Blur orbs – depth layers (§7.2)
        const Positioned(
          bottom: -24,
          right: -24,
          child: _BlurOrb(size: 144, opacity: 0.08),
        ),
        const Positioned(
          top: -12,
          left: -12,
          child: _BlurOrb(size: 80, opacity: 0.05),
        ),
        const Positioned(
          top: -20,
          right: -20,
          child: _BlurOrb(size: 112, opacity: 0.05),
        ),
        // Diamond corner (§7.3)
        const Positioned(
          top: 12,
          right: 12,
          child: _DiamondCorner(),
        ),
        // Clip content to rounded corners and place child
        ClipRRect(
          borderRadius: AppRadii.radius3xl,
          child: child,
        ),
      ],
    );
  }
}

class _BlurOrb extends StatelessWidget {
  const _BlurOrb({required this.size, required this.opacity});
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _DiamondCorner extends StatelessWidget {
  const _DiamondCorner();
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785398, // 45° in radians
      child: Container(
        width: 7,
        height: 7,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
    );
  }
}
