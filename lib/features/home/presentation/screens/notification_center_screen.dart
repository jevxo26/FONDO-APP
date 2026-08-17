import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/app_notification.dart';

final List<AppNotification> _notifications = [
  AppNotification(
    id: 'nt_001',
    category: NotificationCategory.order,
    title: 'Order #FONDO-1028 is out for delivery',
    message: 'Rahim Uddin is on the way with your order. Estimated arrival in 12 minutes.',
    time: DateTime.now().subtract(const Duration(minutes: 40)),
    read: false,
  ),
  AppNotification(
    id: 'nt_002',
    category: NotificationCategory.reminder,
    title: 'Meal reminder',
    message: 'Your lunch is scheduled for 12:30 PM. Kacchi Biryani is waiting for you.',
    time: DateTime.now().subtract(const Duration(hours: 1)),
    read: false,
  ),
  AppNotification(
    id: 'nt_003',
    category: NotificationCategory.promotion,
    title: 'Weekend feast — 20% off biryanis',
    message: 'Enjoy 20% off all biryani dishes this weekend. Use code FEAST20 at checkout.',
    time: DateTime.now().subtract(const Duration(hours: 3)),
    read: false,
  ),
  AppNotification(
    id: 'nt_004',
    category: NotificationCategory.order,
    title: 'Order #FONDO-1027 delivered',
    message: 'Your order has been delivered. Enjoy your meal and rate your experience.',
    time: DateTime.now().subtract(const Duration(days: 1)),
    read: true,
  ),
  AppNotification(
    id: 'nt_005',
    category: NotificationCategory.system,
    title: 'App update available',
    message: 'FONDO v1.0.2 is here with faster checkout and live order tracking.',
    time: DateTime.now().subtract(const Duration(days: 2)),
    read: true,
  ),
  AppNotification(
    id: 'nt_006',
    category: NotificationCategory.promotion,
    title: 'Cashback on wallet top-ups',
    message: 'Get 5% cashback on all wallet top-ups above ৳500, limited time only.',
    time: DateTime.now().subtract(const Duration(days: 3)),
    read: true,
  ),
  AppNotification(
    id: 'nt_007',
    category: NotificationCategory.reminder,
    title: 'Subscription renewal coming up',
    message: 'Your Weekly Veg Box subscription renews in 3 days. Manage your plan anytime.',
    time: DateTime.now().subtract(const Duration(days: 5)),
    read: true,
  ),
  AppNotification(
    id: 'nt_008',
    category: NotificationCategory.order,
    title: 'Payment received',
    message: 'Payment of ৳585 for order #FONDO-1030 confirmed via wallet.',
    time: DateTime.now().subtract(const Duration(days: 7)),
    read: true,
  ),
];

bool _pushEnabled = true;
bool _emailEnabled = true;
bool _smsEnabled = false;
bool _orderAlerts = true;
bool _paymentAlerts = true;
bool _promotionAlerts = false;
bool _systemAlerts = true;
bool _mealReminderEnabled = true;
TimeOfDay _mealReminderTime = const TimeOfDay(hour: 12, minute: 30);
bool _deliveryReminderEnabled = true;
bool _subscriptionReminderEnabled = true;

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

