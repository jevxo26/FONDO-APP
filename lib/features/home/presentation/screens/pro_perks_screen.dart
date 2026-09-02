import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';

class ProPerksScreen extends StatefulWidget {
  const ProPerksScreen({super.key});

  @override
  State<ProPerksScreen> createState() => _ProPerksScreenState();
}

class _ProPerksScreenState extends State<ProPerksScreen> {
  int _selectedPlanIndex = 1; // Default to 6-month plan
  bool _couponApplied = false;
  final Set<int> _expandedPerks = {0, 1}; // Default first 2 expanded

  final List<_ProPlan> _plans = const [
    _ProPlan(
      id: 'monthly',
      title: '1 Month',
      pricePerMonth: 99,
      totalPrice: 99,
      billingCycle: 'Billed monthly',
      badge: null,
      savings: null,
    ),
    _ProPlan(
      id: 'semi_annual',
      title: '6 Months',
      pricePerMonth: 79,
      totalPrice: 474,
      billingCycle: 'Billed ৳474 every 6 months',
      badge: 'POPULAR',
      savings: 'Save 20%',
    ),
    _ProPlan(
      id: 'annual',
      title: '12 Months',
      pricePerMonth: 49,
      totalPrice: 588,
      billingCycle: 'Billed ৳588 yearly',
      badge: 'BEST VALUE',
      savings: 'Save 50%',
    ),
  ];

  final List<_PerkItem> _perks = const [
    _PerkItem(
      icon: Icons.delivery_dining_rounded,
      title: 'Unlimited Free Delivery',
      subtitle: 'On food and grocery orders above ৳299 across 5,000+ top restaurants and marts.',
      highlight: 'Save up to ৳60 per order',
      color: Color(0xFF9C27B0),
    ),
    _PerkItem(
      icon: Icons.local_fire_department_rounded,
      title: 'Extra 20% Off Restaurants',
      subtitle: 'Exclusive discounts on top rated restaurants, stackable with standard vouchers.',
      highlight: 'Unlimited redemptions',
      color: Color(0xFFFF9800),
    ),
    _PerkItem(
      icon: Icons.storefront_rounded,
      title: 'Extra 20% Off Groceries',
      subtitle: 'Enjoy automatic price cuts on fresh produce, dairy, and household essentials on FONDO Mart.',
      highlight: 'Delivered in 15-25 mins',
      color: Color(0xFF4CAF50),
    ),
    _PerkItem(
      icon: Icons.shopping_bag_outlined,
      title: 'Up to 35% Off Pick-up',
      subtitle: 'Grab your takeout and skip the wait with exclusive dine-out and pick-up bonuses.',
      highlight: 'Zero waiting time',
      color: Color(0xFF2196F3),
    ),
    _PerkItem(
      icon: Icons.support_agent_rounded,
      title: 'Priority VIP Customer Support',
      subtitle: 'Skip the support queue with direct access to dedicated VIP resolution specialists 24/7.',
      highlight: 'Fastest 30-sec response',
      color: Color(0xFFE91E63),
    ),
  ];

  void _applyCoupon() {
    HapticFeedback.mediumImpact();
    setState(() {
      _couponApplied = !_couponApplied;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _couponApplied
              ? 'PRO30 applied: 30% extra discount on your subscription!'
              : 'Coupon removed',
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _couponApplied ? const Color(0xFF7B1FA2) : AppColors.mutedForegroundLight,
      ),
    );
  }

