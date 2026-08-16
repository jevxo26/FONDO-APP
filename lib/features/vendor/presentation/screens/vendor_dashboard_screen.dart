import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/order_model.dart';

const List<double> mockWeeklyEarnings = [5200, 6800, 6100, 7400, 7900, 8600, 9200];
const List<String> mockWeekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

final List<OrderModel> _recentOrders = [
  OrderModel(
    id: 'vord_004',
    orderNumber: '#FONDO-1034',
    items: const [
      OrderItem(foodName: 'Chicken Biryani', quantity: 2, price: 320),
      OrderItem(foodName: 'Naan', quantity: 3, price: 40),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 760,
    deliveryFee: 50,
    discount: 40,
    total: 770,
    status: OrderStatus.pending,
    orderedAt: DateTime(2026, 6, 30, 19, 30),
    deliveryAddress: '42 Gulshan Avenue, Dhaka 1212',
    paymentMethod: 'Cash on Delivery',
    customerName: 'Sadia Rahman',
  ),
  OrderModel(
    id: 'vord_003',
    orderNumber: '#FONDO-1033',
    items: const [
      OrderItem(foodName: 'Beef Khichuri', quantity: 1, price: 280),
      OrderItem(foodName: 'Fried Egg', quantity: 1, price: 30),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 390,
    deliveryFee: 40,
    discount: 0,
    total: 430,
    status: OrderStatus.confirmed,
    orderedAt: DateTime(2026, 6, 30, 12, 40),
    deliveryAddress: '15/B Banani Road 11, Dhaka 1213',
    paymentMethod: 'Wallet',
    customerName: 'Tanjim Islam',
  ),
  OrderModel(
    id: 'vord_002',
    orderNumber: '#FONDO-1032',
    items: const [
      OrderItem(foodName: 'Grilled Chicken Platter', quantity: 1, price: 520),
      OrderItem(foodName: 'Naan', quantity: 2, price: 40),
    ],
    subtotal: 600,
    deliveryFee: 50,
    discount: 50,
    total: 600,
    status: OrderStatus.outForDelivery,
    orderedAt: DateTime(2026, 6, 29, 19, 0),
    deliveryAddress: '7/B Dhanmondi 27, Dhaka 1209',
    paymentMethod: 'Cash on Delivery',
    customerName: 'Nusrat Jahan',
  ),
  OrderModel(
    id: 'vord_001',
    orderNumber: '#FONDO-1031',
    items: const [
      OrderItem(foodName: 'Butter Chicken', quantity: 1, price: 350),
      OrderItem(foodName: 'Naan', quantity: 2, price: 40),
      OrderItem(foodName: 'Salad', quantity: 1, price: 80),
    ],
    subtotal: 510,
    deliveryFee: 40,
    discount: 30,
    total: 520,
    status: OrderStatus.delivered,
    orderedAt: DateTime(2026, 6, 28, 13, 20),
    deliveredAt: DateTime(2026, 6, 28, 14, 5),
    deliveryAddress: '12 Uttara Sector 4, Dhaka 1230',
    paymentMethod: 'Wallet',
    customerName: 'Arif Hossain',
  ),
];

Color _orderStatusColor(OrderStatus status) {
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

String _statusLabel(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.confirmed:
      return 'Confirmed';
    case OrderStatus.preparing:
      return 'Preparing';
    case OrderStatus.outForDelivery:
      return 'Out for Delivery';
    case OrderStatus.delivered:
      return 'Delivered';
    case OrderStatus.cancelled:
      return 'Cancelled';
  }
}

String _itemsSummary(List<OrderItem> items) {
  final extra = items.length - 1;
  return extra > 0 ? '${items.first.foodName} +$extra more' : items.first.foodName;
}

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _GreetingHeader(isDark: isDark),
            const SizedBox(height: 20),
            _OnlineBanner(
              isOnline: _isOnline,
              onToggle: (value) => setState(() => _isOnline = value),
            ),
            const SizedBox(height: 16),
            _VerificationRow(isDark: isDark),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _StatCard(label: "Today's Orders", value: '24', icon: Icons.receipt_long_rounded, tint: AppColors.primary, isDark: isDark),
                _StatCard(label: "Today's Earnings", value: '৳8,450', icon: Icons.trending_up_rounded, tint: AppColors.success, isDark: isDark),
                _StatCard(label: 'Avg Rating', value: '4.7', icon: Icons.star_rounded, tint: AppColors.warning, isDark: isDark),
                _StatCard(label: 'Pending', value: '5', icon: Icons.hourglass_top_rounded, tint: Colors.blue, isDark: isDark),
              ],
            ),
            const SizedBox(height: 24),
            _WeeklyEarningsCard(isDark: isDark),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add_rounded, size: 20),
                    label: const Text('Add Food'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.receipt_long_rounded, size: 20),
                    label: const Text('View Orders'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text('Recent Orders', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 12),
            ..._recentOrders.map((order) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _RecentOrderCard(order: order, isDark: isDark),
            )),
          ],
        ),
      ),
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  final bool isDark;

  const _GreetingHeader({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: AppColors.primary,
          child: Text(
            'RR',
            style: AppTypography.titleLarge(isDark: false).copyWith(
              color: AppColors.primaryForeground,
              fontSize: 20,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening, Rafiq Restaurant',
                style: AppTypography.titleLarge(isDark: isDark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text('Vendor Partner • Gold', style: AppTypography.small(isDark: isDark)),
            ],
          ),
        ),
      ],
    );
  }
}

