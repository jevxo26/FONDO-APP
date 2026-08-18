import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/skeleton.dart';

class DeviceSession {
  final String id;
  final String device;
  final String os;
  final String app;
  final String ip;
  final String location;
  final String lastActive;
  final bool isCurrent;

  const DeviceSession({
    required this.id,
    required this.device,
    required this.os,
    required this.app,
    required this.ip,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });
}

final List<DeviceSession> _activeSessions = [
  const DeviceSession(
    id: 'dev_001',
    device: 'iPhone 15 Pro',
    os: 'iOS 18.1',
    app: 'FONDO App',
    ip: '103.67.156.8',
    location: 'Dhaka, Bangladesh',
    lastActive: 'Active now',
    isCurrent: true,
  ),
  const DeviceSession(
    id: 'dev_002',
    device: 'Pixel 8',
    os: 'Android 15',
    app: 'FONDO App',
    ip: '45.123.88.210',
    location: 'Chittagong, Bangladesh',
    lastActive: '2 hours ago',
  ),
  const DeviceSession(
    id: 'dev_003',
    device: 'MacBook Pro',
    os: 'macOS 15.1',
    app: 'Google Chrome',
    ip: '92.65.30.4',
    location: 'Sylhet, Bangladesh',
    lastActive: 'Yesterday, 8:14 PM',
  ),
  const DeviceSession(
    id: 'dev_004',
    device: 'Samsung Galaxy S23',
    os: 'Android 14',
    app: 'FONDO App',
    ip: '10.24.77.19',
    location: 'Dhaka, Bangladesh',
    lastActive: '3 days ago',
  ),
];

class DeviceRegistryScreen extends StatefulWidget {
  const DeviceRegistryScreen({super.key});

  @override
  State<DeviceRegistryScreen> createState() => _DeviceRegistryScreenState();
}

class _DeviceRegistryScreenState extends State<DeviceRegistryScreen> {
  bool _loading = true;
  bool _revoking = false;

  List<DeviceSession> get _sessions => _activeSessions;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _revokeSession(DeviceSession session) {
    HapticFeedback.mediumImpact();
    setState(() => _sessions.removeWhere((s) => s.id == session.id));
    _showSnack('Signed out ${session.device}');
  }

  Future<void> _revokeAllOthers() async {
    final others = _sessions.where((s) => !s.isCurrent).toList();
    if (others.isEmpty) {
      _showSnack('No other active sessions');
      return;
    }

    HapticFeedback.lightImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Log Out Other Devices?'),
          content: Text(
            'This will sign out ${others.length} other device${others.length == 1 ? '' : 's'}. You will stay signed in on this device.',
            style: AppTypography.bodyMedium(isDark: isDark),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.destructive),
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    setState(() => _revoking = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;

    setState(() {
      _revoking = false;
      _sessions.removeWhere((s) => !s.isCurrent);
    });
    _showSnack('Signed out ${others.length} device${others.length == 1 ? '' : 's'}');
  }

  IconData _deviceIcon(DeviceSession session) {
    if (session.os.contains('iOS')) return Icons.phone_iphone_rounded;
    if (session.os.contains('Android')) return Icons.phone_android_rounded;
    if (session.os.contains('macOS')) return Icons.laptop_mac_rounded;
    return Icons.computer_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loading) {
      return _buildLoadingState(isDark: isDark);
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Active Devices'),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.shield_rounded, color: AppColors.primary, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_sessions.length} active session${_sessions.length == 1 ? '' : 's'}',
                          style: AppTypography.titleMedium(isDark: isDark),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'These devices can access your FONDO account',
                          style: AppTypography.small(isDark: isDark),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            for (final session in _sessions) ...[
              _DeviceCard(
                session: session,
                isDark: isDark,
                deviceIcon: _deviceIcon(session),
                onRevoke: session.isCurrent ? null : () => _revokeSession(session),
              ),
              const SizedBox(height: 10),
            ],
            const SizedBox(height: 14),
            PrimaryButton(
              text: 'Log Out All Other Devices',
              isLoading: _revoking,
              backgroundColor: AppColors.destructive,
              icon: const Icon(Icons.logout_rounded, size: 20),
              onPressed: _revokeAllOthers,
            ),
            const SizedBox(height: 16),
            Text(
              'If you notice a device you don\'t recognise, log it out and change your password immediately.',
              style: AppTypography.small(isDark: isDark),
            ),
            ],
          ),
        ),
      ],
    ),
  );
  }

  Widget _buildLoadingState({required bool isDark}) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Active Devices'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: const [
            _DeviceBannerSkeleton(),
            SizedBox(height: 20),
            _DeviceCardSkeleton(),
            SizedBox(height: 10),
            _DeviceCardSkeleton(),
            SizedBox(height: 10),
            _DeviceCardSkeleton(),
            SizedBox(height: 14),
            SkeletonBox(width: double.infinity, height: 52, radius: 16),
          ],
        ),
      ),
    );
  }
}

class _DeviceCard extends StatelessWidget {
  final DeviceSession session;
  final bool isDark;
  final IconData deviceIcon;
  final VoidCallback? onRevoke;

  const _DeviceCard({
    required this.session,
    required this.isDark,
    required this.deviceIcon,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        radius: 24,
        borderColor: session.isCurrent
            ? AppColors.primary.withValues(alpha: 0.5)
            : AppColors.primary.withValues(alpha: 0.05),
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
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(deviceIcon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            session.device,
                            style: AppTypography.titleMedium(isDark: isDark),
                          ),
                        ),
                        if (session.isCurrent) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'THIS DEVICE',
                              style: AppTypography.badge(isDark: false)
                                  .copyWith(color: AppColors.success, fontSize: 9),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.os} · ${session.app}',
                      style: AppTypography.small(isDark: isDark),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onRevoke != null)
                IconButton(
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  color: AppColors.destructive,
                  tooltip: 'Sign out',
                  onPressed: onRevoke,
                ),
            ],
          ),
          const SizedBox(height: 12),
          const _GoldDivider(),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.public_rounded, size: 16, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${session.ip} · ${session.location}',
                  style: AppTypography.small(isDark: isDark),
                ),
              ),
              Icon(Icons.schedule_rounded, size: 16, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
              const SizedBox(width: 6),
              Text(session.lastActive, style: AppTypography.small(isDark: isDark)),
            ],
          ),
          ],
        ),
      ),
    );
  }
}

class _GoldDivider extends StatelessWidget {
  const _GoldDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(gradient: AppColors.goldDividerGradient),
    );
  }
}

class _DeviceBannerSkeleton extends StatelessWidget {
  const _DeviceBannerSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: const Row(
        children: [
          SkeletonBox(width: 44, height: 44, radius: 12),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 130),
                SizedBox(height: 6),
                SkeletonLine(width: 180),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceCardSkeleton extends StatelessWidget {
  const _DeviceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SkeletonBox(width: 44, height: 44, radius: 12),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: 120),
                    SizedBox(height: 6),
                    SkeletonLine(width: 150),
                  ],
                ),
              ),
              SizedBox(width: 8),
              SkeletonBox(width: 40, height: 40, radius: 12),
            ],
          ),
          SizedBox(height: 12),
          SkeletonLine(width: double.infinity, height: 1),
          SizedBox(height: 12),
          SkeletonLine(width: 220),
        ],
      ),
    );
  }
}
