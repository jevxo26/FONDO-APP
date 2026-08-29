import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_colors.dart';
import 'glass_tab_bar.dart';

class ScaffoldWithBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final PreferredSizeWidget? appBar;

  const ScaffoldWithBottomNav({
    super.key,
    required this.navigationShell,
    this.appBar,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: appBar,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Full-screen content flowing unobstructed behind floating navbar
          navigationShell,
          // Truly floating glass tab bar overlaid on top with zero opaque barriers
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: GlassTabBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (i) => navigationShell.goBranch(
                i,
                initialLocation: i == navigationShell.currentIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

