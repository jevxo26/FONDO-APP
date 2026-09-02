import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_orders.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/order_model.dart';

// ── 4-Phase Order Lifecycle ─────────────────────────────────────────────────
const _trackStages = [
  _TrackStage(
    label: 'Order Placed',
    subtitle: 'We received your order',
    icon: Icons.receipt_long_rounded,
  ),
  _TrackStage(
    label: 'Kitchen Preparing',
    subtitle: 'Chefs are cooking your meal',
    icon: Icons.outdoor_grill_rounded,
  ),
  _TrackStage(
    label: 'Rider on the Way',
    subtitle: 'Your order has been picked up',
    icon: Icons.electric_bike_rounded,
  ),
  _TrackStage(
    label: 'Delivered',
    subtitle: 'Enjoy your meal!',
    icon: Icons.home_rounded,
  ),
];

class _TrackStage {
  final String label;
  final String subtitle;
  final IconData icon;
  const _TrackStage({required this.label, required this.subtitle, required this.icon});
}

const _riderName = 'Rahim Uddin';
const _riderPhone = '+880 1712-345678';
const _riderRating = 4.9;

const _issueCategories = [
  'Order is late',
  'Wrong items delivered',
  'Food quality concern',
  'Rider unresponsive',
  'Payment / billing issue',
  'Other',
];

// Map OrderStatus → stage index (0-based, 4 stages)
int _stageProgress(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
    case OrderStatus.confirmed:
      return 1; // Order Placed done
    case OrderStatus.preparing:
      return 2; // Kitchen Preparing done
    case OrderStatus.outForDelivery:
      return 3; // Rider on the Way done
    case OrderStatus.delivered:
      return 4; // All done
    case OrderStatus.cancelled:
      return 0;
  }
}

// ETA seconds remaining per status (simulated)
int _etaSeconds(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
    case OrderStatus.confirmed:
      return 28 * 60;
    case OrderStatus.preparing:
      return 18 * 60;
    case OrderStatus.outForDelivery:
      return 7 * 60;
    default:
      return 0;
  }
}

String _stageTime(OrderStatus status, int index) {
  if (status == OrderStatus.delivered) {
    const times = ['12:05', '12:20', '12:45', '12:55'];
    return index < 4 ? times[index] : '';
  }
  switch (status) {
    case OrderStatus.outForDelivery:
      const times = ['07:31', '07:36', '07:51'];
      return index < 3 ? times[index] : '';
    case OrderStatus.preparing:
      const times = ['12:12', '12:25'];
      return index < 2 ? times[index] : '';
    case OrderStatus.confirmed:
    case OrderStatus.pending:
      return index == 0 ? '19:32' : '';
    default:
      return '';
  }
}

class LiveOrderTrackingScreen extends StatefulWidget {
  final String orderId;

  const LiveOrderTrackingScreen({super.key, required this.orderId});

  @override
  State<LiveOrderTrackingScreen> createState() => _LiveOrderTrackingScreenState();
}

