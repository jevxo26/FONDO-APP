import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/order_model.dart';

final List<OrderModel> _allOrders = [
  OrderModel(
    id: 'ord_001',
    orderNumber: '#FONDO-1024',
    items: const [
      OrderItem(foodName: 'Chicken Biryani', quantity: 2, price: 320),
      OrderItem(foodName: 'Beef Curry', quantity: 1, price: 280),
      OrderItem(foodName: 'Naan', quantity: 3, price: 40),
    ],
    subtotal: 720,
    deliveryFee: 50,
    discount: 40,
    total: 730,
    status: OrderStatus.delivered,
    orderedAt: DateTime(2026, 5, 15, 12, 30),
    deliveredAt: DateTime(2026, 5, 15, 13, 15),
    deliveryAddress: '42 Gulshan Avenue, Dhaka 1212',
    paymentMethod: 'Wallet',
  ),
  OrderModel(
    id: 'ord_002',
    orderNumber: '#FONDO-1025',
    items: const [
      OrderItem(foodName: 'Butter Chicken', quantity: 1, price: 350),
      OrderItem(foodName: 'Naan', quantity: 2, price: 40),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 510,
    deliveryFee: 40,
    discount: 0,
    total: 550,
    status: OrderStatus.delivered,
    orderedAt: DateTime(2026, 5, 22, 19, 0),
    deliveredAt: DateTime(2026, 5, 22, 19, 40),
    deliveryAddress: '15/B Banani Road 11, Dhaka 1213',
    paymentMethod: 'Cash on Delivery',
  ),
  OrderModel(
    id: 'ord_003',
    orderNumber: '#FONDO-1026',
    items: const [
      OrderItem(foodName: 'Dal Tadka', quantity: 2, price: 180),
      OrderItem(foodName: 'Vegetable Fried Rice', quantity: 1, price: 250),
    ],
    subtotal: 610,
    deliveryFee: 50,
    discount: 30,
    total: 630,
    status: OrderStatus.cancelled,
    orderedAt: DateTime(2026, 6, 1, 18, 45),
    deliveryAddress: '7/B Dhanmondi 27, Dhaka 1209',
    paymentMethod: 'Wallet',
  ),
  OrderModel(
    id: 'ord_004',
    orderNumber: '#FONDO-1027',
    items: const [
      OrderItem(foodName: 'Fish Fry', quantity: 2, price: 220),
      OrderItem(foodName: 'Vegetable Fried Rice', quantity: 1, price: 250),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 770,
    deliveryFee: 40,
    discount: 50,
    total: 760,
    status: OrderStatus.delivered,
    orderedAt: DateTime(2026, 6, 10, 13, 0),
    deliveredAt: DateTime(2026, 6, 10, 13, 35),
    deliveryAddress: '12 Uttara Sector 4, Dhaka 1230',
    paymentMethod: 'Wallet',
  ),
  OrderModel(
    id: 'ord_005',
    orderNumber: '#FONDO-1028',
    items: const [
      OrderItem(foodName: 'Chicken Biryani', quantity: 1, price: 320),
      OrderItem(foodName: 'Beef Curry', quantity: 1, price: 280),
      OrderItem(foodName: 'Dal Tadka', quantity: 1, price: 180),
      OrderItem(foodName: 'Naan', quantity: 2, price: 40),
    ],
    subtotal: 860,
    deliveryFee: 50,
    discount: 60,
    total: 850,
    status: OrderStatus.outForDelivery,
    orderedAt: DateTime(2026, 6, 28, 19, 30),
    deliveryAddress: '25/B Mirpur Road, Dhaka 1205',
    paymentMethod: 'Cash on Delivery',
  ),
  OrderModel(
    id: 'ord_006',
    orderNumber: '#FONDO-1029',
    items: const [
      OrderItem(foodName: 'Butter Chicken', quantity: 1, price: 350),
      OrderItem(foodName: 'Fish Fry', quantity: 1, price: 220),
      OrderItem(foodName: 'Naan', quantity: 3, price: 40),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 770,
    deliveryFee: 40,
    discount: 30,
    total: 780,
    status: OrderStatus.delivered,
    orderedAt: DateTime(2026, 6, 19, 12, 15),
    deliveredAt: DateTime(2026, 6, 19, 12, 55),
    deliveryAddress: '10 Gulshan Road, Dhaka 1212',
    paymentMethod: 'Wallet',
  ),
];

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

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
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
    if (_filter == 'All') return _allOrders;
    if (_filter == 'Delivered') {
      return _allOrders.where((o) => o.status == OrderStatus.delivered).toList();
    }
    return _allOrders.where((o) => o.status == OrderStatus.cancelled).toList();
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
                    child: _OrderCard(order: _filteredOrders[index], isDark: isDark),
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

  const _OrderCard({required this.order, required this.isDark});

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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Repeat Order'),
            ),
          ),
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
