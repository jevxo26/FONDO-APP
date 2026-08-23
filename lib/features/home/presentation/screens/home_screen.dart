import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../router/routes.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final greeting = _getGreeting();

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 4),
              child: Text(
                greeting,
                style: AppTypography.small(isDark: isDark).copyWith(
                  color: isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForegroundLight,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      'Hello, ${user.name}!',
                      style: AppTypography.titleLarge(isDark: isDark),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'FONDO',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: (isDark ? Colors.white : Colors.black)
                      .withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: (isDark ? Colors.white : Colors.black)
                        .withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search dishes, categories...',
                        style: AppTypography.bodyMedium(isDark: isDark)
                            .copyWith(
                          color: isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 96,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _CategoryPill(
                    icon: Icons.breakfast_dining_outlined,
                    label: 'Breakfast',
                    isDark: isDark,
                    onTap: () =>
                        context.push('${AppRoutes.home}/catalog/Breakfast'),
                  ),
                  _CategoryPill(
                    icon: Icons.lunch_dining_outlined,
                    label: 'Lunch',
                    isDark: isDark,
                    onTap: () =>
                        context.push('${AppRoutes.home}/catalog/Lunch'),
                  ),
                  _CategoryPill(
                    icon: Icons.dinner_dining_outlined,
                    label: 'Dinner',
                    isDark: isDark,
                    onTap: () =>
                        context.push('${AppRoutes.home}/catalog/Dinner'),
                  ),
                  _CategoryPill(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Groceries',
                    isDark: isDark,
                    onTap: () =>
                        context.push('${AppRoutes.home}/catalog/Groceries'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
              child: Text(
                "Today's Picks",
                style: AppTypography.titleLarge(isDark: isDark),
              ),
            ),
            _loading
                ? SizedBox(
                    height: 160,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: const [
                        _FoodCardPlaceholder(),
                        SizedBox(width: 12),
                        _FoodCardPlaceholder(),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount:
                          mockFoods.length > 6 ? 6 : mockFoods.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final food = mockFoods[index];
                        return GestureDetector(
                          onTap: () =>
                              context.push('/food-detail/${food.id}'),
                          child: Container(
                            width: 140,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.cardDark
                                  : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.restaurant_outlined,
                                    color: AppColors.primary,
                                    size: 24,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  food.name,
                                  style:
                                      AppTypography.label(isDark: isDark),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '৳${food.price.toStringAsFixed(0)}',
                                  style: AppTypography.small(
                                          isDark: isDark)
                                      .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Text(
                'All Categories',
                style: AppTypography.titleLarge(isDark: isDark),
              ),
            ),
            if (!_loading)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _CategoryCard(
                      icon: Icons.breakfast_dining_outlined,
                      title: 'Breakfast',
                      subtitle: 'Start your day right',
                      isDark: isDark,
                      onTap: () => context
                          .push('${AppRoutes.home}/catalog/Breakfast'),
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: Icons.lunch_dining_outlined,
                      title: 'Lunch',
                      subtitle: 'Midday fuel, delivered fresh',
                      isDark: isDark,
                      onTap: () =>
                          context.push('${AppRoutes.home}/catalog/Lunch'),
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: Icons.dinner_dining_outlined,
                      title: 'Dinner',
                      subtitle: 'End your day with flavour',
                      isDark: isDark,
                      onTap: () =>
                          context.push('${AppRoutes.home}/catalog/Dinner'),
                    ),
                    const SizedBox(height: 12),
                    _CategoryCard(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Groceries',
                      subtitle: 'Fresh ingredients at your door',
                      isDark: isDark,
                      onTap: () => context
                          .push('${AppRoutes.home}/catalog/Groceries'),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}

class _CategoryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryPill({
    required this.icon,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: AppTypography.small(isDark: isDark)
                  .copyWith(fontSize: 11),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? AppColors.borderDark
                  : AppColors.borderLight,
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
        ),
      ),
    );
  }
}

class _FoodCardPlaceholder extends StatelessWidget {
  const _FoodCardPlaceholder();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final skeletonBase = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return Container(
      width: 140,
      height: 160,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: skeletonBase,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const Spacer(),
          Container(
            width: 80,
            height: 10,
            decoration: BoxDecoration(
              color: skeletonBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 40,
            height: 10,
            decoration: BoxDecoration(
              color: skeletonBase,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}
