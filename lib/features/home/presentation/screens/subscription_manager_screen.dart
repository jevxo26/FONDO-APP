import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/meal_plan.dart';
import '../../../../models/user_subscription.dart';

const MealPlan _monthly = MealPlan(
  id: 'monthly',
  name: 'Monthly Premium',
  description: 'Best value for regular customers. Enjoy two meals daily with priority support and exclusive dishes.',
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
  dietaryOptions: ['Regular', 'Low Carb', 'High Protein', 'Vegetarian', 'Keto', 'Gluten Free'],
);

const MealPlan _weekly = MealPlan(
  id: 'weekly',
  name: 'Weekly Starter',
  description: 'Perfect for individuals who want freshly cooked meals every day without the hassle of cooking.',
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
);

final List<UserSubscription> _subscriptions = [
  UserSubscription(
    id: 'sub_001',
    plan: _monthly,
    dietaryPreference: 'Regular',
    weeks: 12,
    totalPrice: _monthly.weeklyTotal * 12,
    startDate: DateTime(2026, 3, 1),
    endDate: DateTime(2026, 5, 21),
    status: SubscriptionStatus.active,
    pausedDates: [],
    mealsDelivered: 80,
    totalMeals: 168,
  ),
  UserSubscription(
    id: 'sub_002',
    plan: _weekly,
    dietaryPreference: 'Vegetarian',
    weeks: 4,
    totalPrice: _weekly.weeklyTotal * 4,
    startDate: DateTime(2026, 5, 1),
    endDate: DateTime(2026, 5, 28),
    status: SubscriptionStatus.paused,
    pausedUntil: DateTime(2026, 6, 15),
    pausedDates: [],
    mealsDelivered: 21,
    totalMeals: 28,
  ),
];

String formatDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  return '${days[dt.weekday % 7]}, ${months[dt.month - 1]} ${dt.day}';
}

