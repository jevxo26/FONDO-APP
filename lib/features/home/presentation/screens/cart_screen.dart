import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/food_item.dart';
import '../providers/user_location_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final _couponController = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState();
    }

    if (cart.items.isEmpty) {
      return _buildEmptyState(context, isDark);
    }

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // ── Top Delivery Address Header ──
          _buildDeliveryHeader(context, isDark),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Your Cart (${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'})',
                      style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        ref.read(cartProvider.notifier).clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cart cleared'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete_sweep_outlined, size: 18),
                      label: const Text('Clear'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.destructive,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...cart.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: ValueKey(item.food.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (_) => ref
                          .read(cartProvider.notifier)
                          .removeItem(item.food.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: AppColors.destructive.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.destructive),
                      ),
                      child: _CartItemCard(
                        item: item,
                        isDark: isDark,
                        onIncrement: () {
                          HapticFeedback.selectionClick();
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.food.id, item.quantity + 1);
                        },
                        onDecrement: () {
                          HapticFeedback.selectionClick();
                          ref
                              .read(cartProvider.notifier)
                              .updateQuantity(item.food.id, item.quantity - 1);
                        },
                        onRemove: () => ref
                            .read(cartProvider.notifier)
                            .removeItem(item.food.id),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildCouponSection(cart, isDark),
                const SizedBox(height: 12),
                _buildPriceBreakdown(cart, isDark),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildCheckoutBar(cart, isDark),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              children: const [
                SkeletonLine(width: 140, height: 24),
                SizedBox(height: 16),
                _CartItemSkeleton(),
                SizedBox(height: 12),
                _CartItemSkeleton(),
                SizedBox(height: 12),
                _CartItemSkeleton(),
                SizedBox(height: 16),
                _CartPanelSkeleton(),
              ],
            ),
          ),
          const _CheckoutBarSkeleton(),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 48,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Hungry? You haven't added anything to your cart!",
                style: AppTypography.headlineMedium(isDark: isDark).copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Explore delicious dishes, chef specials, and fresh groceries.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                  color: isDark
                      ? AppColors.mutedForegroundDark
                      : AppColors.mutedForegroundLight,
                  fontSize: 13.5,
                ),
              ),
              const SizedBox(height: 28),
              FilledButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.restaurant_menu_rounded, size: 18),
                label: const Text('Browse Dishes'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryForeground,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeliveryHeader(BuildContext context, bool isDark) {
    final location = ref.watch(userLocationProvider);

    return GestureDetector(
      onTap: () => _showLocationSelector(context, isDark),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.8,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.18),
                    AppColors.primary.withValues(alpha: 0.08),
                  ],
                ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delivering to',
                    style: AppTypography.small(isDark: isDark).copyWith(
                      fontSize: 10.5,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          location,
                          style: AppTypography.label(isDark: isDark).copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0xFF10B981).withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bolt_rounded,
                      size: 12, color: Color(0xFF059669)),
                  SizedBox(width: 3),
                  Text(
                    '30 min',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF059669),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartState cart, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: cart.couponCode != null
              ? AppColors.success.withValues(alpha: 0.5)
              : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: cart.couponCode != null
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.local_offer_rounded,
                      size: 18, color: AppColors.success),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Coupon Applied!',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.success,
                        ),
                      ),
                      Text(
                        '"${cart.couponCode}" — ৳${cart.discount.toStringAsFixed(0)} saved',
                        style: AppTypography.small(isDark: isDark)
                            .copyWith(color: AppColors.success),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => ref.read(cartProvider.notifier).removeCoupon(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 16,
                        color: isDark
                            ? AppColors.mutedForegroundDark
                            : AppColors.mutedForegroundLight),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.confirmation_num_outlined,
                        size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Have a coupon code?',
                      style: AppTypography.label(isDark: isDark).copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _couponController,
                        textCapitalization: TextCapitalization.characters,
                        decoration: InputDecoration(
                          hintText: 'e.g. FONDO20',
                          hintStyle: AppTypography.small(isDark: isDark)
                              .copyWith(letterSpacing: 0.5),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                          prefixIcon: const Icon(
                            Icons.tag_rounded,
                            size: 18,
                            color: AppColors.primary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: AppColors.primary, width: 1.5),
                          ),
                          filled: true,
                          fillColor: isDark
                              ? AppColors.inputFillDark
                              : AppColors.inputFillLight,
                        ),
                        style: AppTypography.bodyMedium(isDark: isDark)
                            .copyWith(letterSpacing: 1.2, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 10),
                    PressScale(
                      onTap: () {
                        final code = _couponController.text.trim();
                        if (code.isEmpty) return;
                        ref.read(cartProvider.notifier).applyCoupon(code);
                        _couponController.clear();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 13),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Apply',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildPriceBreakdown(CartState cart, bool isDark) {
    final deliveryFee = cart.subtotal >= 300 ? 0.0 : 30.0;
    final taxable = (cart.subtotal - cart.discount) > 0 ? (cart.subtotal - cart.discount) : 0.0;
    final vat = taxable * 0.05;
    final grandTotal = taxable + deliveryFee + vat;
    final totalSavings = cart.discount + (deliveryFee == 0 ? 30.0 : 0.0);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Bill Details',
                style: AppTypography.label(isDark: isDark).copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
              if (totalSavings > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Saving ৳${totalSavings.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _PriceLine(
              label: 'Item Subtotal', amount: cart.subtotal, isDark: isDark),
          const SizedBox(height: 8),
          if (cart.discount > 0) ...[
            _PriceLine(
              label: 'Coupon Discount',
              amount: -cart.discount,
              isDark: isDark,
              color: AppColors.success,
            ),
            const SizedBox(height: 8),
          ],
          _PriceLine(
            label: 'Delivery Fee',
            amount: deliveryFee,
            isDark: isDark,
            subtitle: deliveryFee == 0 ? '(Free above ৳300)' : null,
          ),
          const SizedBox(height: 8),
          _PriceLine(
            label: 'Govt VAT & Taxes (5%)',
            amount: vat,
            isDark: isDark,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                ),
              ],
            ),
          ),
          _PriceLine(
            label: 'Grand Total',
            amount: grandTotal,
            isDark: isDark,
            isTotal: true,
          ),
          if (totalSavings > 0) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.25),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.savings_rounded,
                      size: 14, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'You saved ৳${totalSavings.toStringAsFixed(0)} on this order 🎉',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(CartState cart, bool isDark) {
    final deliveryFee = cart.subtotal >= 300 ? 0.0 : 30.0;
    final taxable = (cart.subtotal - cart.discount) > 0 ? (cart.subtotal - cart.discount) : 0.0;
    final vat = taxable * 0.05;
    final grandTotal = taxable + deliveryFee + vat;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 95),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF1A1A1A) : Colors.white)
                  .withValues(alpha: isDark ? 0.88 : 0.92),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.20),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total to Pay',
                        style: AppTypography.small(isDark: isDark).copyWith(
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.3),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Text(
                          '৳${grandTotal.toStringAsFixed(0)}',
                          key: ValueKey(grandTotal.toStringAsFixed(0)),
                          style: AppTypography.price(isDark: isDark).copyWith(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (cart.subtotal < 300)
                        Text(
                          'Add ৳${(300 - cart.subtotal).toStringAsFixed(0)} for free delivery',
                          style: const TextStyle(
                            fontSize: 10.5,
                            color: Color(0xFFD97706),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                PressScale(
                  onTap: () {
                    final currentLocation = ref.read(userLocationProvider);
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Order placed! Delivering to $currentLocation',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.success,
                        duration: const Duration(seconds: 3),
                      ),
                    );
                    ref.read(cartProvider.notifier).clear();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
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
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_bag_rounded,
                            size: 16, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          'Checkout',
                          style: TextStyle(
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
              ],
            ),
          ),
        ),
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
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.primary : null,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle_rounded,
                          color: AppColors.primary)
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
}

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isDark;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isDark,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.15),
                      AppColors.primary.withValues(alpha: 0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.restaurant_rounded,
                    color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.food.name,
                      style: AppTypography.titleMedium(isDark: isDark)
                          .copyWith(fontWeight: FontWeight.w700),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    if (item.selectedAddOns.isNotEmpty) ...[
                      Text(
                        '+ ${item.selectedAddOns.join(', ')}',
                        style: AppTypography.small(isDark: isDark).copyWith(
                          color: AppColors.primary,
                          fontSize: 11,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ] else
                      Text(
                        item.food.category,
                        style: AppTypography.small(isDark: isDark)
                            .copyWith(fontSize: 11),
                      ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.destructive.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: AppColors.destructive,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: onDecrement,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Icon(
                          Icons.remove_rounded,
                          size: 16,
                          color: item.quantity > 1
                              ? AppColors.primary
                              : AppColors.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTypography.label(isDark: isDark)
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    GestureDetector(
                      onTap: onIncrement,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: const Icon(
                          Icons.add_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '৳${item.totalPrice.toStringAsFixed(0)}',
                style: AppTypography.price(isDark: isDark).copyWith(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceLine extends StatelessWidget {
  final String label;
  final String? subtitle;
  final double amount;
  final bool isDark;
  final bool isTotal;
  final Color? color;

  const _PriceLine({
    required this.label,
    this.subtitle,
    required this.amount,
    required this.isDark,
    this.isTotal = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = color ??
        (isDark ? AppColors.foregroundDark : AppColors.foregroundLight);
    final labelStyle = isTotal
        ? AppTypography.label(isDark: isDark)
        : AppTypography.bodyMedium(isDark: isDark);
    final amountStyle = isTotal
        ? AppTypography.price(isDark: isDark)
        : AppTypography.label(isDark: isDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: labelStyle.copyWith(color: textColor)),
            if (subtitle != null) ...[
              const SizedBox(width: 4),
              Text(
                subtitle!,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        Text(
          '${amount < 0 ? '-' : ''}৳${amount.abs().toStringAsFixed(0)}',
          style: amountStyle.copyWith(color: textColor),
        ),
      ],
    );
  }
}

class _CartItemSkeleton extends StatelessWidget {
  const _CartItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 44, height: 44, radius: 10),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLine(width: w * 0.45),
                        const SizedBox(height: 6),
                        SkeletonLine(width: w * 0.65),
                      ],
                    ),
                  ),
                  const SkeletonBox(width: 20, height: 20, radius: 6),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SkeletonBox(width: 92, height: 32, radius: 8),
                  SkeletonLine(width: 44),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CartPanelSkeleton extends StatelessWidget {
  const _CartPanelSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SkeletonBox(width: 20, height: 20, radius: 6),
                  const SizedBox(width: 10),
                  Expanded(child: SkeletonLine(width: w * 0.5)),
                  const SkeletonBox(width: 24, height: 24, radius: 6),
                ],
              ),
              const SizedBox(height: 16),
              SkeletonLine(width: w),
              const SizedBox(height: 8),
              SkeletonLine(width: w),
              const SizedBox(height: 8),
              SkeletonLine(width: w),
            ],
          );
        },
      ),
    );
  }
}

class _CheckoutBarSkeleton extends StatelessWidget {
  const _CheckoutBarSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        border: Border(
          top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SkeletonLine(width: 40),
                  SizedBox(height: 6),
                  SkeletonLine(width: 64, height: 18),
                ],
              ),
            ),
            const SkeletonBox(width: 150, height: 46, radius: 12),
          ],
        ),
      ),
    );
  }
}
