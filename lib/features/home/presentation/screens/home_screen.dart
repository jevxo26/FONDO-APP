import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = mockUser;
    final primaryAddress = mockAddresses.isNotEmpty ? mockAddresses.first : null;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'DELIVER TO',
              style: AppTypography.label(isDark: isDark).copyWith(letterSpacing: 1.2),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 16, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  primaryAddress != null ? '${primaryAddress.label} - ${primaryAddress.street}' : 'Select Location',
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceDark : AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user.name}!',
                      style: AppTypography.titleLarge(isDark: isDark),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your account and delivery address are setup and verified. Ready to order!',
                      style: AppTypography.bodyMedium(isDark: isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Explore Categories',
                style: AppTypography.titleLarge(isDark: isDark),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 8),
                    _categoryCard(
                      icon: Icons.breakfast_dining_outlined,
                      title: 'Breakfast',
                      subtitle: 'Start your day right',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _categoryCard(
                      icon: Icons.lunch_dining_outlined,
                      title: 'Lunch',
                      subtitle: 'Midday fuel, delivered fresh',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _categoryCard(
                      icon: Icons.dinner_dining_outlined,
                      title: 'Dinner',
                      subtitle: 'End your day with flavour',
                      isDark: isDark,
                    ),
                    const SizedBox(height: 12),
                    _categoryCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Groceries',
                      subtitle: 'Fresh ingredients at your door',
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _categoryCard({
  required IconData icon,
  required String title,
  required String subtitle,
  required bool isDark,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: isDark ? AppColors.borderDark : AppColors.borderLight,
      ),
    ),
    child: Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.titleMedium(isDark: isDark),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: AppTypography.small(isDark: isDark),
              ),
            ],
          ),
        ),
        Icon(
          Icons.chevron_right_rounded,
          color: isDark
              ? AppColors.mutedForegroundDark
              : AppColors.mutedForegroundLight,
        ),
      ],
    ),
  );
}