enum _NotifTab { all, orders, promotions, reminders }

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  bool _loading = true;
  _NotifTab _tab = _NotifTab.all;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  List<AppNotification> get _filtered {
    switch (_tab) {
      case _NotifTab.all:
        return _notifications;
      case _NotifTab.orders:
        return _notifications.where((n) => n.category == NotificationCategory.order).toList();
      case _NotifTab.promotions:
        return _notifications.where((n) => n.category == NotificationCategory.promotion).toList();
      case _NotifTab.reminders:
        return _notifications.where((n) => n.category == NotificationCategory.reminder).toList();
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.read).length;

  void _markAllRead() {
    HapticFeedback.mediumImpact();
    setState(() {
      for (final n in _notifications) {
        n.read = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read'), behavior: SnackBarBehavior.floating),
    );
  }

  Future<void> _pickMealTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _mealReminderTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Theme.of(context).brightness,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() => _mealReminderTime = picked);
  }

  String _formatTimeLabel(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${time.day} ${months[time.month - 1]}';
  }

  String get _mealTimeLabel {
    final t = _mealReminderTime;
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    final minute = t.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState();
    }

    final filtered = _filtered;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Notifications'),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text('Mark all read', style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
            ),
        ],
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
            SizedBox(
              height: 38,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _NotifChip(
                    label: 'All${_unreadCount > 0 ? ' • $_unreadCount' : ''}',
                    selected: _tab == _NotifTab.all,
                    onTap: () => setState(() => _tab = _NotifTab.all),
                  ),
                  const SizedBox(width: 8),
                  _NotifChip(
                    label: 'Orders',
                    selected: _tab == _NotifTab.orders,
                    onTap: () => setState(() => _tab = _NotifTab.orders),
                  ),
                  const SizedBox(width: 8),
                  _NotifChip(
                    label: 'Promotions',
                    selected: _tab == _NotifTab.promotions,
                    onTap: () => setState(() => _tab = _NotifTab.promotions),
                  ),
                  const SizedBox(width: 8),
                  _NotifChip(
                    label: 'Reminders',
                    selected: _tab == _NotifTab.reminders,
                    onTap: () => setState(() => _tab = _NotifTab.reminders),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (filtered.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(
                  child: Text('No notifications in this tab', style: AppTypography.bodyMedium(isDark: isDark)),
                ),
              )
            else
              ...filtered.map((n) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _NotificationCard(
                      notification: n,
                      timeLabel: _formatTimeLabel(n.time),
                      isDark: isDark,
                      onTap: () {
                        if (!n.read) {
                          HapticFeedback.lightImpact();
                          setState(() => n.read = true);
                        }
                      },
                    ),
                  )),
            const SizedBox(height: 16),
            const _SectionDivider(),
            const SizedBox(height: 20),
            Text('Notification Preferences', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 10),
            _SettingsCard(
              isDark: isDark,
              children: [
                _ToggleTile(
                  icon: Icons.notifications_active_outlined,
                  title: 'Push Notifications',
                  subtitle: 'Real-time alerts on your device',
                  isDark: isDark,
                  value: _pushEnabled,
                  onChanged: (value) => setState(() => _pushEnabled = value),
                ),
                _ToggleTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receipts & account alerts',
                  isDark: isDark,
                  value: _emailEnabled,
                  onChanged: (value) => setState(() => _emailEnabled = value),
                ),
                _ToggleTile(
                  icon: Icons.sms_outlined,
                  title: 'SMS Notifications',
                  subtitle: 'Delivery updates via text',
                  isDark: isDark,
                  value: _smsEnabled,
                  onChanged: (value) => setState(() => _smsEnabled = value),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsCard(
              isDark: isDark,
              children: [
                _ToggleTile(
                  icon: Icons.local_shipping_outlined,
                  title: 'Order Updates',
                  subtitle: 'Status changes & tracking',
                  isDark: isDark,
                  value: _orderAlerts,
                  onChanged: (value) => setState(() => _orderAlerts = value),
                ),
                _ToggleTile(
                  icon: Icons.payments_outlined,
                  title: 'Payment Alerts',
                  subtitle: 'Transactions & receipts',
                  isDark: isDark,
                  value: _paymentAlerts,
                  onChanged: (value) => setState(() => _paymentAlerts = value),
                ),
                _ToggleTile(
                  icon: Icons.local_offer_outlined,
                  title: 'Promotions & Offers',
                  subtitle: 'Deals, cashback & discounts',
                  isDark: isDark,
                  value: _promotionAlerts,
                  onChanged: (value) => setState(() => _promotionAlerts = value),
                ),
                _ToggleTile(
                  icon: Icons.build_outlined,
                  title: 'System Updates',
                  subtitle: 'App news & maintenance',
                  isDark: isDark,
                  value: _systemAlerts,
                  onChanged: (value) => setState(() => _systemAlerts = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Reminders', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 10),
            _SettingsCard(
              isDark: isDark,
              children: [
                _ToggleTile(
                  icon: Icons.restaurant_menu_rounded,
                  title: 'Meal Reminder',
                  subtitle: '$_mealTimeLabel daily',
                  isDark: isDark,
                  value: _mealReminderEnabled,
                  onChanged: (value) => setState(() => _mealReminderEnabled = value),
                  onSubtitleTap: _mealReminderEnabled ? _pickMealTime : null,
                ),
                _ToggleTile(
                  icon: Icons.delivery_dining_outlined,
                  title: 'Delivery Reminder',
                  subtitle: 'Notify before delivery arrives',
                  isDark: isDark,
                  value: _deliveryReminderEnabled,
                  onChanged: (value) => setState(() => _deliveryReminderEnabled = value),
                ),
                _ToggleTile(
                  icon: Icons.event_repeat_rounded,
                  title: 'Subscription Renewal',
                  subtitle: 'Heads-up before a plan renews',
                  isDark: isDark,
                  value: _subscriptionReminderEnabled,
                  onChanged: (value) => setState(() => _subscriptionReminderEnabled = value),
                ),
              ],
            ),
            const SizedBox(height: 24),
              ],
            ),
          ),
        ],
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
        title: const Text('Notifications'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            Row(
              children: [
                SkeletonBox(width: 56, height: 34, radius: 20),
                SizedBox(width: 8),
                SkeletonBox(width: 72, height: 34, radius: 20),
                SizedBox(width: 8),
                SkeletonBox(width: 96, height: 34, radius: 20),
                SizedBox(width: 8),
                SkeletonBox(width: 88, height: 34, radius: 20),
              ],
            ),
            SizedBox(height: 12),
            _NotificationSkeleton(),
            SizedBox(height: 10),
            _NotificationSkeleton(),
            SizedBox(height: 10),
            _NotificationSkeleton(),
            SizedBox(height: 20),
            SkeletonLine(width: 140),
            SizedBox(height: 10),
            SkeletonBox(width: double.infinity, height: 148, radius: 14),
          ],
        ),
      ),
    );
  }
}

