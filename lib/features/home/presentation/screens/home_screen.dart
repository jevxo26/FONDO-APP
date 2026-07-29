import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/food_card_skeleton.dart';
import '../../../../models/food_item.dart';

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

  void _addDemoItems() {
    final food = ref.read(cartProvider.notifier);
    food.addItem(
      const FoodItem(
        id: 'demo_1',
        name: 'Chicken Biryani',
        description: 'Fragrant basmati rice with tender chicken',
        price: 180,
        category: 'Lunch',
        rating: 4.5,
        ratingCount: 128,
      ),
    );
    food.addItem(
      const FoodItem(
        id: 'demo_2',
        name: 'Paratha & Dal',
        description: 'Crispy layered paratha with lentil curry',
        price: 120,
        category: 'Breakfast',
        rating: 4.2,
        ratingCount: 84,
      ),
    );
    food.addItem(
      const FoodItem(
        id: 'demo_3',
        name: 'Beef Khichuri',
        description: 'Slow-cooked rice lentils with beef',
        price: 250,
        category: 'Dinner',
        rating: 4.7,
        ratingCount: 56,
      ),
    );
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
                    if (!_loading) ...[
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _addDemoItems,
                              icon: const Icon(Icons.add_shopping_cart, size: 16),
                              label: const Text('Add Demo Items'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                side: const BorderSide(color: AppColors.primary),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                              ),
                            ),
                          ),
                          if (cartCount > 0) ...[
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '$cartCount in cart',
                                style: AppTypography.small(isDark: isDark)
                                    .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                _loading ? 'Loading…' : 'Explore Categories',
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
