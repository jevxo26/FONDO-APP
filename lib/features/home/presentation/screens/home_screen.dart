import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/food_item.dart';
import '../../../../router/routes.dart';
import '../providers/user_location_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _loading = true;
  String _selectedSort = 'Popular';
  bool _onlyHighRating = false;
  String? _selectedCategoryFilter;

  late final PageController _bannerController;
  int _currentBannerIndex = 0;
  Timer? _bannerTimer;

  final List<_PromoBannerData> _banners = const [
    _PromoBannerData(
      badge: 'FONDO PRO',
      title: 'Enjoy Epic PRO Deals',
      subtitle: 'Up to 40% OFF + Unlimited Free Delivery',
      gradientColors: [Color(0xFF99732B), Color(0xFFCEA359)],
      icon: Icons.workspace_premium_rounded,
    ),
    _PromoBannerData(
      badge: 'FREE DELIVERY',
      title: 'Zero Delivery Fee',
      subtitle: 'On all orders above ৳300 from top chefs',
      gradientColors: [Color(0xFF0D9488), Color(0xFF10B981)],
      icon: Icons.delivery_dining_rounded,
    ),
    _PromoBannerData(
      badge: "CHEF'S SPECIAL",
      title: 'Freshly Curated Meals',
      subtitle: 'Handcrafted daily home-style recipes',
      gradientColors: [Color(0xFF854D0E), Color(0xFFD97706)],
      icon: Icons.restaurant_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _bannerController = PageController();
    _startBannerTimer();

    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _startBannerTimer() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (!mounted || !_bannerController.hasClients) return;
      final next = (_currentBannerIndex + 1) % _banners.length;
      _bannerController.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  List<FoodItem> get _filteredFoods {
    var list = [...mockFoods];
    if (_selectedCategoryFilter != null) {
      list = list.where((f) => f.category == _selectedCategoryFilter).toList();
    }
    if (_onlyHighRating) {
      list = list.where((f) => f.rating >= 4.4).toList();
    }
    if (_selectedSort == 'Rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_selectedSort == 'Price: Low to High') {
      list.sort((a, b) => a.price.compareTo(b.price));
    } else if (_selectedSort == 'Price: High to Low') {
      list.sort((a, b) => b.price.compareTo(a.price));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final wishlistCount = ref.watch(wishlistProvider).count;

    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLocationBar(context, isDark, wishlistCount),
            const SizedBox(height: 14),
            _buildSearchHeader(context, isDark),
            const SizedBox(height: 14),
            _buildQuickActionChips(context, isDark),
            const SizedBox(height: 18),
            _buildPromoCarousel(isDark),
            const SizedBox(height: 22),
            _buildFilterChipsRow(isDark),
            const SizedBox(height: 20),
            _buildTodaysPicksSection(context, isDark),
            const SizedBox(height: 28),
            _buildPopularDishesSection(context, isDark),
            const SizedBox(height: 28),
            _buildCategoriesSection(context, isDark),
            const SizedBox(height: 110),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBar(BuildContext context, bool isDark, int wishlistCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => _showLocationSelector(context, isDark),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Deliver to',
                        style: AppTypography.small(isDark: isDark).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 14,
                        color: isDark
                            ? AppColors.mutedForegroundDark
                            : AppColors.mutedForegroundLight,
                      ),
                    ],
                  ),
                  Text(
                    ref.watch(userLocationProvider),
                    style: AppTypography.label(isDark: isDark).copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => context.push(AppRoutes.favorites),
            style: IconButton.styleFrom(
              backgroundColor: isDark
                  ? AppColors.cardDark
                  : AppColors.cardLight,
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: Badge(
              isLabelVisible: wishlistCount > 0,
              label: Text('$wishlistCount'),
              backgroundColor: AppColors.primary,
              child: Icon(
                wishlistCount > 0
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                color: wishlistCount > 0
                    ? AppColors.primary
                    : (isDark ? Colors.white70 : Colors.black87),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => context.go('/search'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 13,
                ),
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
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search for dishes, restaurants & groceries...',
                        style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                          fontSize: 13.5,
                          color: isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context, isDark),
            child: Container(
              padding: const EdgeInsets.all(13),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.tune_rounded,
                size: 20,
                color: AppColors.primaryForeground,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChips(BuildContext context, bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _QuickChip(
            icon: Icons.percent_rounded,
            label: 'Offers 40% OFF',
            color: AppColors.primary,
            isDark: isDark,
            onTap: () {
              setState(() {
                _onlyHighRating = false;
                _selectedSort = 'Popular';
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Applied FONDO PRO 40% Discount filter'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _QuickChip(
            icon: Icons.confirmation_number_outlined,
            label: 'Vouchers ৳50',
            color: const Color(0xFF10B981),
            isDark: isDark,
            onTap: () {
              ref.read(cartProvider.notifier).applyCoupon('FONDO50');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Promo code FONDO50 applied to Cart!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
          _QuickChip(
            icon: Icons.bolt_rounded,
            label: 'Fast Delivery',
            color: const Color(0xFFF59E0B),
            isDark: isDark,
            onTap: () {
              setState(() {
                _selectedSort = 'Price: Low to High';
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCarousel(bool isDark) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _bannerController,
            onPageChanged: (i) => setState(() => _currentBannerIndex = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: banner.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: banner.gradientColors.first.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -15,
                        top: -15,
                        child: Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.12),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        bottom: 16,
                        child: Icon(
                          banner.icon,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.22),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                banner.badge,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              banner.subtitle,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _currentBannerIndex;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active
                    ? AppColors.primary
                    : (isDark ? Colors.white24 : Colors.black12),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildFilterChipsRow(bool isDark) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _FilterActionChip(
            label: 'Sort: $_selectedSort',
            icon: Icons.swap_vert_rounded,
            isActive: _selectedSort != 'Popular',
            isDark: isDark,
            onTap: () => _showSortSelector(context, isDark),
          ),
          const SizedBox(width: 8),
          _FilterActionChip(
            label: '★ 4.4+ Rated',
            isActive: _onlyHighRating,
            isDark: isDark,
            onTap: () => setState(() => _onlyHighRating = !_onlyHighRating),
          ),
          const SizedBox(width: 8),
          ...['Breakfast', 'Lunch', 'Dinner', 'Groceries'].map((cat) {
            final selected = _selectedCategoryFilter == cat;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _FilterActionChip(
                label: cat,
                isActive: selected,
                isDark: isDark,
                onTap: () {
                  setState(() {
                    _selectedCategoryFilter = selected ? null : cat;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTodaysPicksSection(BuildContext context, bool isDark) {
    final picks = mockFoods.take(5).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Picks",
                    style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Chef-recommended daily specials',
                    style: AppTypography.small(isDark: isDark),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => context.push('${AppRoutes.home}/catalog/All'),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_loading)
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                _PicksSkeletonCard(),
                SizedBox(width: 14),
                _PicksSkeletonCard(),
              ],
            ),
          )
        else
          SizedBox(
            height: 216,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: picks.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final food = picks[index];
                return _TodaysPickCard(
                  food: food,
                  isDark: isDark,
                  onTap: () => context.push('/food-detail/${food.id}'),
                  onAdd: () {
                    HapticFeedback.lightImpact();
                    ref.read(cartProvider.notifier).addItem(food);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${food.name} added to cart!'),
                        duration: const Duration(milliseconds: 1200),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPopularDishesSection(BuildContext context, bool isDark) {
    final foods = _filteredFoods;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Popular Dishes',
                    style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Most ordered by food lovers around you',
                    style: AppTypography.small(isDark: isDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${foods.length} items',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        if (_loading)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: const [
                _PopularSkeletonCard(),
                SizedBox(height: 12),
                _PopularSkeletonCard(),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: foods.length,
              separatorBuilder: (_, _) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final food = foods[index];
                return _PopularDishCard(
                  food: food,
                  isDark: isDark,
                  onTap: () => context.push('/food-detail/${food.id}'),
                  onAdd: () {
                    HapticFeedback.lightImpact();
                    ref.read(cartProvider.notifier).addItem(food);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${food.name} added to cart!'),
                        duration: const Duration(milliseconds: 1200),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildCategoriesSection(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Explore Categories',
            style: AppTypography.headlineMedium(isDark: isDark).copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _CategoryGridCard(
                icon: Icons.breakfast_dining_outlined,
                title: 'Breakfast',
                itemCount: '3 items',
                isDark: isDark,
                onTap: () => context.push('${AppRoutes.home}/catalog/Breakfast'),
              ),
              _CategoryGridCard(
                icon: Icons.lunch_dining_outlined,
                title: 'Lunch',
                itemCount: '3 items',
                isDark: isDark,
                onTap: () => context.push('${AppRoutes.home}/catalog/Lunch'),
              ),
              _CategoryGridCard(
                icon: Icons.dinner_dining_outlined,
                title: 'Dinner',
                itemCount: '3 items',
                isDark: isDark,
                onTap: () => context.push('${AppRoutes.home}/catalog/Dinner'),
              ),
              _CategoryGridCard(
                icon: Icons.shopping_bag_outlined,
                title: 'Groceries',
                itemCount: '3 items',
                isDark: isDark,
                onTap: () => context.push('${AppRoutes.home}/catalog/Groceries'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLocationSelector(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final addresses = [
          'House 12, Road 5, Dhanmondi',
          'Flat 4B, Banani DOHS, Dhaka',
          'Floor 7, Gulshan 2, Dhaka',
          'Uttara Sector 3, Dhaka',
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Delivery Address',
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...addresses.map((addr) {
                final currentLocation = ref.watch(userLocationProvider);
                final isSelected = addr == currentLocation;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    Icons.location_on_outlined,
                    color: isSelected ? AppColors.primary : null,
                  ),
                  title: Text(
                    addr,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    ref.read(userLocationProvider.notifier).state = addr;
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSortSelector(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final options = [
          'Popular',
          'Rating',
          'Price: Low to High',
          'Price: High to Low',
        ];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Sort By',
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 14),
              ...options.map((opt) {
                final isSelected = opt == _selectedSort;
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    opt,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() => _selectedSort = opt);
                    Navigator.pop(ctx);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showFilterBottomSheet(BuildContext context, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filters',
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Top Rated Only (★ 4.4+)'),
                value: _onlyHighRating,
                activeThumbColor: AppColors.primary,
                onChanged: (val) {
                  setState(() => _onlyHighRating = val);
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _onlyHighRating = false;
                    _selectedCategoryFilter = null;
                    _selectedSort = 'Popular';
                  });
                  Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  backgroundColor: isDark ? Colors.white12 : Colors.black12,
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  minimumSize: const Size(double.infinity, 46),
                ),
                child: const Text('Reset All Filters'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PromoBannerData {
  final String badge;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final IconData icon;

  const _PromoBannerData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.icon,
  });
}

class _QuickChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickChip({
    required this.icon,
    required this.label,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterActionChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _FilterActionChip({
    required this.label,
    this.icon,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.primary
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: 1,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isActive
                    ? AppColors.primaryForeground
                    : (isDark ? Colors.white70 : Colors.black87),
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryForeground
                    : (isDark ? Colors.white : Colors.black87),
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TodaysPickCard extends StatelessWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _TodaysPickCard({
    required this.food,
    required this.isDark,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.restaurant_outlined,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFF10B981),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${food.rating}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              food.name,
              style: AppTypography.label(isDark: isDark).copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 12,
                  color: isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForegroundLight,
                ),
                const SizedBox(width: 3),
                Text(
                  '20-30 min',
                  style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '৳${food.price.toStringAsFixed(0)}',
                  style: AppTypography.price(isDark: isDark).copyWith(
                    fontSize: 15,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      size: 16,
                      color: AppColors.primaryForeground,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PopularDishCard extends StatelessWidget {
  final FoodItem food;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const _PopularDishCard({
    required this.food,
    required this.isDark,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 76,
                  height: 76,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      '15% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: AppTypography.label(isDark: isDark).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    food.description,
                    style: AppTypography.small(isDark: isDark).copyWith(
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${food.rating} (${food.ratingCount})',
                        style: AppTypography.small(isDark: isDark).copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Icon(
                        Icons.schedule_rounded,
                        size: 13,
                        color: isDark
                            ? AppColors.mutedForegroundDark
                            : AppColors.mutedForegroundLight,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '25 min',
                        style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '৳${food.price.toStringAsFixed(0)}',
                  style: AppTypography.price(isDark: isDark).copyWith(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  '৳${(food.price * 1.15).toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 11,
                    decoration: TextDecoration.lineThrough,
                    color: isDark
                        ? AppColors.mutedForegroundDark
                        : AppColors.mutedForegroundLight,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onAdd,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String itemCount;
  final bool isDark;
  final VoidCallback onTap;

  const _CategoryGridCard({
    required this.icon,
    required this.title,
    required this.itemCount,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTypography.label(isDark: isDark).copyWith(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    itemCount,
                    style: AppTypography.small(isDark: isDark).copyWith(fontSize: 10.5),
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

class _PicksSkeletonCard extends StatelessWidget {
  const _PicksSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _PopularSkeletonCard extends StatelessWidget {
  const _PopularSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
