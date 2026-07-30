import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/scaffold_with_bottom_nav.dart';
import '../../../../core/theme/app_colors.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaffoldWithBottomNav(
      navigationShell: navigationShell,
      appBar: AppBar(
        title: Text(
          'FONDO',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight,
            ),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
    );
  }
}
