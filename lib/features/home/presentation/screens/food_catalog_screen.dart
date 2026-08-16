import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/food_item.dart';

class FoodCatalogScreen extends StatelessWidget {
  final String category;

  const FoodCatalogScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final foods = mockFoods.where((f) => f.category == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: foods.isEmpty
          ? Center(
              child: Text(
                'No items in $category',
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: foods.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _FoodCard(
                food: foods[index],
                isDark: isDark,
                onTap: () => context.push('/food-detail/${foods[index].id}'),
              ),
            ),
    );
  }
}

class _FoodCard extends StatefulWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onTap;

  const _FoodCard({
    required this.food,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<_FoodCard> {
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
            padding: const EdgeInsets.all(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_outlined,
                    color: AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.food.name,
                        style: AppTypography.titleMedium(isDark: widget.isDark),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.food.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.small(isDark: widget.isDark),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.food.rating}',
                            style: AppTypography.small(
                              isDark: widget.isDark,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${widget.food.ratingCount})',
                            style: AppTypography.small(isDark: widget.isDark),
                          ),
                          const Spacer(),
                          Text(
                            '৳${widget.food.price.toStringAsFixed(0)}',
                            style: AppTypography.price(isDark: widget.isDark),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
