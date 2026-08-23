import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/food_item.dart';

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
    Future.delayed(const Duration(milliseconds: 1800), () {
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
      return _buildEmptyState(isDark);
    }

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              children: [
                Text(
                  'Cart (${cart.itemCount} item${cart.itemCount == 1 ? '' : 's'})',
                  style: AppTypography.titleLarge(isDark: isDark),
                ),
                const SizedBox(height: 16),
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
                        child: Icon(Icons.delete_outline_rounded,
                            color: AppColors.destructive),
                      ),
                      child: _CartItemCard(
                        item: item,
                        isDark: isDark,
                        onIncrement: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.food.id, item.quantity + 1),
                        onDecrement: () => ref
                            .read(cartProvider.notifier)
                            .updateQuantity(item.food.id, item.quantity - 1),
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

  Widget _buildEmptyState(bool isDark) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 20),
              Text(
                'Your cart is empty',
                style: AppTypography.titleLarge(isDark: isDark),
              ),
              const SizedBox(height: 10),
              Text(
                'Browse the catalog and add items to get started.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartState cart, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: cart.couponCode != null
          ? Row(
              children: [
                const Icon(Icons.local_offer_rounded,
                    size: 20, color: AppColors.success),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Coupon "${cart.couponCode}" applied — ৳${cart.discount.toStringAsFixed(0)} off',
                    style: AppTypography.bodyMedium(isDark: isDark)
                        .copyWith(color: AppColors.success),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 20,
                      color: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight),
                  onPressed: () =>
                      ref.read(cartProvider.notifier).removeCoupon(),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _couponController,
                    decoration: InputDecoration(
                      hintText: 'Enter coupon code',
                      hintStyle: AppTypography.small(isDark: isDark),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide:
                            const BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.inputFillDark
                          : AppColors.inputFillLight,
                    ),
                    style: AppTypography.bodyMedium(isDark: isDark),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton(
                  onPressed: () {
                    final code = _couponController.text.trim();
                    if (code.isEmpty) return;
                    ref.read(cartProvider.notifier).applyCoupon(code);
                    _couponController.clear();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            ),
    );
  }

  Widget _buildPriceBreakdown(CartState cart, bool isDark) {
    final deliveryFee = cart.subtotal >= 200 ? 0.0 : 30.0;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          _PriceLine(
              label: 'Subtotal', amount: cart.subtotal, isDark: isDark),
          const SizedBox(height: 8),
          if (cart.discount > 0) ...[
            _PriceLine(
              label: 'Discount',
              amount: -cart.discount,
              isDark: isDark,
              color: AppColors.success,
            ),
            const SizedBox(height: 8),
          ],
          _PriceLine(label: 'Delivery', amount: deliveryFee, isDark: isDark),
          const Divider(height: 24),
          _PriceLine(
            label: 'Total',
            amount: cart.total + deliveryFee,
            isDark: isDark,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBar(CartState cart, bool isDark) {
    final deliveryFee = cart.subtotal >= 200 ? 0.0 : 30.0;
    final grandTotal = cart.total + deliveryFee;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 95),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
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
                  Text('Total', style: AppTypography.small(isDark: isDark)),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      '৳${grandTotal.toStringAsFixed(0)}',
                      key: ValueKey(grandTotal.toStringAsFixed(0)),
                      style: AppTypography.price(isDark: isDark),
                    ),
                  ),
                ],
              ),
            ),
            FilledButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed! (demo)'),
                    behavior: SnackBarBehavior.floating,
                    width: 200,
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text('Place Order'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
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
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.restaurant_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.food.name,
                        style: AppTypography.titleMedium(isDark: isDark)),
                    if (item.selectedAddOns.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        item.selectedAddOns.join(', '),
                        style: AppTypography.small(isDark: isDark),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline_rounded,
                    size: 20, color: AppColors.destructive),
                onPressed: onRemove,
                constraints:
                    const BoxConstraints(minWidth: 36, minHeight: 36),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_rounded, size: 16),
                      onPressed: onDecrement,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(
                          minWidth: 32, minHeight: 32),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${item.quantity}',
                        textAlign: TextAlign.center,
                        style: AppTypography.label(isDark: isDark),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_rounded, size: 16),
                      onPressed: onIncrement,
                      color: AppColors.primary,
                      constraints: const BoxConstraints(
                          minWidth: 32, minHeight: 32),
                    ),
                  ],
                ),
              ),
              Text(
                '৳${item.totalPrice.toStringAsFixed(0)}',
                style: AppTypography.price(isDark: isDark),
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
  final double amount;
  final bool isDark;
  final bool isTotal;
  final Color? color;

  const _PriceLine({
    required this.label,
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
        Text(label, style: labelStyle.copyWith(color: textColor)),
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
