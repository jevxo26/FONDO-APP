import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/food_card_skeleton.dart';
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
    final user = mockUser;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartCount = ref.watch(cartProvider.select((s) => s.itemCount));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FONDO',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.surfaceDark
                    : AppColors.primarySurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                ),
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
            const SizedBox(height: 24),
            Text(
              'Explore Categories',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? ListView(
                      children: const [
                        FoodCardSkeleton(),
                        SizedBox(height: 12),
                        FoodCardSkeleton(),
                        SizedBox(height: 12),
                        FoodCardSkeleton(),
                      ],
                    )
                  : ListView(
                      children: [
                        _CategoryCard(
                          icon: Icons.breakfast_dining_outlined,
                          title: 'Breakfast',
                          subtitle: 'Start your day right',
                          isDark: isDark,
                          onTap: () => context.push(
                            '${AppRoutes.home}/catalog/Breakfast',
                          ),
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
                          onTap: () => context.push(
                            '${AppRoutes.home}/catalog/Groceries',
                          ),
                        ),
                        if (cartCount > 0) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: Text(
                              '$cartCount item${cartCount == 1 ? '' : 's'} in cart',
                              style: AppTypography.small(isDark: isDark)
                                  .copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
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
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 130),
      curve: Curves.easeOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isDark
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
                  child: Icon(widget.icon, color: AppColors.primary, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: AppTypography.titleMedium(isDark: widget.isDark),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: AppTypography.small(isDark: widget.isDark),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: widget.isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForegroundLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