String formatDateShort(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

class SubscriptionManagerScreen extends StatefulWidget {
  const SubscriptionManagerScreen({super.key});

  @override
  State<SubscriptionManagerScreen> createState() => _SubscriptionManagerScreenState();
}

class _SubscriptionManagerScreenState extends State<SubscriptionManagerScreen> {
  late List<UserSubscription> _items;
  int? _quickPauseDays;
  DateTimeRange? _customPauseRange;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _items = _subscriptions;
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _showPauseSheet(String subId) {
    _quickPauseDays = null;
    _customPauseRange = null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pause Subscription', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 8),
                Text('Select pause duration or pick specific dates', style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _quickChip(ctx, setSheetState, '3 days', 3, isDark),
                    _quickChip(ctx, setSheetState, '1 week', 7, isDark),
                    _quickChip(ctx, setSheetState, '2 weeks', 14, isDark),
                    _quickChip(ctx, setSheetState, '1 month', 30, isDark),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: ctx,
                            initialDate: _customPauseRange?.start ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            final end = await showDatePicker(
                              context: ctx,
                              initialDate: _customPauseRange?.end ?? picked.add(const Duration(days: 7)),
                              firstDate: picked.add(const Duration(days: 1)),
                              lastDate: picked.add(const Duration(days: 365)),
                            );
                            if (end != null) {
                              setSheetState(() {
                                _customPauseRange = DateTimeRange(start: picked, end: end);
                                _quickPauseDays = null;
                              });
                            }
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardDark : AppColors.cardLight,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _customPauseRange != null
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.date_range_rounded, size: 18, color: AppColors.primary),
                              const SizedBox(width: 10),
                              Text(
                                _customPauseRange != null
                                    ? '${formatDate(_customPauseRange!.start)} – ${formatDate(_customPauseRange!.end)}'
                                    : 'Custom date range',
                                style: AppTypography.bodyMedium(isDark: isDark),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: () {
                    final subIdx = _items.indexWhere((s) => s.id == subId);
                    if (subIdx == -1) return;
                    final sub = _items[subIdx];
                    final pauseEnd = _customPauseRange?.end ?? DateTime.now().add(Duration(days: _quickPauseDays ?? 7));
                    final updated = UserSubscription(
                      id: sub.id,
                      plan: sub.plan,
                      dietaryPreference: sub.dietaryPreference,
                      weeks: sub.weeks,
                      totalPrice: sub.totalPrice,
                      startDate: sub.startDate,
                      endDate: sub.endDate,
                      status: SubscriptionStatus.paused,
                      pausedUntil: pauseEnd,
                      pausedDates: [...sub.pausedDates],
                      mealsDelivered: sub.mealsDelivered,
                      totalMeals: sub.totalMeals,
                    );
                    setState(() => _items[subIdx] = updated);
                    Navigator.of(ctx).pop();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Apply Pause', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickChip(BuildContext ctx, StateSetter setSheetState, String label, int days, bool isDark) {
    final selected = _quickPauseDays == days;
    return ChoiceChip(
      label: Text(label, style: AppTypography.label(isDark: isDark).copyWith(fontSize: 13)),
      selected: selected,
      selectedColor: AppColors.primary,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
      labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null),
      onSelected: (_) {
        setSheetState(() {
          _quickPauseDays = days;
          _customPauseRange = null;
        });
      },
    );
  }

  void _resumeSubscription(String subId) {
    final subIdx = _items.indexWhere((s) => s.id == subId);
    if (subIdx == -1) return;
    final sub = _items[subIdx];
    final updated = UserSubscription(
      id: sub.id,
      plan: sub.plan,
      dietaryPreference: sub.dietaryPreference,
      weeks: sub.weeks,
      totalPrice: sub.totalPrice,
      startDate: sub.startDate,
      endDate: sub.endDate,
      status: SubscriptionStatus.active,
      pausedUntil: null,
      pausedDates: sub.pausedDates,
      mealsDelivered: sub.mealsDelivered,
      totalMeals: sub.totalMeals,
    );
    setState(() => _items[subIdx] = updated);
  }

  void _cancelSubscription(String subId) {
    final subIdx = _items.indexWhere((s) => s.id == subId);
    if (subIdx == -1) return;
    final sub = _items[subIdx];
    final updated = UserSubscription(
      id: sub.id,
      plan: sub.plan,
      dietaryPreference: sub.dietaryPreference,
      weeks: sub.weeks,
      totalPrice: sub.totalPrice,
      startDate: sub.startDate,
      endDate: sub.endDate,
      status: SubscriptionStatus.cancelled,
      pausedUntil: sub.pausedUntil,
      pausedDates: sub.pausedDates,
      mealsDelivered: sub.mealsDelivered,
      totalMeals: sub.totalMeals,
    );
    setState(() => _items[subIdx] = updated);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Subscriptions'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: _items.map((sub) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _SubscriptionCard(
              subscription: sub,
              isDark: isDark,
              onPause: () => _showPauseSheet(sub.id),
              onResume: () => _resumeSubscription(sub.id),
              onCancel: () => _cancelSubscription(sub.id),
            ),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('My Subscriptions'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            _SubscriptionCardSkeleton(),
            SizedBox(height: 16),
            _SubscriptionCardSkeleton(),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  final UserSubscription subscription;
  final bool isDark;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onCancel;

  const _SubscriptionCard({
    required this.subscription,
    required this.isDark,
    required this.onPause,
    required this.onResume,
    required this.onCancel,
  });

  Color _statusColor(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return AppColors.success;
      case SubscriptionStatus.paused:
        return AppColors.warning;
      case SubscriptionStatus.cancelled:
        return AppColors.destructive;
      case SubscriptionStatus.completed:
        return Colors.blue;
    }
  }

  String _statusLabel(SubscriptionStatus status) {
    switch (status) {
      case SubscriptionStatus.active:
        return 'Active';
      case SubscriptionStatus.paused:
        return 'Paused';
      case SubscriptionStatus.cancelled:
        return 'Cancelled';
      case SubscriptionStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(subscription.status);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(subscription.plan.name, style: AppTypography.cardTitle(isDark: isDark)),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _statusLabel(subscription.status),
                  style: AppTypography.badge(isDark: isDark).copyWith(color: statusColor, fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(subscription.dietaryPreference, style: AppTypography.small(isDark: isDark)),
              const SizedBox(width: 12),
              Container(width: 1, height: 12, color: isDark ? AppColors.borderDark : AppColors.borderLight),
              const SizedBox(width: 12),
              Text(
                '৳${subscription.plan.pricePerMeal.toStringAsFixed(0)}/meal',
                style: AppTypography.small(isDark: isDark).copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: subscription.progress,
              minHeight: 8,
              backgroundColor: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${subscription.mealsDelivered} of ${subscription.totalMeals} meals delivered',
            style: AppTypography.small(isDark: isDark),
          ),
          const SizedBox(height: 4),
          Text(
            '${subscription.remainingMeals} meals remaining',
            style: AppTypography.small(isDark: isDark).copyWith(color: AppColors.mutedForegroundLight),
          ),
          const SizedBox(height: 16),
          if (subscription.status == SubscriptionStatus.active) ...[
              Text(
                '${formatDateShort(subscription.startDate)} – ${subscription.endDate != null ? formatDateShort(subscription.endDate!) : ''}',
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
              const SizedBox(height: 4),
              Text(
                'Next delivery: ${formatDate(DateTime(2026, 6, 3))}',
              style: AppTypography.small(isDark: isDark).copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onPause,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Pause Subscription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.destructive,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Cancel', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
          if (subscription.status == SubscriptionStatus.paused) ...[
            Row(
              children: [
                Icon(Icons.pause_circle_outline_rounded, size: 16, color: AppColors.warning),
                const SizedBox(width: 6),
                Text(
                  'Paused until ${formatDateShort(subscription.pausedUntil!)}',
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(color: AppColors.warning),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: onResume,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Resume', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onCancel,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.destructive,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  child: const Text('Cancel Subscription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
          if (subscription.status == SubscriptionStatus.cancelled || subscription.status == SubscriptionStatus.completed) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'This subscription has been ${subscription.status == SubscriptionStatus.cancelled ? 'cancelled' : 'completed'}.',
                textAlign: TextAlign.center,
                style: AppTypography.small(isDark: isDark).copyWith(color: statusColor),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionCardSkeleton extends StatelessWidget {
  const _SubscriptionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: SkeletonLine(width: w * 0.5, height: 18)),
                  const SkeletonBox(width: 56, height: 22, radius: 8),
                ],
              ),
              const SizedBox(height: 10),
              SkeletonLine(width: w * 0.45),
              const SizedBox(height: 16),
              SkeletonBox(width: w, height: 8, radius: 4),
              const SizedBox(height: 6),
              SkeletonLine(width: w * 0.6),
              const SizedBox(height: 4),
              SkeletonLine(width: w * 0.5),
              const SizedBox(height: 16),
              SkeletonLine(width: w * 0.6),
              const SizedBox(height: 4),
              SkeletonLine(width: w * 0.4),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: SkeletonBox(width: double.infinity, height: 44, radius: 12),
                  ),
                  const SizedBox(width: 12),
                  const SkeletonBox(width: 90, height: 44, radius: 12),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
