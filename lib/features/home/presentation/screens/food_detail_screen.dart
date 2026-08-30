import 'dart:ui';
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

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _quantity = 1;
  final Set<String> _selectedAddOns = {};

  FoodItem? get _food =>
      mockFoods.where((f) => f.id == widget.foodId).firstOrNull;

  // Addon pricing: each addon adds a flat ৳30
  static const double _addOnPrice = 30.0;

  double get _addOnTotal => _selectedAddOns.length * _addOnPrice;
  double get _itemTotal => ((_food?.price ?? 0) * _quantity) + _addOnTotal;

  void _toggleAddOn(String addOn) {
    HapticFeedback.selectionClick();
    setState(() {
      if (_selectedAddOns.contains(addOn)) {
        _selectedAddOns.remove(addOn);
      } else {
        _selectedAddOns.add(addOn);
      }
    });
  }

  void _addToCart(FoodItem food) {
    HapticFeedback.mediumImpact();
    ref.read(cartProvider.notifier).addItem(
          food,
          quantity: _quantity,
          addOns: _selectedAddOns.toList(),
        );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${food.name} ×$_quantity added to cart',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        duration: const Duration(milliseconds: 1500),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final food = _food;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (food == null) {
      return Scaffold(
        backgroundColor:
            isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Item not found',
            style: AppTypography.bodyMedium(isDark: isDark),
          ),
        ),
      );
    }

    // 16:10 = 1.6 ratio — golden ratio header height
    final heroHeight = MediaQuery.of(context).size.width / 1.6;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ── Main Scrollable Body ──
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── 16:10 Parallax Collapsing Hero Header ──
              SliverAppBar(
                expandedHeight: heroHeight,
                pinned: true,
                stretch: true,
                backgroundColor:
                    isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
                leading: Padding(
                  padding: const EdgeInsets.all(8),
                  child: _GlassIconButton(
                    icon: Icons.arrow_back_rounded,
                    onTap: () => context.pop(),
                    isDark: isDark,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: _GlassIconButton(
                      icon: Icons.favorite_border_rounded,
                      onTap: () => HapticFeedback.lightImpact(),
                      isDark: isDark,
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.blurBackground,
                  ],
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Hero gradient background
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: isDark
                                ? [
                                    const Color(0xFF1A1006),
                                    const Color(0xFF2C1A0A),
                                    const Color(0xFF1A0E05),
                                  ]
                                : [
                                    const Color(0xFFFFF8EE),
                                    const Color(0xFFFFF0D6),
                                    const Color(0xFFFFE8C0),
                                  ],
                          ),
                        ),
                      ),
                      // Decorative radial glow
                      Positioned(
                        top: heroHeight * 0.1,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            width: heroHeight * 0.7,
                            height: heroHeight * 0.7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.18),
                                  AppColors.primary.withValues(alpha: 0.0),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Center dish icon / placeholder
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_rounded,
                              size: heroHeight * 0.30,
                              color: AppColors.primary.withValues(alpha: 0.45),
                            ),
                            const SizedBox(height: 8),
                            if (food.isSignature)
                              _SignatureBadge(isDark: isDark),
                          ],
                        ),
                      ),
                      // Bottom fade-out gradient into body
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                isDark
                                    ? AppColors.backgroundDark
                                    : AppColors.backgroundLight,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Body Content ──
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 140),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // ── Title & Price ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            food.name,
                            style: AppTypography.titleLarge(isDark: isDark)
                                .copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '৳${food.price.toStringAsFixed(0)}',
                          style: AppTypography.price(isDark: isDark).copyWith(
                            fontSize: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // ── Rating Row ──
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFFF59E0B),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          food.rating.toStringAsFixed(1),
                          style: AppTypography.label(isDark: isDark)
                              .copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${food.ratingCount} reviews)',
                          style: AppTypography.small(isDark: isDark),
                        ),
                        const SizedBox(width: 14),
                        const Icon(
                          Icons.access_time_rounded,
                          size: 14,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          food.prepTime,
                          style: AppTypography.small(isDark: isDark).copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ── Dietary Tags ──
                    if (food.dietaryTags.isNotEmpty) ...[
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: food.dietaryTags.map((tag) {
                          final isHalal = tag.contains('Halal');
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isHalal
                                  ? const Color(0xFF10B981).withValues(alpha: 0.12)
                                  : AppColors.primary.withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isHalal
                                    ? const Color(0xFF10B981).withValues(alpha: 0.35)
                                    : AppColors.primary.withValues(alpha: 0.25),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isHalal
                                      ? Icons.verified_rounded
                                      : Icons.local_fire_department_rounded,
                                  size: 11,
                                  color: isHalal
                                      ? const Color(0xFF059669)
                                      : AppColors.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  tag,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isHalal
                                        ? const Color(0xFF059669)
                                        : AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // ── Description ──
                    Text(
                      food.description,
                      style: AppTypography.bodyMedium(isDark: isDark)
                          .copyWith(height: 1.6),
                    ),
                    const SizedBox(height: 20),

                    // ── Heritage Recipe Note ──
                    _HeritageNote(isDark: isDark, food: food),
                    const SizedBox(height: 20),

                    // ── Ingredients ──
                    if (food.ingredients.isNotEmpty) ...[
                      _SectionHeader(
                          label: 'Key Ingredients', isDark: isDark),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: food.ingredients.map((ingredient) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.cardDark
                                  : AppColors.cardLight,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                              ),
                            ),
                            child: Text(
                              ingredient,
                              style: AppTypography.small(isDark: isDark)
                                  .copyWith(fontWeight: FontWeight.w500),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Add-ons Section (inline checkboxes) ──
                    if (food.addOns.isNotEmpty) ...[
                      _SectionHeader(
                        label: 'Customise Your Order',
                        isDark: isDark,
                        subtitle: 'Each add-on +৳30',
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.cardDark
                              : AppColors.cardLight,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        child: Column(
                          children: food.addOns.asMap().entries.map((entry) {
                            final idx = entry.key;
                            final addOn = entry.value;
                            final isSelected =
                                _selectedAddOns.contains(addOn);
                            final isLast = idx == food.addOns.length - 1;
                            return _AddOnRow(
                              label: addOn,
                              price: _addOnPrice,
                              isSelected: isSelected,
                              isLast: isLast,
                              isDark: isDark,
                              onToggle: () => _toggleAddOn(addOn),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // ── Order Summary ──
                    _OrderSummaryCard(
                      food: food,
                      quantity: _quantity,
                      addOnTotal: _addOnTotal,
                      itemTotal: _itemTotal,
                      selectedAddOns: _selectedAddOns,
                      isDark: isDark,
                    ),
                  ]),
                ),
              ),
            ],
          ),

          // ── Floating Glass Bottom Bar ──
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _FloatingOrderBar(
              food: food,
              quantity: _quantity,
              itemTotal: _itemTotal,
              isDark: isDark,
              onDecrement: () {
                if (_quantity > 1) setState(() => _quantity--);
              },
              onIncrement: () => setState(() => _quantity++),
              onAddToCart: () => _addToCart(food),
            ),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// Subwidgets
// ────────────────────────────────────────────────────────────────

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;

  const _GlassIconButton({
    required this.icon,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: (isDark ? Colors.white : Colors.black)
                  .withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (isDark ? Colors.white : Colors.black)
                    .withValues(alpha: 0.14),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}

class _SignatureBadge extends StatelessWidget {
  final bool isDark;

  const _SignatureBadge({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFB8860B), Color(0xFFD4A017), Color(0xFFB8860B)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4A017).withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome_rounded, size: 13, color: Colors.white),
          SizedBox(width: 5),
          Text(
            "Chef's Signature",
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeritageNote extends StatelessWidget {
  final bool isDark;
  final FoodItem food;

  const _HeritageNote({required this.isDark, required this.food});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2A1A06), const Color(0xFF1E1208)]
              : [const Color(0xFFFFFAF0), const Color(0xFFFFF4D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFD4A017).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFD4A017).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_fire_department_rounded,
              size: 20,
              color: Color(0xFFB8860B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Heritage Craft Note',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB8860B),
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  food.isSignature
                      ? 'This is a chef-crafted royal Mughlai signature. Slow-cooked in a sealed dum pot over glowing coals for ${food.prepTime}, it retains every layer of aroma and spice balance — a technique inherited from generations of culinary heritage.'
                      : 'Cooked fresh every day using traditional coal-fire methods. Our kitchen honours authenticity — no shortcuts, no artificial flavours. Every dish is served at its peak.',
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.55,
                    color: isDark
                        ? const Color(0xFFD4A017).withValues(alpha: 0.9)
                        : const Color(0xFF92650A),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isDark;

  const _SectionHeader({
    required this.label,
    required this.isDark,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          label,
          style: AppTypography.label(isDark: isDark).copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(width: 8),
          Text(
            subtitle!,
            style: AppTypography.small(isDark: isDark).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

class _AddOnRow extends StatelessWidget {
  final String label;
  final double price;
  final bool isSelected;
  final bool isLast;
  final bool isDark;
  final VoidCallback onToggle;

  const _AddOnRow({
    required this.label,
    required this.price,
    required this.isSelected,
    required this.isLast,
    required this.isDark,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isLast ? 18 : 0),
            bottomRight: Radius.circular(isLast ? 18 : 0),
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                              ? AppColors.borderDark
                              : AppColors.borderLight),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 14,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style:
                        AppTypography.bodyMedium(isDark: isDark).copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
                Text(
                  '+৳${price.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.primary : (isDark ? Colors.white54 : Colors.black45),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            thickness: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
      ],
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final FoodItem food;
  final int quantity;
  final double addOnTotal;
  final double itemTotal;
  final Set<String> selectedAddOns;
  final bool isDark;

  const _OrderSummaryCard({
    required this.food,
    required this.quantity,
    required this.addOnTotal,
    required this.itemTotal,
    required this.selectedAddOns,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.primarySurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: AppTypography.label(isDark: isDark).copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryLine(
            label: '${food.name} ×$quantity',
            value: '৳${(food.price * quantity).toStringAsFixed(0)}',
            isDark: isDark,
          ),
          if (addOnTotal > 0) ...[
            const SizedBox(height: 6),
            _SummaryLine(
              label: 'Add-ons (${selectedAddOns.length})',
              value: '৳${addOnTotal.toStringAsFixed(0)}',
              isDark: isDark,
            ),
          ],
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1),
          ),
          _SummaryLine(
            label: 'Total',
            value: '৳${itemTotal.toStringAsFixed(0)}',
            isDark: isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isTotal;

  const _SummaryLine({
    required this.label,
    required this.value,
    required this.isDark,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTypography.label(isDark: isDark)
              : AppTypography.bodyMedium(isDark: isDark),
        ),
        Text(
          value,
          style: isTotal
              ? AppTypography.price(isDark: isDark)
              : AppTypography.label(isDark: isDark),
        ),
      ],
    );
  }
}

class _FloatingOrderBar extends StatelessWidget {
  final FoodItem food;
  final int quantity;
  final double itemTotal;
  final bool isDark;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onAddToCart;

  const _FloatingOrderBar({
    required this.food,
    required this.quantity,
    required this.itemTotal,
    required this.isDark,
    required this.onDecrement,
    required this.onIncrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
          decoration: BoxDecoration(
            color: (isDark
                    ? const Color(0xFF0E0E0E)
                    : Colors.white)
                .withValues(alpha: isDark ? 0.78 : 0.82),
            border: Border(
              top: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.14),
                width: 1,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.10),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Quantity stepper
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _StepperBtn(
                        icon: Icons.remove_rounded,
                        onTap: onDecrement,
                        enabled: quantity > 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '$quantity',
                          style: AppTypography.label(isDark: isDark)
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      _StepperBtn(
                        icon: Icons.add_rounded,
                        onTap: onIncrement,
                        enabled: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Add to Cart CTA
                Expanded(
                  child: PressScale(
                    onTap: onAddToCart,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFB8860B),
                            AppColors.primary,
                            Color(0xFFB8860B),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Add to Cart  —  ৳${itemTotal.toStringAsFixed(0)}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
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

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  const _StepperBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? AppColors.primary : AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
