import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.card_giftcard_outlined,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'Meal Packages',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 10),
            Text(
              'Subscribe to weekly or monthly meal plans — coming soon.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
