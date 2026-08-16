import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/food_item.dart';
import '../../../../router/routes.dart';

class FavoritesScreen extends ConsumerStatefulWidget {
  const FavoritesScreen({super.key});

  @override
  ConsumerState<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends ConsumerState<FavoritesScreen> {
  bool _loading = true;
  String _filter = 'All';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _addToCart(FoodItem food) {
    HapticFeedback.lightImpact();
    ref.read(cartProvider.notifier).addItem(food);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${food.name} added to cart'),
        behavior: SnackBarBehavior.floating,
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
    final favorites = ref.watch(wishlistProvider).items;

    if (_loading) {
      return _buildLoadingState(isDark: isDark);
    }

    final categories = <String>{'All', ...favorites.map((f) => f.category)};
    final filtered = _filter == 'All'
        ? favorites
        : favorites.where((f) => f.category == _filter).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Favorites'),
      ),
      body: SafeArea(
        child: favorites.isEmpty
            ? _EmptyFavorites(isDark: isDark)
            : Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      children: [
                        for (final category in categories) ...[
                          _FilterChip(
                            label: category,
                            selected: _filter == category,
                            onTap: () => setState(() => _filter = category),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: filtered.isEmpty
                        ? Center(
                            child: Text(
                              'No favorites in $_filter',
                              style: AppTypography.bodyMedium(isDark: isDark),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.78,
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
              ),
      ),
    );
  }

  Widget _buildLoadingState({required bool isDark}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Favorites'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 8),
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: const [
                  SkeletonBox(width: 56, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 84, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 72, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 96, height: 34, radius: 20),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.78,
                ),
                itemCount: 6,
                itemBuilder: (context, index) => const _FavoriteCardSkeleton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  final bool isDark;

  const _EmptyFavorites({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 40,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No favorites yet',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap the heart on any dish to save it here for quick reordering.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.explore_outlined, size: 20),
              label: const Text('Browse Menu'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.label(isDark: isDark).copyWith(
            color: selected ? AppColors.primaryForeground : null,
            fontSize: 13,
          ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.restaurant_rounded,
                      size: 40,
                      color: AppColors.primary.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      food.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.titleMedium(isDark: isDark),
                    ),
                  ),
                  InkWell(
                    onTap: onRemove,
                    borderRadius: BorderRadius.circular(10),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.favorite_rounded,
                        size: 18,
                        color: AppColors.destructive,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(food.category, style: AppTypography.small(isDark: isDark)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                  const SizedBox(width: 2),
                  Text('${food.rating}', style: AppTypography.small(isDark: isDark).copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(width: 2),
                  Text('(${food.ratingCount})', style: AppTypography.small(isDark: isDark)),
                  const Spacer(),
                  Text(
                    '৳${food.price.toStringAsFixed(0)}',
                    style: AppTypography.price(isDark: isDark).copyWith(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: onAddToCart,
                  icon: const Icon(Icons.add_shopping_cart_rounded, size: 16),
                  label: const Text('Add to Cart', style: TextStyle(fontSize: 12)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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

class _FavoriteCardSkeleton extends StatelessWidget {
  const _FavoriteCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: SkeletonBox(width: double.infinity, height: double.infinity, radius: 12)),
          SizedBox(height: 10),
          SkeletonLine(width: 90),
          SizedBox(height: 6),
          SkeletonLine(width: 60),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 34, radius: 10),
        ],
      ),
    );
  }
}
