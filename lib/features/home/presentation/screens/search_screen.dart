import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../models/food_item.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';
  List<String> _recentSearches = [
    'Royal Mutton Kacchi',
    'Special Tehari',
    'Seekh Kebab Platter',
    'Special Borhani',
  ];

  final List<String> _popularTags = [
    'Kacchi',
    'Tehari',
    'Mutton Rezala',
    'Seekh Kebab',
    'Chicken Roast',
    'Malai Curry',
    'Borhani',
    'Firni',
    'Combos',
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _query = _controller.text.trim();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredResults {
    if (_query.isEmpty) return [];
    final lower = _query.toLowerCase();
    return mockFoods.where((food) {
      final matchName = food.name.toLowerCase().contains(lower);
      final matchDesc = food.description.toLowerCase().contains(lower);
      final matchCat = food.category.toLowerCase().contains(lower);
      final matchIngredients = food.ingredients.any((i) => i.toLowerCase().contains(lower));
      final matchTags = food.dietaryTags.any((t) => t.toLowerCase().contains(lower));
      return matchName || matchDesc || matchCat || matchIngredients || matchTags;
    }).toList();
  }

  void _onSearchSubmit(String query) {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;
    if (!_recentSearches.contains(trimmed)) {
      setState(() {
        _recentSearches = [trimmed, ..._recentSearches.take(7)];
      });
    }
  }

  void _removeRecentSearch(String item) {
    setState(() {
      _recentSearches = _recentSearches.where((s) => s != item).toList();
    });
  }

  void _clearAllRecent() {
    setState(() {
      _recentSearches.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _filteredResults;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top Header & Search Input ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Search',
                    style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : AppColors.cardLight,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _onSearchSubmit,
                      style: AppTypography.bodyMedium(isDark: isDark),
                      decoration: InputDecoration(
                        hintText: 'Search dishes, restaurants & groceries...',
                        hintStyle: AppTypography.bodyMedium(isDark: isDark).copyWith(
                          fontSize: 13.5,
                          color: isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        suffixIcon: _query.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear_rounded, size: 18),
                                onPressed: () {
                                  _controller.clear();
                                },
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Body: Either Suggestions or Results ──
            Expanded(
              child: _query.isEmpty
                  ? _buildSuggestions(context, isDark)
                  : _buildResultsList(context, isDark, results),
            ),
          ],
        ),
      ),
    );
  }

  // ── Suggestions View (Recent + Popular) ──
  Widget _buildSuggestions(BuildContext context, bool isDark) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        // Recent Searches
        if (_recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTypography.label(isDark: isDark).copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: _clearAllRecent,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(50, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _recentSearches.map((item) {
              return Container(
                padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : AppColors.cardLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () {
                        _controller.text = item;
                        _controller.selection = TextSelection.fromPosition(
                          TextPosition(offset: item.length),
                        );
                      },
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => _removeRecentSearch(item),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Icon(
                          Icons.close_rounded,
                          size: 14,
                          color: isDark ? Colors.white54 : Colors.black45,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
        ],

        // Popular Searches
        Text(
          'Popular Searches',
          style: AppTypography.label(isDark: isDark).copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _popularTags.map((tag) {
            return GestureDetector(
              onTap: () {
                _controller.text = tag;
                _controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: tag.length),
                );
                _onSearchSubmit(tag);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tag,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ── Results View ──
  Widget _buildResultsList(
      BuildContext context, bool isDark, List<FoodItem> results) {
    if (results.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 64,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
              const SizedBox(height: 16),
              Text(
                'No dishes found for "$_query"',
                style: AppTypography.titleMedium(isDark: isDark).copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Try searching for something else like "Biryani", "Burger", or "Khichuri"',
                style: AppTypography.small(isDark: isDark),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${results.length} result${results.length == 1 ? '' : 's'} found',
              style: AppTypography.small(isDark: isDark).copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Instant Delivery',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...results.map((food) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SearchResultCard(
              food: food,
              isDark: isDark,
              onTap: () => context.push('/food-detail/${food.id}'),
              onAdd: () {
                HapticFeedback.lightImpact();
                ref.read(cartProvider.notifier).addItem(food);
                _onSearchSubmit(_query);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${food.name} added to cart!'),
                    duration: const Duration(milliseconds: 1200),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _SearchResultCard({
    required this.food,
    required this.isDark,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: AppColors.primary,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: AppTypography.label(isDark: isDark).copyWith(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          food.category,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${food.rating}',
                        style: AppTypography.small(isDark: isDark).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '৳${food.price.toStringAsFixed(0)}',
                    style: AppTypography.price(isDark: isDark).copyWith(
                      fontSize: 15,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.add_rounded,
                      size: 15,
                      color: AppColors.primaryForeground,
                    ),
                    SizedBox(width: 2),
                    Text(
                      'Add',
                      style: TextStyle(
                        color: AppColors.primaryForeground,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