class _LiveOrderTrackingScreenState extends State<LiveOrderTrackingScreen> {
  bool _loading = true;
  late int _etaSecondsRemaining;
  Timer? _etaTimer;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) {
        final order = _order;
        setState(() {
          _loading = false;
          _etaSecondsRemaining = order != null ? _etaSeconds(order.status) : 0;
        });
        _startEtaTimer();
      }
    });
  }

  void _startEtaTimer() {
    _etaTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_etaSecondsRemaining > 0) {
        setState(() => _etaSecondsRemaining--);
      } else {
        _etaTimer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _etaTimer?.cancel();
    super.dispose();
  }

  String get _etaFormatted {
    if (_etaSecondsRemaining <= 0) return 'Arriving now';
    final m = _etaSecondsRemaining ~/ 60;
    final s = _etaSecondsRemaining % 60;
    if (m == 0) return '${s}s';
    return '${m}m ${s.toString().padLeft(2, '0')}s';
  }

  OrderModel? get _order {
    for (final order in mockOrders) {
      if (order.id == widget.orderId) return order;
    }
    return null;
  }

  void _openIssueModal(OrderModel order) {
    String? issueCategory;
    String issueNote = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Report an Issue', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 4),
                Text(
                  'Tell us what went wrong with ${order.orderNumber}',
                  style: AppTypography.small(isDark: isDark),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final category in _issueCategories)
                      GestureDetector(
                        onTap: () => setSheetState(() => issueCategory = category),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: issueCategory == category
                                ? AppColors.primary
                                : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
                            borderRadius: BorderRadius.circular(20),
                            border: issueCategory == category
                                ? null
                                : Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                          ),
                          child: Text(
                            category,
                            style: AppTypography.label(isDark: isDark).copyWith(
                              color: issueCategory == category ? AppColors.primaryForeground : null,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  minLines: 2,
                  maxLines: 4,
                  onChanged: (value) => setSheetState(() => issueNote = value),
                  decoration: InputDecoration(
                    hintText: 'Add more details (optional)',
                    hintStyle: AppTypography.small(isDark: isDark),
                    filled: true,
                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: issueCategory == null
                        ? null
                        : () {
                            HapticFeedback.mediumImpact();
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  issueNote.trim().isEmpty
                                      ? '$issueCategory — issue reported.'
                                      : '$issueCategory — ${issueNote.trim()}',
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Submit Report'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final order = _order;

    if (_loading) {
      return _TrackingSkeleton(isDark: isDark);
    }

    if (order == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop()),
        ),
        body: Center(
          child: Text('Order not found', style: AppTypography.bodyMedium(isDark: isDark)),
        ),
      );
    }

    final progress = _stageProgress(order.status);
    final active = order.status == OrderStatus.outForDelivery || order.status == OrderStatus.preparing;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text('Track ${order.orderNumber}'),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
            if (order.status == OrderStatus.cancelled) ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.destructive.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.cancel_outlined, color: AppColors.destructive),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'This order was cancelled',
                        style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                          color: AppColors.destructive,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            _StatusHeader(
              order: order,
              isDark: isDark,
              etaFormatted: _etaFormatted,
            ),
            const SizedBox(height: 16),
            _StageTimeline(
              progress: progress,
              isDark: isDark,
              status: order.status,
              etaFormatted: _etaFormatted,
            ),
            const SizedBox(height: 16),
            if (active) ...[
              const _LiveMap(),
              const SizedBox(height: 16),
              _RiderCard(isDark: isDark),
              const SizedBox(height: 16),
            ],
            _ReceiptCard(order: order, isDark: isDark),
            if (!active) const SizedBox(height: 16),
            if (active)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _openIssueModal(order),
                  icon: const Icon(Icons.report_problem_outlined, size: 18),
                  label: const Text('Report an Issue'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.destructive,
                    side: const BorderSide(color: AppColors.destructive),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
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

class _StatusHeader extends StatelessWidget {
  final OrderModel order;
  final bool isDark;
  final String etaFormatted;

  const _StatusHeader({
    required this.order,
    required this.isDark,
    required this.etaFormatted,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = order.status == OrderStatus.outForDelivery ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.confirmed ||
        order.status == OrderStatus.pending;
    final isDelivered = order.status == OrderStatus.delivered;

    return GlassCard(
      padding: const EdgeInsets.all(18),
      radius: 18,
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isDelivered
                  ? AppColors.success.withValues(alpha: 0.15)
                  : AppColors.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDelivered
                  ? Icons.check_circle_rounded
                  : isActive
                      ? Icons.electric_bike_rounded
                      : Icons.cancel_rounded,
              color: isDelivered ? AppColors.success : AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDelivered
                      ? 'Order Delivered!'
                      : isActive
                          ? 'Your order is on the way'
                          : 'Order ${order.statusLabel.toLowerCase()}',
                  style: AppTypography.cardTitle(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                if (isActive)
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFB8860B), AppColors.primary],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.timer_rounded,
                                size: 12, color: Colors.white),
                            const SizedBox(width: 4),
                            Text(
                              'ETA $etaFormatted',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    isDelivered
                        ? 'Delivered to your door'
                        : 'We\'ll update you shortly',
                    style: AppTypography.small(isDark: isDark),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageTimeline extends StatelessWidget {
  final int progress;
  final bool isDark;
  final OrderStatus status;
  final String etaFormatted;

  const _StageTimeline({
    required this.progress,
    required this.isDark,
    required this.status,
    required this.etaFormatted,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
      radius: 18,
      child: Column(
        children: [
          for (var i = 0; i < _trackStages.length; i++)
            _StageRow(
              index: i,
              stage: _trackStages[i],
              time: _stageTime(status, i),
              done: i < progress,
              isActive: i == progress && progress < _trackStages.length,
              isLast: i == _trackStages.length - 1,
              isDark: isDark,
              etaFormatted: (i == progress && progress < _trackStages.length)
                  ? etaFormatted
                  : null,
            ),
        ],
      ),
    );
  }
}

class _StageRow extends StatelessWidget {
  final int index;
  final _TrackStage stage;
  final String time;
  final bool done;
  final bool isActive;
  final bool isLast;
  final bool isDark;
  final String? etaFormatted;

  const _StageRow({
    required this.index,
    required this.stage,
    required this.time,
    required this.done,
    required this.isActive,
    required this.isLast,
    required this.isDark,
    this.etaFormatted,
  });

  @override
  Widget build(BuildContext context) {
    final Color nodeColor;
    if (done) {
      nodeColor = AppColors.primary;
    } else if (isActive) {
      nodeColor = AppColors.primary;
    } else {
      nodeColor = isDark ? AppColors.borderDark : const Color(0xFFDDD6CF);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Node + connector line ──
        SizedBox(
          width: 44,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done
                      ? AppColors.primary
                      : isActive
                          ? AppColors.primary.withValues(alpha: 0.14)
                          : Colors.transparent,
                  border: Border.all(
                    color: nodeColor,
                    width: isActive ? 2.5 : 2,
                  ),
                  boxShadow: (done || isActive)
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 1,
                          )
                        ]
                      : null,
                ),
                child: done
                    ? const Icon(Icons.check_rounded,
                        size: 18, color: Colors.white)
                    : isActive
                        ? Icon(stage.icon,
                            size: 16, color: AppColors.primary)
                        : Icon(stage.icon,
                            size: 14,
                            color: isDark
                                ? AppColors.mutedForegroundDark
                                : AppColors.mutedForegroundLight),
              ),
              if (!isLast)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 2,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: done
                          ? [AppColors.primary, AppColors.primary]
                          : [
                              nodeColor,
                              nodeColor.withValues(alpha: 0.3),
                            ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        // ── Stage info ──
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(top: 6, bottom: isLast ? 0 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        stage.label,
                        style:
                            AppTypography.bodyMedium(isDark: isDark).copyWith(
                          fontWeight: (done || isActive)
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: (done || isActive)
                              ? null
                              : (isDark
                                  ? AppColors.mutedForegroundDark
                                  : AppColors.mutedForegroundLight),
                        ),
                      ),
                    ),
                    if (time.isNotEmpty)
                      Text(
                        time,
                        style: AppTypography.small(isDark: isDark)
                            .copyWith(fontSize: 11),
                      ),
                    if (isActive && etaFormatted != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '~$etaFormatted',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                  ],
                ),
                if (done || isActive) ...[
                  const SizedBox(height: 2),
                  Text(
                    stage.subtitle,
                    style: AppTypography.small(isDark: isDark).copyWith(
                      fontSize: 11.5,
                      color: (done || isActive)
                          ? (isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight)
                          : Colors.transparent,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveMap extends StatefulWidget {
  const _LiveMap();

  @override
  State<_LiveMap> createState() => _LiveMapState();
}

class _LiveMapState extends State<_LiveMap> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SizedBox(
      height: 190,
      child: GlassCard(
        padding: EdgeInsets.zero,
        radius: 16,
        child: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) => CustomPaint(
              size: Size.infinite,
              painter: _MapPainter(progress: _controller.value, isDark: isDark),
            ),
          ),
          const Positioned(
            left: 16,
            top: 12,
            child: _MapPinLabel(icon: Icons.storefront_outlined, label: 'FONDO Kitchen'),
          ),
          const Positioned(
            right: 16,
            bottom: 12,
            child: _MapPinLabel(icon: Icons.home_outlined, label: 'Home'),
          ),
          ],
        ),
      ),
    );
  }
}

class _MapPinLabel extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MapPinLabel({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(label, style: AppTypography.badge(isDark: isDark)),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _MapPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final gridColor = isDark ? AppColors.borderDark.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.7);
    final roadPaint = Paint()
      ..color = gridColor
      ..strokeWidth = 2;

    final rng = math.Random(7);
    for (var i = 0; i < 9; i++) {
      final dy = rng.nextDouble() * size.height;
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), roadPaint);
    }
    for (var i = 0; i < 9; i++) {
      final dx = rng.nextDouble() * size.width;
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), roadPaint);
    }

    final start = Offset(size.width * 0.12, size.height * 0.78);
    final end = Offset(size.width * 0.85, size.height * 0.2);
    final control = Offset(size.width * 0.35, size.height * 0.18);

    final routePaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, routePaint);

    final riderPoint = _pointOnQuad(start, control, end, progress);

    canvas.drawCircle(start, 6, Paint()..color = AppColors.primary);
    canvas.drawCircle(end, 6, Paint()..color = AppColors.success);

    final glow = Paint()..color = AppColors.primary.withValues(alpha: 0.25);
    canvas.drawCircle(riderPoint, 14, glow);
    canvas.drawCircle(riderPoint, 6, Paint()..color = AppColors.primary);
    canvas.drawCircle(riderPoint, 3, Paint()..color = Colors.white);
  }

  Offset _pointOnQuad(Offset p0, Offset p1, Offset p2, double t) {
    final u = 1 - t;
    return Offset(
      u * u * p0.dx + 2 * u * t * p1.dx + t * t * p2.dx,
      u * u * p0.dy + 2 * u * t * p1.dy + t * t * p2.dy,
    );
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}

