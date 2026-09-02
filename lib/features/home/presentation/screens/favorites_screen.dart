import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/food_item.dart';
import '../../../../router/routes.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _loading = true;
  String _orderType = 'Delivery'; // 'Delivery' or 'Pick-up'
  String _categoryFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _addToCart(FoodItem food) {
    HapticFeedback.lightImpact();
    ref.read(cartProvider.notifier).addItem(food);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart!'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: AppColors.primary,
          onPressed: () => context.push(AppRoutes.cart),
        ),
      ),
    );
  }

  void _removeFavorite(FoodItem food) {
    HapticFeedback.mediumImpact();
    ref.read(wishlistProvider.notifier).remove(food.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed ${food.name} from favorites'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allFavorites = ref.watch(wishlistProvider).items;

    if (_loading) {
      return _buildLoadingState(isDark: isDark);
    }

    // Split favorites by Tab
    final mealFavorites = allFavorites.where((f) => f.category != 'Grocery' && f.category != 'Essentials').toList();
    final shopFavorites = allFavorites.where((f) => f.category == 'Grocery' || f.category == 'Essentials').toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Favourites'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              labelColor: AppColors.primaryForeground,
              unselectedLabelColor: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              tabs: [
                Tab(text: 'Restaurants & Meals (${mealFavorites.length})'),
                Tab(text: 'Shops & Packages (${shopFavorites.length})'),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 12),
                // Delivery vs Pick-up filter pills (matching Reference image23.jpg)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      _FilterPill(
                        label: 'Delivery',
                        icon: Icons.delivery_dining_rounded,
                        selected: _orderType == 'Delivery',
                        onTap: () => setState(() => _orderType = 'Delivery'),
                        isDark: isDark,
                      ),
                      const SizedBox(width: 8),
                      _FilterPill(
                        label: 'Pick-up',
                        icon: Icons.shopping_bag_outlined,
                        selected: _orderType == 'Pick-up',
                        onTap: () => setState(() => _orderType = 'Pick-up'),
                        isDark: isDark,
                      ),
                      const Spacer(),
                      if (allFavorites.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite_rounded, color: AppColors.primary, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                '${allFavorites.length} Saved',
                                style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                // TabBarView for Meals and Shops
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildFavoritesGrid(
                        items: mealFavorites,
                        emptySubtitle: 'Save your favorite biryani, pizzas, burgers, and curries for 1-tap reordering.',
                        isDark: isDark,
                      ),
                      _buildFavoritesGrid(
                        items: shopFavorites,
                        emptySubtitle: 'Save regular grocery essentials, fruits, and meal plan packages for easy access.',
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesGrid({
    required List<FoodItem> items,
    required String emptySubtitle,
    required bool isDark,
  }) {
    if (items.isEmpty) {
      return _EmptyFavorites(
        isDark: isDark,
        subtitle: emptySubtitle,
      );
    }

    final categories = <String>{'All', ...items.map((f) => f.category)};
    final filtered = _categoryFilter == 'All'
        ? items
        : items.where((f) => f.category == _categoryFilter).toList();

    return Column(
      children: [
        if (categories.length > 2) ...[
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                for (final cat in categories) ...[
                  _CategoryChip(
                    label: cat,
                    selected: _categoryFilter == cat,
                    onTap: () => setState(() => _categoryFilter = cat),
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.76,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final food = filtered[index];
              return _FavoriteCard(
                food: food,
                isDark: isDark,
                onAddToCart: () => _addToCart(food),
                onRemove: () => _removeFavorite(food),
                onTap: () => context.push('${AppRoutes.foodDetail}/${food.id}'),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState({required bool isDark}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Favourites'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: const [
                  SkeletonBox(width: 90, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 90, height: 34, radius: 20),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.76,
                ),
                itemCount: 4,
                itemBuilder: (context, index) => const _FavoriteCardSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _FilterPill({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? AppColors.primaryForeground : (isDark ? Colors.white70 : Colors.black87),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.primaryForeground : (isDark ? Colors.white : Colors.black87),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool isDark;

  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.15)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? AppColors.primary : (isDark ? Colors.white70 : Colors.black54),
            fontSize: 12,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final bool isDark;
  final String subtitle;

  const _EmptyFavorites({required this.isDark, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 44,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              "Let's find some favourites",
              style: AppTypography.titleLarge(isDark: isDark).copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.explore_outlined, size: 20),
              label: const Text('Browse Menu'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _FavoriteCard({
    required this.food,
    required this.isDark,
    required this.onAddToCart,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GlassCard(
        padding: const EdgeInsets.all(12),
        radius: 18,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 42,
                        color: AppColors.primary.withValues(alpha: 0.45),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: InkWell(
                      onTap: onRemove,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_rounded,
                          size: 16,
                          color: AppColors.destructive,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              food.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.titleMedium(isDark: isDark).copyWith(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(food.category, style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11)),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                const SizedBox(width: 2),
                Text('${food.rating}', style: AppTypography.small(isDark: isDark).copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
                const SizedBox(width: 2),
                Text('(${food.ratingCount})', style: AppTypography.small(isDark: isDark).copyWith(fontSize: 10)),
                const Spacer(),
                Text(
                  '৳${food.price.toStringAsFixed(0)}',
                  style: AppTypography.price(isDark: isDark).copyWith(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonalIcon(
                onPressed: onAddToCart,
                icon: const Icon(Icons.add_shopping_cart_rounded, size: 15),
                label: const Text('Add to Cart', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                  foregroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCardSkeleton extends StatelessWidget {
  const _FavoriteCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SkeletonBox(width: double.infinity, height: double.infinity, radius: 14)),
          SizedBox(height: 10),
          SkeletonLine(width: 90),
          SizedBox(height: 6),
          SkeletonLine(width: 60),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 32, radius: 10),
        ],
      ),
    );
  }
}
