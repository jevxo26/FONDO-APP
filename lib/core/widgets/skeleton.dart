import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'app_skeleton.dart';

class SkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const SkeletonLine({super.key, required this.width, this.height = 12});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return AppSkeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(color: base, borderRadius: AppRadii.sm),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return AppSkeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