class _RiderCard extends StatelessWidget {
  final bool isDark;

  const _RiderCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 16,
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primary.withValues(alpha: 0.15),
            child: const Icon(Icons.person_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_riderName, style: AppTypography.cardTitle(isDark: isDark)),
                const SizedBox(height: 2),
                Text(_riderPhone, style: AppTypography.small(isDark: isDark)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 2),
                    Text('$_riderRating rider rating', style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () {
              HapticFeedback.lightImpact();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Calling rider $_riderPhone...'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.call_rounded, color: AppColors.primaryForeground),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptCard extends StatelessWidget {
  final OrderModel order;
  final bool isDark;

  const _ReceiptCard({required this.order, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      radius: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Order Summary', style: AppTypography.cardTitle(isDark: isDark)),
              const Spacer(),
              Text(order.orderNumber, style: AppTypography.small(isDark: isDark)),
            ],
          ),
          const SizedBox(height: 12),
          for (final item in order.items)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.foodName} ×${item.quantity}',
                      style: AppTypography.bodyMedium(isDark: isDark),
                    ),
                  ),
                  Text(
                    '৳${(item.price * item.quantity).toStringAsFixed(0)}',
                    style: AppTypography.bodyMedium(isDark: isDark),
                  ),
                ],
              ),
            ),
          const Divider(height: 24),
          _ReceiptRow(label: 'Subtotal', amount: order.subtotal, isDark: isDark),
          _ReceiptRow(label: 'Delivery fee', amount: order.deliveryFee, isDark: isDark),
          _ReceiptRow(label: 'Discount', amount: -order.discount, isDark: isDark),
          const SizedBox(height: 6),
          _ReceiptRow(label: 'Total', amount: order.total, isDark: isDark, isTotal: true),
          const SizedBox(height: 4),
          Text(
            'Paid via ${order.paymentMethod}',
            style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isDark;
  final bool isTotal;

  const _ReceiptRow({
    required this.label,
    required this.amount,
    required this.isDark,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? AppTypography.label(isDark: isDark).copyWith(fontSize: 16, fontWeight: FontWeight.w700)
        : AppTypography.bodyMedium(isDark: isDark);
    final value = amount < 0 ? '-৳${(amount.abs()).toStringAsFixed(0)}' : '৳${amount.toStringAsFixed(0)}';
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: isTotal ? AppTypography.price(isDark: isDark) : style),
        ],
      ),
    );
  }
}

class _TrackingSkeleton extends StatelessWidget {
  final bool isDark;

  const _TrackingSkeleton({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Track order'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            SkeletonBox(width: double.infinity, height: 76, radius: 16),
            const SizedBox(height: 16),
            SkeletonBox(width: double.infinity, height: 220, radius: 16),
            const SizedBox(height: 16),
            SkeletonBox(width: double.infinity, height: 90, radius: 16),
            const SizedBox(height: 16),
            SkeletonBox(width: double.infinity, height: 200, radius: 16),
          ],
        ),
      ),
    );
  }
}
