import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radii.dart';
import 'app_skeleton.dart';

class FoodCardSkeleton extends StatelessWidget {
  final double height;

  const FoodCardSkeleton({super.key, this.height = 140});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.cardLight;
    final skeletonBase = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: AppRadii.radius2xl,
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          AppSkeleton(
            child: Container(
              width: 108,
              height: double.infinity,
              decoration: BoxDecoration(
                color: skeletonBase,
                borderRadius: AppRadii.xl,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Line(width: w * 0.65, isDark: isDark),
                    const SizedBox(height: 10),
                    _Line(width: w * 0.9, isDark: isDark),
                    const SizedBox(height: 6),
                    _Line(width: w * 0.45, isDark: isDark),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _Line(width: w * 0.2, isDark: isDark),
                        const Spacer(),
                        _Line(width: w * 0.15, isDark: isDark),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Line extends StatelessWidget {
  final double width;
  final bool isDark;

  const _Line({required this.width, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final skeletonBase = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return AppSkeleton(
      child: Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: skeletonBase,
          borderRadius: AppRadii.sm,
        ),
      ),
    );
  }
}
