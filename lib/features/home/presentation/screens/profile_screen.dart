import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_data.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../core/providers/wishlist_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/press_scale.dart';
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
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  void _showInviteFriendsModal() {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.card_giftcard_rounded, color: AppColors.primary, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              'Invite Friends, Get ৳100',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Share your referral code with friends. When they place their first order above ৳300, you both get ৳100 voucher.',
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.mutedLight,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'FONDO-ABIR99',
                    style: AppTypography.titleMedium(isDark: isDark).copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.primary,
                    ),
                  ),
                  FilledButton.tonal(
                    onPressed: () {
                      Clipboard.setData(const ClipboardData(text: 'FONDO-ABIR99'));
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Referral code copied to clipboard!'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    ),
                    child: const Text('Copy'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.primaryForeground,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showVouchersModal() {
    HapticFeedback.lightImpact();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
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
            Text('Available Vouchers & Offers', style: AppTypography.titleLarge(isDark: isDark)),
            const SizedBox(height: 14),
            _VoucherCard(
              code: 'PRO40',
              title: '40% OFF on Top Restaurants',
              subtitle: 'Valid on orders over ৳399. Max discount ৳150.',
              expiry: 'Expires in 3 days',
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _VoucherCard(
              code: 'FREESHIP',
              title: 'Free Delivery on FONDO Mart',
              subtitle: 'Valid on grocery orders over ৳249.',
              expiry: 'Expires in 7 days',
              isDark: isDark,
            ),
            const SizedBox(height: 10),
            _VoucherCard(
              code: 'WELCOME50',
              title: '৳50 Flat Discount',
              subtitle: 'Valid on all food and mart items.',
              expiry: 'Expires in 14 days',
              isDark: isDark,
            ),
          ],
        ),
      ),
    );
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

    return Scaffold(
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // Top Header with User Info & Settings gear
                _ProfileHeader(user: user, tier: tier, isDark: isDark),
                const SizedBox(height: 12),
                _StatsStrip(stats: _stats, isDark: isDark),
                const SizedBox(height: 16),

                // Purple FONDO Pro Card Banner (Foodpanda Reference style)
                _ProBannerCard(
                  isDark: isDark,
                  onTap: () => context.push(AppRoutes.proPerks),
                ),
                const SizedBox(height: 16),

                // 3-Card Grid: Orders, Favourites, Addresses
                _QuickActionGrid(
                  orderCount: _stats.totalOrders,
                  favoriteCount: favoriteCount,
                  addressCount: mockAddresses.length,
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // Wallet & Refund Account Section
                const _SectionLabel('Wallet & Payments'),
                _WalletCard(
                  isDark: isDark,
                  onTap: () => context.push(AppRoutes.wallet),
                ),
                const SizedBox(height: 20),

                // Perks Section
                const _SectionLabel('Perks & Rewards'),
                _SectionGroup(
                  isDark: isDark,
                  children: [
                    _MenuItem(
                      icon: Icons.workspace_premium_rounded,
                      iconColor: const Color(0xFF7B1FA2),
                      title: 'FONDO Pro',
                      subtitle: 'Unlimited free delivery & 20% off',
                      badgeText: 'PRO',
                      badgeColor: const Color(0xFF7B1FA2),
                      isDark: isDark,
                      onTap: () => context.push(AppRoutes.proPerks),
                    ),
                    _MenuItem(
                      icon: Icons.emoji_events_outlined,
                      title: 'Rewards & Tier Benefits',
                      subtitle: '${tier.label} Member — 45,280 pts',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('You are currently a ${tier.label} Tier member with VIP rewards!'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.confirmation_number_outlined,
                      title: 'Vouchers & Offers',
                      subtitle: '3 vouchers available to use',
                      badgeText: '3 Active',
                      badgeColor: AppColors.primary,
                      isDark: isDark,
                      onTap: _showVouchersModal,
                    ),
                    _MenuItem(
                      icon: Icons.card_giftcard_rounded,
                      title: 'Invite Friends',
                      subtitle: 'Get ৳100 voucher for every invite',
                      isDark: isDark,
                      onTap: _showInviteFriendsModal,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Account & General Section
                const _SectionLabel('General & Account'),
                _SectionGroup(
                  isDark: isDark,
                  children: [
                    _MenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Edit Profile',
                      subtitle: 'Name, email, mobile & avatar',
                      isDark: isDark,
                      onTap: () => context.push(AppRoutes.editProfile),
                    ),
                    _MenuItem(
                      icon: Icons.subscriptions_outlined,
                      title: 'Meal Subscriptions',
                      subtitle: 'Manage daily lunch & dinner plans',
                      isDark: isDark,
                      onTap: () => context.push(AppRoutes.subscriptions),
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
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Help Center',
                      subtitle: '24/7 customer support & FAQs',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Help Center: Connect with FONDO live support'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.business_center_outlined,
                      title: 'FONDO for Business',
                      subtitle: 'Corporate meal allowances & billing',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('FONDO for Business: Corporate plans'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.description_outlined,
                      title: 'Terms & Policies',
                      subtitle: 'Privacy policy & terms of service',
                      isDark: isDark,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('FONDO Terms of Service and Privacy Policy'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
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

                // Logout Button
                OutlinedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Log Out'),
                        content: const Text('Are you sure you want to log out of your account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              context.go(AppRoutes.login);
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.destructive,
                            ),
                            child: const Text('Log Out'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 20),
                  label: const Text('Log Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.destructive,
                    side: const BorderSide(color: AppColors.destructive),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                ),
                const SizedBox(height: 16),

                // App Version
                Center(
                  child: Text(
                    'FONDO v1.0.0 (Build 124) • Made with ❤️ in Bangladesh',
                    style: AppTypography.small(isDark: isDark).copyWith(
                      color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                      fontSize: 11,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
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
    final initials = user.name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join();
    return Row(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                spreadRadius: 1,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: Text(
              initials,
              style: AppTypography.titleLarge(isDark: isDark).copyWith(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: AppTypography.titleLarge(isDark: isDark).copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: () => context.push(AppRoutes.editProfile),
                child: Row(
                  children: [
                    Text(
                      'View profile',
                      style: AppTypography.small(isDark: isDark).copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: AppColors.primary),
                  ],
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => context.push(AppRoutes.settings),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
              shape: BoxShape.circle,
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Icon(
              Icons.settings_outlined,
              size: 20,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}

class _ProBannerCard extends StatefulWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _ProBannerCard({required this.isDark, required this.onTap});
  @override
  State<_ProBannerCard> createState() => _ProBannerCardState();
}

class _ProBannerCardState extends State<_ProBannerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmer;
  late final Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: false);
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shimmer, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF5E17EB), Color(0xFF8E24AA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7B1FA2).withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Shimmer golden light sweep overlay
                Positioned.fill(
                  child: AnimatedBuilder(
                    animation: _shimmerAnim,
                    builder: (context, _) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(_shimmerAnim.value - 0.7, -0.6),
                            end: Alignment(_shimmerAnim.value + 0.3, 0.6),
                            colors: [
                              Colors.transparent,
                              const Color(0xFFFFD54F).withValues(alpha: 0.08),
                              const Color(0xFFFFF9C4).withValues(alpha: 0.22),
                              const Color(0xFFFFD54F).withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                            stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Card Content with generous padding
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.workspace_premium_rounded,
                          color: Color(0xFFFFD54F),
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'FONDO Pro',
                              style: TextStyle(
                                color: Color(0xFFFFD54F),
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                                letterSpacing: 0.8,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Save on your future orders with FONDO Pro',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                height: 1.25,
                                shadows: [
                                  Shadow(
                                    color: Colors.black38,
                                    offset: Offset(0, 1),
                                    blurRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFFFFD54F).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text(
                              'Learn more',
                              style: TextStyle(
                                color: Color(0xFFFFD54F),
                                fontWeight: FontWeight.bold,
                                fontSize: 11.5,
                              ),
                            ),
                            SizedBox(width: 2),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFFFFD54F),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QuickActionGrid extends StatelessWidget {
  final int orderCount;
  final int favoriteCount;
  final int addressCount;
  final bool isDark;

  const _QuickActionGrid({
    required this.orderCount,
    required this.favoriteCount,
    required this.addressCount,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionCard(
            icon: Icons.receipt_long_outlined,
            label: 'Orders',
            badge: '$orderCount',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.orderHistory),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.favorite_outline_rounded,
            label: 'Favourites',
            badge: '$favoriteCount',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.favorites),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _QuickActionCard(
            icon: Icons.location_on_outlined,
            label: 'Addresses',
            badge: '$addressCount',
            isDark: isDark,
            onTap: () => context.push(AppRoutes.addressManager),
          ),
        ),
      ],
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String badge;
  final bool isDark;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.badge,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: AppColors.primary, size: 22),
                  ),
                  if (badge != '0')
                    Positioned(
                      top: -4,
                      right: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            color: AppColors.primaryForeground,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: AppTypography.titleMedium(isDark: isDark).copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
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
      child: Text(
        title,
        style: AppTypography.badge(isDark: isDark).copyWith(
          color: isDark ? Colors.white70 : Colors.black87,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: List.generate(children.length * 2 - 1, (index) {
          if (index.isOdd) {
            return Divider(
              height: 1,
              thickness: 1,
              indent: 68,
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

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    this.iconColor,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? AppColors.primary;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: effectiveColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTypography.titleMedium(isDark: isDark).copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppTypography.small(isDark: isDark).copyWith(fontSize: 12)),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.primary).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badgeText!,
                    style: TextStyle(
                      color: badgeColor ?? AppColors.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                size: 20,
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
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
                Text('Dark Mode', style: AppTypography.titleMedium(isDark: isDark).copyWith(fontSize: 14)),
                const SizedBox(height: 2),
                Text('Toggle app visual theme', style: AppTypography.small(isDark: isDark).copyWith(fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primary,
            onChanged: (val) {
              HapticFeedback.lightImpact();
              onChanged(val);
            },
          ),
        ],
      ),
    );
  }
}

class _VoucherCard extends StatelessWidget {
  final String code;
  final String title;
  final String subtitle;
  final String expiry;
  final bool isDark;

  const _VoucherCard({
    required this.code,
    required this.title,
    required this.subtitle,
    required this.expiry,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.mutedLight,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              code,
              style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isDark ? Colors.white : Colors.black87)),
                const SizedBox(height: 2),
                Text(subtitle, style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black54)),
                const SizedBox(height: 2),
                Text(expiry, style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Wallet Card ───────────────────────────────────────────────────────────
class _WalletCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;
  const _WalletCard({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.success.withValues(alpha: 0.25),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: isDark ? 0.08 : 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Wallet icon with green gradient
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF10B981), Color(0xFF059669)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Balance info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Refund Account',
                      style: AppTypography.small(isDark: isDark).copyWith(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.mutedForegroundDark
                            : AppColors.mutedForegroundLight,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '৳0',
                      style: AppTypography.price(isDark: isDark).copyWith(
                        fontSize: 24,
                        color: AppColors.success,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Available Balance',
                      style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Right side: status + chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'No Refunds',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
                    size: 22,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stats Strip ────────────────────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  final CustomerStats stats;
  final bool isDark;
  const _StatsStrip({required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.14)),
      ),
      child: Row(
        children: [
          _StatItem(
            value: '${stats.totalOrders}',
            label: 'Orders',
            isDark: isDark,
          ),
          _VerticalStatDivider(isDark: isDark),
          _StatItem(
            value:
                '৳${(stats.totalSpent / 1000).toStringAsFixed(1)}k',
            label: 'Spent',
            isDark: isDark,
          ),
          _VerticalStatDivider(isDark: isDark),
          _StatItem(
            value: stats.memberSince,
            label: 'Member Since',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;
  const _StatItem({
    required this.value,
    required this.label,
    required this.isDark,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTypography.cardTitle(isDark: isDark).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTypography.small(isDark: isDark).copyWith(fontSize: 10.5),
          ),
        ],
      ),
    );
  }
}

class _VerticalStatDivider extends StatelessWidget {
  final bool isDark;
  const _VerticalStatDivider({required this.isDark});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: AppColors.primary.withValues(alpha: 0.2),
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
          SkeletonBox(width: double.infinity, height: 74, radius: 20),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: SkeletonBox(width: double.infinity, height: 90, radius: 18)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(width: double.infinity, height: 90, radius: 18)),
              SizedBox(width: 10),
              Expanded(child: SkeletonBox(width: double.infinity, height: 90, radius: 18)),
            ],
          ),
          SizedBox(height: 24),
          SkeletonLine(width: 80, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 60, radius: 20),
          SizedBox(height: 20),
          SkeletonLine(width: 120, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 180, radius: 20),
          SizedBox(height: 20),
          SkeletonLine(width: 90, height: 12),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 240, radius: 20),
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
        SkeletonBox(width: 60, height: 60, radius: 30),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonLine(width: 140, height: 20),
              SizedBox(height: 6),
              SkeletonLine(width: 90),
            ],
          ),
        ),
        SkeletonBox(width: 36, height: 36, radius: 18),
      ],
    );
  }
}
