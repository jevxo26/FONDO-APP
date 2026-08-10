import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radii.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_skeleton.dart';
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

class PackagesScreen extends StatefulWidget {
  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  bool _loading = true;
  String? _selectedPlanId;
  String _dietaryPreference = 'Regular';
  int _weeks = 1;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  MealPlan? get _selectedPlan => _selectedPlanId == null
      ? null
      : _plans.firstWhere((p) => p.id == _selectedPlanId);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Meal Packages',
            style: AppTypography.titleLarge(isDark: isDark),
          ),
          const SizedBox(height: 8),
          Text(
            'Subscribe to a meal plan and enjoy freshly cooked meals delivered to your door.',
            style: AppTypography.bodyMedium(isDark: isDark),
          ),
          const SizedBox(height: 24),
          if (_loading) ...[
            const _PlanCardSkeleton(),
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
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
                  Expanded(child: _SkeletonLine(width: w * 0.4)),
                  _SkeletonBox(width: 76, height: 24, radius: 8),
                ],
              ),
              const SizedBox(height: 12),
              _SkeletonLine(width: w),
              const SizedBox(height: 6),
              _SkeletonLine(width: w * 0.65),
              const SizedBox(height: 16),
              _SkeletonLine(width: w * 0.6),
              const SizedBox(height: 8),
              _SkeletonLine(width: w * 0.4),
              const SizedBox(height: 16),
              Row(
                children: [
                  _SkeletonBox(width: 16, height: 16, radius: 8),
                  const SizedBox(width: 8),
                  _SkeletonLine(width: w * 0.5),
                ],
              ),
              const SizedBox(height: 12),
              _SkeletonLine(width: w * 0.3),
            ],
          );
        },
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double width;

  const _SkeletonLine({required this.width});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return AppSkeleton(
      child: Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(color: base, borderRadius: AppRadii.sm),
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark
        ? AppColors.mutedDark.withValues(alpha: 0.4)
        : AppColors.mutedLight;

    return AppSkeleton(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: base,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
