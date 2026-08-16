import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/mock/mock_orders.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/food_item.dart';
import '../../../../models/order_model.dart';
import '../../../../router/routes.dart';

Color _statusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orange;
    case OrderStatus.confirmed:
      return Colors.blue;
    case OrderStatus.preparing:
      return Colors.amber;
    case OrderStatus.outForDelivery:
      return Colors.purple;
    case OrderStatus.delivered:
      return AppColors.success;
    case OrderStatus.cancelled:
      return AppColors.destructive;
  }
}

String _formatDate(DateTime dt) {
  const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
}

String _itemsSummary(List<OrderItem> items) {
  return items.map((e) => e.foodName).join(', ');
}

class OrderHistoryScreen extends ConsumerStatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  ConsumerState<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends ConsumerState<OrderHistoryScreen> {
  String _filter = 'All';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  List<OrderModel> get _filteredOrders {
    if (_filter == 'All') return mockOrders;
    if (_filter == 'Delivered') {
      return mockOrders.where((o) => o.status == OrderStatus.delivered).toList();
    }
    return mockOrders.where((o) => o.status == OrderStatus.cancelled).toList();
  }

  FoodItem _foodForOrderItem(OrderItem item, OrderModel order) {
    for (final food in mockFoods) {
      if (food.name == item.foodName) return food;
    }
    return FoodItem(
      id: 'repeat_${order.id}_${item.foodName}',
      name: item.foodName,
      description: 'Reordered from ${order.orderNumber}',
      price: item.price,
      category: 'Repeat Order',
    );
  }

  void _repeatOrder(OrderModel order) {
    final cart = ref.read(cartProvider.notifier);
    for (final item in order.items) {
      cart.addItem(_foodForOrderItem(item, order), quantity: item.quantity);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Items added to cart'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go(AppRoutes.cart);
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
        title: const Text('Order History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  _FilterChip(label: 'All', selected: _filter == 'All', onTap: () => setState(() => _filter = 'All')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Delivered', selected: _filter == 'Delivered', onTap: () => setState(() => _filter = 'Delivered')),
                  const SizedBox(width: 8),
                  _FilterChip(label: 'Cancelled', selected: _filter == 'Cancelled', onTap: () => setState(() => _filter = 'Cancelled')),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.delayed(const Duration(milliseconds: 600)),
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _OrderCard(
                      order: _filteredOrders[index],
                      isDark: isDark,
                      onRepeat: () => _repeatOrder(_filteredOrders[index]),
                      onTrack: () => context.push(AppRoutes.liveTracking.replaceAll(':orderId', _filteredOrders[index].id)),
                    ),
                  ),
                ),
              ),
            ),
          ],
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
        title: const Text('Order History'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: const [
                  SkeletonBox(width: 56, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 84, height: 34, radius: 20),
                  SizedBox(width: 8),
                  SkeletonBox(width: 80, height: 34, radius: 20),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                children: const [
                  _OrderCardSkeleton(),
                  SizedBox(height: 14),
                  _OrderCardSkeleton(),
                  SizedBox(height: 14),
                  _OrderCardSkeleton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTypography.label(isDark: isDark).copyWith(
            color: selected ? AppColors.primaryForeground : null,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final VoidCallback onRepeat;
  final VoidCallback onTrack;

  const _OrderCard({
    required this.order,
    required this.isDark,
    required this.onRepeat,
    required this.onTrack,
  });

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(order.status);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.orderNumber, style: AppTypography.cardTitle(isDark: isDark)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.statusLabel,
                  style: AppTypography.badge(isDark: isDark).copyWith(color: color),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(_formatDate(order.orderedAt), style: AppTypography.small(isDark: isDark)),
          const SizedBox(height: 10),
          Text(
            '${order.itemCount} items • ${_itemsSummary(order.items)}',
            style: AppTypography.bodyMedium(isDark: isDark),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                '৳${order.total.toStringAsFixed(0)}',
                style: AppTypography.price(isDark: isDark),
              ),
              const Spacer(),
              Icon(Icons.payment_rounded, size: 14, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
              const SizedBox(width: 4),
              Text(order.paymentMethod, style: AppTypography.small(isDark: isDark)),
            ],
          ),
          if (order.deliveredAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Delivered on ${_formatDate(order.deliveredAt!)}',
              style: AppTypography.small(isDark: isDark).copyWith(color: AppColors.success),
            ),
          ],
          const SizedBox(height: 14),
          if (order.status == OrderStatus.delivered ||
              order.status == OrderStatus.cancelled) ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onRepeat,
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Repeat Order'),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTrack,
                    icon: const Icon(Icons.near_me_outlined, size: 18),
                    label: const Text('Track Order'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRepeat,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.mutedForegroundDark
                          : AppColors.mutedForegroundLight,
                      side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Repeat'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _OrderCardSkeleton extends StatelessWidget {
  const _OrderCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
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
                  SkeletonLine(width: w * 0.4, height: 18),
                  const Spacer(),
                  const SkeletonBox(width: 64, height: 22, radius: 12),
                ],
              ),
              const SizedBox(height: 6),
              SkeletonLine(width: w * 0.3),
              const SizedBox(height: 10),
              SkeletonLine(width: w),
              const SizedBox(height: 4),
              SkeletonLine(width: w * 0.7),
              const SizedBox(height: 10),
              Row(
                children: [
                  SkeletonLine(width: 56, height: 16),
                  const Spacer(),
                  SkeletonLine(width: 40),
                ],
              ),
              const SizedBox(height: 14),
              SkeletonBox(width: w, height: 44, radius: 12),
            ],
          );
        },
      ),
    );
  }
}