  void _subscribe() {
    final plan = _plans[_selectedPlanIndex];
    final finalPrice = _couponApplied ? (plan.totalPrice * 0.7).round() : plan.totalPrice;

    HapticFeedback.heavyImpact();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFB300), size: 28),
            SizedBox(width: 8),
            Text('Confirm Subscription'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You are subscribing to FONDO Pro (${plan.title}):',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF7B1FA2).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF7B1FA2).withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Plan Duration:'),
                      Text(plan.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount Payable:'),
                      Text(
                        '৳$finalPrice',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF7B1FA2),
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  if (_couponApplied) ...[
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Promo Code:', style: TextStyle(fontSize: 12, color: Colors.green)),
                        Text('PRO30 (-30%)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your membership will activate immediately with instant perks on all food & grocery orders.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Welcome to FONDO Pro! Your perks are now active.'),
                  backgroundColor: Color(0xFF7B1FA2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              context.pop();
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF7B1FA2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Confirm & Pay'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPlan = _plans[_selectedPlanIndex];
    final displayPrice = _couponApplied
        ? (selectedPlan.pricePerMonth * 0.7).round()
        : selectedPlan.pricePerMonth;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? Colors.black45 : Colors.white70,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 20),
          ),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? Colors.black45 : Colors.white70,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.share_outlined, size: 20),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Share link copied to clipboard!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 160),
            children: [
              const SizedBox(height: 90),
              // Hero Banner with Crown
              _buildHeroBanner(isDark),
              const SizedBox(height: 24),

              // Membership Perks Section
              Row(
                children: [
                  const Icon(Icons.stars_rounded, color: Color(0xFFFFB300), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Exclusive Perks Included',
                    style: AppTypography.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_perks.length, (index) {
                final perk = _perks[index];
                final isExpanded = _expandedPerks.contains(index);
                return _buildPerkAccordion(perk, index, isExpanded, isDark);
              }),
              const SizedBox(height: 28),

              // Choose a Plan Section
              Row(
                children: [
                  const Icon(Icons.card_membership_rounded, color: Color(0xFF7B1FA2), size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Choose Your Pro Plan',
                    style: AppTypography.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...List.generate(_plans.length, (index) {
                final plan = _plans[index];
                final isSelected = _selectedPlanIndex == index;
                return _buildPlanCard(plan, index, isSelected, isDark);
              }),
              const SizedBox(height: 20),

              // Promo code voucher banner
              _buildPromoBanner(isDark),
              const SizedBox(height: 20),

              // FAQ & Terms info
              _buildTermsInfo(isDark),
            ],
          ),

          // Sticky Bottom Action Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildStickyBottomBar(displayPrice, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroBanner(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E17EB), Color(0xFF8E24AA), Color(0xFFBA68C8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8E24AA).withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.workspace_premium_rounded, color: Color(0xFFFFD54F), size: 16),
                    SizedBox(width: 6),
                    Text(
                      'FONDO PRO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_activity_rounded,
                  color: Color(0xFFFFD54F),
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Explore exclusive perks with FONDO Pro',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Members save an average of ৳1,450 every month on deliveries and food discounts.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerkAccordion(_PerkItem perk, int index, bool isExpanded, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isExpanded
              ? perk.color.withValues(alpha: 0.4)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            HapticFeedback.selectionClick();
            setState(() {
              if (expanded) {
                _expandedPerks.add(index);
              } else {
                _expandedPerks.remove(index);
              }
            });
          },
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: perk.color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(perk.icon, color: perk.color, size: 22),
          ),
          title: Text(
            perk.title,
            style: AppTypography.titleMedium(isDark: isDark).copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              perk.highlight,
              style: TextStyle(
                color: perk.color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                perk.subtitle,
                style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                  color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                  height: 1.4,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(_ProPlan plan, int index, bool isSelected, bool isDark) {
    return PressScale(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _selectedPlanIndex = index);
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF7B1FA2).withValues(alpha: 0.08)
                : (isDark ? AppColors.cardDark : AppColors.cardLight),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF7B1FA2)
                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF7B1FA2) : (isDark ? Colors.white38 : Colors.black38),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Center(
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF7B1FA2),
                          ),
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.title,
                          style: AppTypography.titleMedium(isDark: isDark).copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        if (plan.badge != null) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFF7B1FA2),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              plan.badge!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plan.billingCycle,
                      style: AppTypography.small(isDark: isDark).copyWith(
                        color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '৳${plan.pricePerMonth}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? const Color(0xFF7B1FA2) : (isDark ? Colors.white : Colors.black),
                        ),
                      ),
                      Text(
                        '/mo',
                        style: AppTypography.small(isDark: isDark),
                      ),
                    ],
                  ),
                  if (plan.savings != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      plan.savings!,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoBanner(bool isDark) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 18,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF7B1FA2).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF7B1FA2), size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Have a promo code?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  _couponApplied ? 'Code PRO30 active (-30%)' : 'Tap to apply "PRO30" for 30% off',
                  style: TextStyle(
                    fontSize: 12,
                    color: _couponApplied ? Colors.green : (isDark ? Colors.white70 : Colors.black54),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _applyCoupon,
            style: TextButton.styleFrom(
              foregroundColor: _couponApplied ? AppColors.destructive : const Color(0xFF7B1FA2),
              textStyle: const TextStyle(fontWeight: FontWeight.bold),
            ),
            child: Text(_couponApplied ? 'Remove' : 'Apply'),
          ),
        ],
      ),
    );
  }

  Widget _buildTermsInfo(bool isDark) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline_rounded, size: 14, color: isDark ? Colors.white54 : Colors.black45),
            const SizedBox(width: 6),
            Text(
              'Recurring billing. Cancel anytime from profile settings.',
              style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'By subscribing, you agree to FONDO Pro Terms of Service & Refund Policy.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black38),
        ),
      ],
    );
  }

  Widget _buildStickyBottomBar(int displayPrice, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C).withValues(alpha: 0.95) : Colors.white.withValues(alpha: 0.95),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, -6),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting from',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '৳$displayPrice',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B1FA2),
                      ),
                    ),
                    Text(
                      '/mo.',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              child: FilledButton(
                onPressed: _subscribe,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF7B1FA2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  shadowColor: const Color(0xFF7B1FA2).withValues(alpha: 0.4),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Select Plan',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward_rounded, size: 18),
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

class _ProPlan {
  final String id;
  final String title;
  final int pricePerMonth;
  final int totalPrice;
  final String billingCycle;
  final String? badge;
  final String? savings;

  const _ProPlan({
    required this.id,
    required this.title,
    required this.pricePerMonth,
    required this.totalPrice,
    required this.billingCycle,
    this.badge,
    this.savings,
  });
}

class _PerkItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final String highlight;
  final Color color;

  const _PerkItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.highlight,
    required this.color,
  });
}
