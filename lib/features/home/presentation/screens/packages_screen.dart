import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/meal_plan.dart';

const List<MealPlan> _plans = [
  MealPlan(
    id: 'weekly',
    name: 'Weekly Starter',
    description:
        'Perfect for individuals who want freshly cooked meals every day without the hassle of cooking.',
    pricePerMeal: 120,
    mealsPerWeek: 7,
    minWeeks: 1,
    features: [
      'One meal per day',
      'Choose from rotating menu',
      'Free delivery',
      'Cancel anytime',
    ],
    dietaryOptions: ['Regular', 'Low Carb', 'High Protein', 'Vegetarian'],
  ),
  MealPlan(
    id: 'monthly',
    name: 'Monthly Premium',
    description:
        'Best value for regular customers. Enjoy two meals daily with priority support and exclusive dishes.',
    pricePerMeal: 100,
    mealsPerWeek: 14,
    minWeeks: 4,
    features: [
      'Two meals per day',
      'Priority delivery slot',
      'Exclusive weekly specials',
      'Free delivery',
      'Dedicated support',
    ],
    dietaryOptions: [
      'Regular',
      'Low Carb',
      'High Protein',
      'Vegetarian',
      'Keto',
      'Gluten Free',
    ],
  ),
  MealPlan(
    id: 'family',
    name: 'Family Plan',
    description:
        'Designed for families of 3–4. Bulk-prepared meals with variety for everyone at home.',
    pricePerMeal: 90,
    mealsPerWeek: 21,
    minWeeks: 2,
    features: [
      'Three meals per day (serves 3-4)',
      'Family-friendly recipes',
      'Customizable portions',
      'Free delivery',
      'Weekly menu voting',
    ],
    dietaryOptions: ['Regular', 'Low Carb', 'Vegetarian', 'Mixed (per person)'],
  ),
];

class PackagesScreen extends ConsumerStatefulWidget {
  const PackagesScreen({super.key});