class _OnlineBanner extends StatelessWidget {
  final bool isOnline;
  final ValueChanged<bool> onToggle;

  const _OnlineBanner({required this.isOnline, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final statusColor = isOnline ? AppColors.success : AppColors.mutedForegroundLight;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isOnline
              ? [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)]
              : [AppColors.mutedForegroundLight, AppColors.mutedForegroundLight.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Currently',
                style: AppTypography.bodyMedium(isDark: false).copyWith(
                  color: AppColors.primaryForeground.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                      size: 12,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isOnline ? 'ONLINE' : 'OFFLINE',
                      style: AppTypography.badge(isDark: false).copyWith(
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  isOnline
                      ? 'Accepting new orders in your service areas'
                      : 'Orders are paused. Go online to accept new orders.',
                  style: AppTypography.bodyMedium(isDark: false).copyWith(
                    color: AppColors.primaryForeground.withValues(alpha: 0.8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Switch(
                value: isOnline,
                activeThumbColor: Colors.white,
                activeTrackColor: AppColors.success,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: AppColors.mutedForegroundDark.withValues(alpha: 0.6),
                onChanged: onToggle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  final bool isDark;

  const _VerificationRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppColors.success, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Business verified',
              style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'APPROVED',
              style: AppTypography.badge(isDark: isDark).copyWith(
                color: AppColors.success,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  final bool isDark;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: tint, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: AppTypography.statValue(isDark: isDark).copyWith(fontSize: 22),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(label, style: AppTypography.small(isDark: isDark)),
        ],
      ),
    );
  }
}

class _WeeklyEarningsCard extends StatelessWidget {
  final bool isDark;

  const _WeeklyEarningsCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final maxValue = mockWeeklyEarnings.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
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
              Text('Weekly Earnings', style: AppTypography.label(isDark: isDark)),
              const Spacer(),
              Text('৳51,200', style: AppTypography.price(isDark: isDark).copyWith(fontSize: 15)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.trending_up_rounded, size: 12, color: AppColors.success),
                    const SizedBox(width: 2),
                    Text(
                      '+12%',
                      style: AppTypography.badge(isDark: false).copyWith(
                        color: AppColors.success,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(mockWeeklyEarnings.length, (i) {
                      final isLast = i == mockWeeklyEarnings.length - 1;
                      return Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isLast) ...[
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 3),
                            ],
                            Container(
                              width: 20,
                              height: (mockWeeklyEarnings[i] / maxValue) * 90,
                              decoration: BoxDecoration(
                                color: isLast
                                    ? AppColors.primary
                                    : AppColors.primary.withValues(alpha: 0.85),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
                Container(
                  height: 1,
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
                const SizedBox(height: 6),
                Row(
                  children: mockWeekdayLabels
                      .asMap()
                      .entries
                      .map((entry) => Expanded(
                            child: Text(
                              entry.value,
                              textAlign: TextAlign.center,
                              style: AppTypography.small(isDark: isDark).copyWith(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: entry.key == mockWeekdayLabels.length - 1 ? AppColors.primary : null,
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final OrderStatus status;
  final bool isDark;

  const _StatusPill({required this.status, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final color = _orderStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusLabel(status),
        style: AppTypography.badge(isDark: isDark).copyWith(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _RecentOrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const _RecentOrderCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.orderNumber, style: AppTypography.label(isDark: isDark)),
              const Spacer(),
              _StatusPill(status: order.status, isDark: isDark),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  order.customerName ?? 'Customer',
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                    color: isDark ? AppColors.foregroundDark : AppColors.foregroundLight,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '৳${order.total.toStringAsFixed(0)}',
                style: AppTypography.price(isDark: isDark).copyWith(fontSize: 15),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            _itemsSummary(order.items),
            style: AppTypography.small(isDark: isDark),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