class _NotifChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NotifChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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

class _NotificationCard extends StatelessWidget {
  final AppNotification notification;
  final String timeLabel;
  final bool isDark;
  final VoidCallback onTap;

  const _NotificationCard({
    required this.notification,
    required this.timeLabel,
    required this.isDark,
    required this.onTap,
  });

  IconData get _icon {
    switch (notification.category) {
      case NotificationCategory.order:
        return Icons.local_shipping_outlined;
      case NotificationCategory.promotion:
        return Icons.local_offer_outlined;
      case NotificationCategory.reminder:
        return Icons.alarm_outlined;
      case NotificationCategory.system:
        return Icons.build_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final unread = !notification.read;
    return PressScale(
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        radius: 14,
        onTap: onTap,
        color: unread
            ? AppColors.primary.withValues(alpha: 0.06)
            : (isDark ? AppColors.cardDark : AppColors.cardLight).withValues(alpha: 0.72),
        borderColor: unread
            ? AppColors.primary.withValues(alpha: 0.35)
            : AppColors.primary.withValues(alpha: 0.05),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: AppColors.primary, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.titleMedium(isDark: isDark).copyWith(
                              fontWeight: unread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                        if (unread) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(notification.message, style: AppTypography.small(isDark: isDark)),
                    const SizedBox(height: 6),
                    Text(
                      timeLabel,
                      style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;

  const _SettingsCard({required this.isDark, required this.children});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.zero,
      radius: 14,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                indent: 68,
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;
  final VoidCallback? onSubtitleTap;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.value,
    required this.onChanged,
    this.onSubtitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: GestureDetector(
              onTap: onSubtitleTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.titleMedium(isDark: isDark)),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(subtitle, style: AppTypography.small(isDark: isDark)),
                      ),
                      if (onSubtitleTap != null) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.edit_rounded, size: 12, color: AppColors.primary),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: (v) {
              HapticFeedback.selectionClick();
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}

class _NotificationSkeleton extends StatelessWidget {
  const _NotificationSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SkeletonBox(width: 38, height: 38, radius: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: w * 0.6),
                    const SizedBox(height: 6),
                    SkeletonLine(width: w),
                    const SizedBox(height: 4),
                    SkeletonLine(width: w * 0.85),
                    const SizedBox(height: 6),
                    SkeletonLine(width: 48),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