  @override
  ConsumerState<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends ConsumerState<PackagesScreen> {
  bool _loading = true;
  String? _selectedPlanId;
  String _dietaryPreference = 'Regular';
  int _weeks = 1;
  String _selectedGroceryCat = 'All';

  final List<Map<String, dynamic>> _groceryCategories = const [
    {'name': 'All', 'icon': Icons.grid_view_rounded},
    {'name': 'Vegetables', 'icon': Icons.eco_outlined},
    {'name': 'Dairy & Eggs', 'icon': Icons.egg_outlined},
    {'name': 'Spices', 'icon': Icons.soup_kitchen_outlined},
    {'name': 'Snacks', 'icon': Icons.cookie_outlined},
  ];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  MealPlan? get _selectedPlan => _selectedPlanId == null
      ? null
      : _plans.firstWhere((p) => p.id == _selectedPlanId);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final groceryItems = mockFoods.where((f) => f.category == 'Groceries').toList();

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
        children: [
          // ── Header Title ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Grocery & Packages',
                    style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Fresh ingredients & weekly meal plans',
                    style: AppTypography.small(isDark: isDark),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.storefront_rounded, size: 16, color: AppColors.primary),
                    SizedBox(width: 4),
                    Text(
                      'FONDO Mart',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Express Service Area Status Banner ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A2F), const Color(0xFF132A22)]
                    : [const Color(0xFFE6F7ED), const Color(0xFFD4EFE0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF10B981).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.bolt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Express Grocery Delivery Active',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF047857),
                        ),
                      ),
                      Text(
                        'Guaranteed delivery in 15–25 mins to Dhanmondi',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white70 : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Grocery Category Pills ──
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _groceryCategories.map((cat) {
                final selected = _selectedGroceryCat == cat['name'];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedGroceryCat = cat['name'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.primary
                            : (isDark ? AppColors.cardDark : AppColors.cardLight),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected
                              ? AppColors.primary
                              : (isDark ? AppColors.borderDark : AppColors.borderLight),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            cat['icon'] as IconData,
                            size: 15,
                            color: selected
                                ? AppColors.primaryForeground
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            cat['name'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected
                                  ? AppColors.primaryForeground
                                  : (isDark ? Colors.white : Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),

          // ── Fresh Grocery Essentials Section ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fresh Essentials',
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Instant Stock',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: groceryItems.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = groceryItems[index];
                return Container(
                  width: 155,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.shopping_basket_outlined,
                          color: AppColors.primary,
                          size: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.name,
                        style: AppTypography.label(isDark: isDark).copyWith(fontSize: 13),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Fresh Pack',
                        style: AppTypography.small(isDark: isDark).copyWith(fontSize: 10.5),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '৳${item.price.toStringAsFixed(0)}',
                            style: AppTypography.price(isDark: isDark).copyWith(
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              ref.read(cartProvider.notifier).addItem(item);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${item.name} added to cart!'),
                                  duration: const Duration(milliseconds: 1000),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                size: 15,
                                color: AppColors.primaryForeground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // ── Meal Packages Header ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meal Subscriptions',
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                'Auto Daily Meals',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Subscribe to a chef meal plan with free daily doorstep delivery.',
            style: AppTypography.small(isDark: isDark),
          ),
          const SizedBox(height: 16),
          if (_loading) ...[
            const _PlanCardSkeleton(),
            const SizedBox(height: 16),
            const _PlanCardSkeleton(),
          ] else
            ..._plans.map(
              (plan) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _PlanCard(
                  plan: plan,
                  isSelected: _selectedPlanId == plan.id,
                  isDark: isDark,
                  onTap: () => setState(() => _selectedPlanId = plan.id),
                ),
              ),
            ),
          if (_selectedPlan != null) ...[
            const SizedBox(height: 8),
            _buildCustomization(isDark),
            const SizedBox(height: 20),
            _buildSummary(isDark),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Subscribed to ${_selectedPlan!.name} for $_weeks week${_weeks == 1 ? '' : 's'}',
                    ),
                    behavior: SnackBarBehavior.floating,
                    width: 340,
                  ),
                );
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
              ),
              child: const Text(
                'Subscribe Now',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomization(bool isDark) {
    final plan = _selectedPlan!;
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            'Customize Your Plan',
            style: AppTypography.label(isDark: isDark),
          ),
          const SizedBox(height: 16),
          Text(
            'Dietary Preference',
            style: AppTypography.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: plan.dietaryOptions.map((option) {
              final selected = _dietaryPreference == option;
              return ChoiceChip(
                label: Text(
                  option,
                  style: AppTypography.small(isDark: isDark).copyWith(
                    color: selected ? AppColors.primaryForeground : null,
                    fontWeight: selected ? FontWeight.w600 : null,
                  ),
                ),
                selected: selected,
                selectedColor: AppColors.primary,
                checkmarkColor: AppColors.primaryForeground,
                backgroundColor: isDark
                    ? AppColors.surfaceDark
                    : AppColors.mutedLight,
                onSelected: (_) => setState(() => _dietaryPreference = option),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Duration (weeks)',
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 18),
                      onPressed: _weeks > plan.minWeeks
                          ? () => setState(() => _weeks--)
                          : null,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                    SizedBox(
                      width: 32,
                      child: Text(
                        '$_weeks',
                        textAlign: TextAlign.center,
                        style: AppTypography.label(isDark: isDark),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 18),
                      onPressed: _weeks < 12
                          ? () => setState(() => _weeks++)
                          : null,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummary(bool isDark) {
    final plan = _selectedPlan!;
    final total = plan.weeklyTotal * _weeks;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          _SummaryRow(label: 'Plan', value: plan.name, isDark: isDark),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Meals/week',
            value: '${plan.mealsPerWeek}',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Duration',
            value: '$_weeks week${_weeks == 1 ? '' : 's'}',
            isDark: isDark,
          ),
          const SizedBox(height: 8),
          _SummaryRow(label: 'Diet', value: _dietaryPreference, isDark: isDark),
          const Divider(height: 24),
          _SummaryRow(
            label: 'Total',
            value: '৳${total.toStringAsFixed(0)}',
            isDark: isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatefulWidget {
  final MealPlan plan;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _PlanCard({
    required this.plan,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_PlanCard> createState() => _PlanCardState();
}

class _PlanCardState extends State<_PlanCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;
    final isSelected = widget.isSelected;
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: widget.isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : (widget.isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        plan.name,
                        style: AppTypography.titleMedium(isDark: widget.isDark),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '৳${plan.pricePerMeal.toStringAsFixed(0)}/meal',
                        style: AppTypography.label(
                          isDark: widget.isDark,
                        ).copyWith(color: AppColors.primary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  plan.description,
                  style: AppTypography.small(isDark: widget.isDark),
                ),
                const SizedBox(height: 12),
                ...plan.features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          f,
                          style: AppTypography.small(isDark: widget.isDark),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'From ৳${plan.weeklyTotal.toStringAsFixed(0)}/week',
                  style: AppTypography.price(
                    isDark: widget.isDark,
                  ).copyWith(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final labelStyle = isTotal
        ? AppTypography.label(isDark: isDark)
        : AppTypography.bodyMedium(isDark: isDark);
    final valueStyle = isTotal
        ? AppTypography.price(isDark: isDark)
        : AppTypography.label(isDark: isDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: labelStyle),
        Text(value, style: valueStyle),
      ],
    );
  }
}

class _PlanCardSkeleton extends StatelessWidget {
  const _PlanCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: SkeletonLine(width: w * 0.4)),
                  SkeletonBox(width: 76, height: 24, radius: 8),
                ],
              ),
              const SizedBox(height: 12),
              SkeletonLine(width: w),
              const SizedBox(height: 6),
              SkeletonLine(width: w * 0.65),
              const SizedBox(height: 16),
              SkeletonLine(width: w * 0.6),
              const SizedBox(height: 8),
              SkeletonLine(width: w * 0.4),
              const SizedBox(height: 16),
              Row(
                children: [
                  SkeletonBox(width: 16, height: 16, radius: 8),
                  const SizedBox(width: 8),
                  SkeletonLine(width: w * 0.5),
                ],
              ),
              const SizedBox(height: 12),
              SkeletonLine(width: w * 0.3),
            ],
          );
        },
      ),
    );
  }
}
