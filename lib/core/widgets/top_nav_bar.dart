import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class TopNavBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onIndexChange;

  const TopNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChange,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select((s) => s.itemCount));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final links = <_NavLink>[
      _NavLink(0, 'Home', Icons.store_outlined),
      _NavLink(1, 'Menu', Icons.menu_book_outlined),
      _NavLink(2, 'Packages', Icons.card_giftcard_outlined),
      _NavLink(3, 'Cart', Icons.shopping_bag_outlined, badge: cartCount),
      _NavLink(4, 'Profile', Icons.person_outline),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            'FONDO',
            style: AppTypography.titleLarge(isDark: isDark).copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: links.map((link) => _NavLinkItem(
                  link: link,
                  isActive: currentIndex == link.index,
                  isDark: isDark,
                  onTap: () => onIndexChange(link.index),
                )).toList(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            onPressed: () => context.go('/login'),
            color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
            tooltip: 'Log out',
          ),
        ],
      ),
    );
  }
}

class _NavLink {
  final int index;
  final String label;
  final IconData icon;
  final int badge;

  const _NavLink(this.index, this.label, this.icon, {this.badge = 0});
}

class _NavLinkItem extends StatelessWidget {
  final _NavLink link;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  const _NavLinkItem({
    required this.link,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          foregroundColor: isActive ? AppColors.primary : null,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: isActive
                ? const BorderSide(color: AppColors.primary, width: 1)
                : BorderSide.none,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(link.icon, size: 18),
            const SizedBox(width: 6),
            Text(
              link.label,
              style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            if (link.badge > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  link.badge > 99 ? '99+' : '${link.badge}',
                  style: const TextStyle(
                    fontSize: 10,
                    color: AppColors.primaryForeground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
