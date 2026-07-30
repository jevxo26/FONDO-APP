import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
              Icons.person_outline,
              size: 64,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 20),
            Text(
              'Your Profile',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 10),
            Text(
              'Manage your account, addresses and preferences.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
