import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.user;
    final primaryAddress = authState.addresses.isNotEmpty ? authState.addresses.first : null;
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
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout();
            },
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
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, ${user?.name ?? "Foodie"}! 👋',
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
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: 64,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Food Catalog Landing Handoff',
                        style: AppTypography.titleMedium(isDark: isDark),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Phase 2 food catalog & categories will build here.',
                        textAlign: TextAlign.center,
                        style: AppTypography.bodyMedium(isDark: isDark),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
