import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../features/auth/presentation/controllers/auth_controller.dart';
import '../../../../models/customer_tier.dart';
import '../../../../models/user_model.dart';
import '../../../../router/routes.dart';

const _stats = CustomerStats(totalOrders: 127, totalSpent: 45280, memberSince: 'Jan 2024');

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tier = _stats.tier;
    final themeMode = ref.watch(themeModeProvider);

    if (_loading) {
      return const _ProfileSkeleton();
    }

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _ProfileHeader(user: user, tier: tier, isDark: isDark),
          const SizedBox(height: 20),
          _StatsRow(stats: _stats, isDark: isDark),
          const SizedBox(height: 24),
          _MenuItem(
            icon: Icons.location_on_outlined,
            title: 'Saved Addresses',
            subtitle: '${mockAddresses.length} address${mockAddresses.length == 1 ? '' : 'es'}',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.addressManager),
          ),
          _MenuItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Wallet',
            subtitle: 'Balance & transaction history',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.wallet),
          ),
          _MenuItem(
            icon: Icons.subscriptions_outlined,
            title: 'Subscriptions',
            subtitle: 'Active meal plans',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.subscriptions),
          ),
          _MenuItem(
            icon: Icons.receipt_long_outlined,
            title: 'Order History',
            subtitle: 'Past orders & receipts',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.orderHistory),
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            subtitle: 'Account & preferences',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.settings),
          ),
          _ThemeToggleRow(
            isDark: isDark,
            value: themeMode == ThemeMode.dark,
            onChanged: (value) => ref.read(themeModeProvider.notifier).state =
                value ? ThemeMode.dark : ThemeMode.light,
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () => context.go('/login'),
            icon: const Icon(Icons.logout_rounded, size: 20),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.destructive,
              side: const BorderSide(color: AppColors.destructive),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeToggleRow extends StatelessWidget {
  final bool isDark;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ThemeToggleRow({
    required this.isDark,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.dark_mode_outlined, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dark Mode', style: AppTypography.titleMedium(isDark: isDark)),
                const SizedBox(height: 2),
                Text('Toggle between light and dark theme', style: AppTypography.small(isDark: isDark)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final UserModel user;
  final CustomerTier tier;
  final bool isDark;

  const _ProfileHeader({
    required this.user,
    required this.tier,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final initials = user.name.split(' ').map((e) => e[0]).take(2).join();
    return Row(
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: Text(
            initials,
            style: AppTypography.titleLarge(isDark: isDark).copyWith(
              color: AppColors.primary,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.name, style: AppTypography.titleLarge(isDark: isDark)),
              const SizedBox(height: 2),
              Text(user.email, style: AppTypography.small(isDark: isDark)),
              const SizedBox(height: 6),
              _TierBadge(tier: tier),
            ],
          ),
        ),
      ],
    );
  }
}

class _TierBadge extends StatelessWidget {
  final CustomerTier tier;

  const _TierBadge({required this.tier});

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;
    switch (tier) {
      case CustomerTier.bronze:
        color = const Color(0xFFCD7F32);
        icon = Icons.emoji_events_outlined;
      case CustomerTier.silver:
        color = const Color(0xFFC0C0C0);
        icon = Icons.emoji_events_outlined;
      case CustomerTier.gold:
        color = AppColors.primary;
        icon = Icons.emoji_events_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${tier.label} Member',
            style: AppTypography.badge(isDark: false).copyWith(
              color: color,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final CustomerStats stats;
  final bool isDark;

  const _StatsRow({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(child: _StatItem(label: 'Orders', value: '${stats.totalOrders}', isDark: isDark)),
          _StatDivider(isDark: isDark),
          Expanded(child: _StatItem(label: 'Spent', value: '৳${stats.totalSpent.toStringAsFixed(0)}', isDark: isDark)),
          _StatDivider(isDark: isDark),
          Expanded(child: _StatItem(label: 'Member', value: stats.memberSince, isDark: isDark)),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _StatItem({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppTypography.statValue(isDark: isDark).copyWith(fontSize: 20)),
        const SizedBox(height: 4),
        Text(label, style: AppTypography.small(isDark: isDark)),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  final bool isDark;
  const _StatDivider({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.cardLight,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.titleMedium(isDark: isDark)),
                      const SizedBox(height: 2),
                      Text(subtitle, style: AppTypography.small(isDark: isDark)),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _ProfileHeaderSkeleton(),
          SizedBox(height: 20),
          _StatsRowSkeleton(),
          SizedBox(height: 24),
          _MenuItemSkeleton(),
          _MenuItemSkeleton(),
          _MenuItemSkeleton(),
          _MenuItemSkeleton(),
          _ThemeToggleSkeleton(),
          SizedBox(height: 16),
          _LogoutSkeleton(),
        ],
      ),
    );
  }
}

class _ProfileHeaderSkeleton extends StatelessWidget {
  const _ProfileHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        SkeletonBox(width: 64, height: 64, radius: 32),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 140, height: 20),
              SizedBox(height: 6),
              SkeletonLine(width: 180),
              SizedBox(height: 8),
              SkeletonLine(width: 110, height: 18),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatsRowSkeleton extends StatelessWidget {
  const _StatsRowSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Row(
        children: [
          Expanded(child: _StatSkeleton()),
          SkeletonBox(width: 1, height: 36, radius: 0),
          Expanded(child: _StatSkeleton()),
          SkeletonBox(width: 1, height: 36, radius: 0),
          Expanded(child: _StatSkeleton()),
        ],
      ),
    );
  }
}

class _StatSkeleton extends StatelessWidget {
  const _StatSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SkeletonLine(width: 56, height: 18),
        SizedBox(height: 6),
        SkeletonLine(width: 36),
      ],
    );
  }
}

class _MenuItemSkeleton extends StatelessWidget {
  const _MenuItemSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : AppColors.cardLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            return Row(
              children: [
                const SkeletonBox(width: 40, height: 40, radius: 10),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: w * 0.4),
                      const SizedBox(height: 4),
                      SkeletonLine(width: w * 0.55),
                    ],
                  ),
                ),
                const SkeletonBox(width: 16, height: 16, radius: 8),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ThemeToggleSkeleton extends StatelessWidget {
  const _ThemeToggleSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: const Row(
        children: [
          SkeletonBox(width: 40, height: 40, radius: 10),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLine(width: 100),
                SizedBox(height: 4),
                SkeletonLine(width: 160),
              ],
            ),
          ),
          SkeletonBox(width: 40, height: 24, radius: 12),
        ],
      ),
    );
  }
}

class _LogoutSkeleton extends StatelessWidget {
  const _LogoutSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SkeletonBox(width: double.infinity, height: 48, radius: 12);
  }
}
