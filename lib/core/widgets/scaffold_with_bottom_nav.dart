import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class ScaffoldWithBottomNav extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget? appBar;

  const ScaffoldWithBottomNav({
    super.key,
    required this.navigationShell,
    this.appBar,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartCount = ref.watch(cartProvider.select((s) => s.itemCount));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: appBar,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
          type: BottomNavigationBarType.fixed,
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark
              ? AppColors.mutedForegroundDark
              : AppColors.mutedForegroundLight,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: AppTypography.label(isDark: isDark),
          unselectedLabelStyle: AppTypography.label(isDark: isDark),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard_outlined),
              activeIcon: Icon(Icons.card_giftcard),
              label: 'Packages',
            ),
            BottomNavigationBarItem(
              icon: _CartBadgeIcon(count: cartCount, isDark: isDark),
              activeIcon: _CartBadgeIcon(count: cartCount, isDark: isDark, isActive: true),
              label: 'Cart',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _CartBadgeIcon extends StatelessWidget {
  final int count;
  final bool isDark;
  final bool isActive;

  const _CartBadgeIcon({
    required this.count,
    required this.isDark,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    final icon = Icon(
      isActive ? Icons.shopping_bag : Icons.shopping_bag_outlined,
      color: isActive
          ? AppColors.primary
          : (isDark
              ? AppColors.mutedForegroundDark
              : AppColors.mutedForegroundLight),
    );

    if (count <= 0) return icon;

    return Badge(
      label: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(fontSize: 10, color: AppColors.primaryForeground),
      ),
      backgroundColor: AppColors.primary,
      smallSize: 18,
      child: icon,
    );
  }
}
