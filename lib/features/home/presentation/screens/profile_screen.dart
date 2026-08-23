import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
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
    final favoriteCount = ref.watch(wishlistProvider).count;

    if (_loading) {
      return const _ProfileSkeleton();
    }

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        children: [
          _ProfileHeader(user: user, tier: tier, isDark: isDark),
          const SizedBox(height: 20),
          _StatsRow(stats: _stats, isDark: isDark),
          const SizedBox(height: 24),

          const _SectionLabel('Account'),
          _SectionGroup(
            isDark: isDark,
            children: [
              _MenuItem(
                icon: Icons.person_outline_rounded,
                title: 'Edit Profile',
                subtitle: 'Name, avatar & preferences',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.editProfile),
              ),
              _MenuItem(
                icon: Icons.lock_outline_rounded,
                title: 'Security & Password',
                subtitle: 'Password, biometric & 2FA',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.securitySettings),
              ),
              _MenuItem(
                icon: Icons.devices_other_outlined,
                title: 'Active Devices',
                subtitle: 'Login sessions & device control',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.deviceRegistry),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Favorites & Orders'),
          _SectionGroup(
            isDark: isDark,
            children: [
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Saved Addresses',
                subtitle: '${mockAddresses.length} address${mockAddresses.length == 1 ? '' : 'es'}',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.addressManager),
              ),
              _MenuItem(
                icon: Icons.favorite_outline_rounded,
                title: 'My Favorites',
                subtitle: '$favoriteCount saved meal${favoriteCount == 1 ? '' : 's'}',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.favorites),
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
            ],
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Support'),
          _SectionGroup(
            isDark: isDark,
            children: [
              _MenuItem(
                icon: Icons.notifications_active_outlined,
                title: 'Notifications & Reminders',
                subtitle: 'Alerts, offers & schedules',
                isDark: isDark,
                onTap: () => context.push(AppRoutes.notifications),
              ),
            ],
          ),
          const SizedBox(height: 20),

          const _SectionLabel('Preferences'),
          _SectionGroup(
            isDark: isDark,
            children: [
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
            ],
          ),
          const SizedBox(height: 24),
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

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel(this.title);
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(title, style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
    );
  }
}

class _SectionGroup extends StatelessWidget {
  final bool isDark;
  final List<Widget> children;
  const _SectionGroup({required this.isDark, required this.children});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: 72,
              endIndent: 16,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            );
          }
          return children[index ~/ 2];
        }),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            '${tier.label} Member',
            style: AppTypography.badge(isDark: false).copyWith(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
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
        borderRadius: BorderRadius.circular(24),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          SkeletonLine(width: 80, height: 12),
          SizedBox(height: 8),
          _SectionGroupSkeleton(lines: 3),
          SizedBox(height: 20),
          SkeletonLine(width: 120, height: 12),
          SizedBox(height: 8),
          _SectionGroupSkeleton(lines: 5),
          SizedBox(height: 20),
          SkeletonLine(width: 60, height: 12),
          SizedBox(height: 8),
          _SectionGroupSkeleton(lines: 1),
          SizedBox(height: 20),
          SkeletonLine(width: 90, height: 12),
          SizedBox(height: 8),
          _SectionGroupSkeleton(lines: 2),
          SizedBox(height: 24),
          SkeletonBox(width: double.infinity, height: 48, radius: 12),
        ],
      ),
    );
  }
}

class _SectionGroupSkeleton extends StatelessWidget {
  final int lines;
  const _SectionGroupSkeleton({required this.lines});
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: List.generate(lines * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: 72,
              endIndent: 16,
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            );
          }
          return const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                SkeletonBox(width: 40, height: 40, radius: 10),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLine(width: 120),
                      SizedBox(height: 4),
                      SkeletonLine(width: 160),
                    ],
                  ),
                ),
                SkeletonBox(width: 16, height: 16, radius: 8),
              ],
            ),
          );
        }),
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
        borderRadius: BorderRadius.circular(24),
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
