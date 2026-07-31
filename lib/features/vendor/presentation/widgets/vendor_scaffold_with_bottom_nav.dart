import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class VendorScaffoldWithBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Widget body;

  const VendorScaffoldWithBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: body,
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
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor:
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: isDark
              ? AppColors.mutedForegroundDark
              : AppColors.mutedForegroundLight,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          selectedLabelStyle: AppTypography.label(isDark: isDark),
          unselectedLabelStyle: AppTypography.label(isDark: isDark),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.space_dashboard_outlined),
              activeIcon: Icon(Icons.space_dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_outlined),
              activeIcon: Icon(Icons.restaurant_menu),
              label: 'Foods',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.store_outlined),
              activeIcon: Icon(Icons.store),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
