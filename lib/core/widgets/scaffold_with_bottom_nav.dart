import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      appBar: appBar,
      body: navigationShell,
      bottomNavigationBar: Material(
        color: Colors.transparent,
        elevation: 0,
        child: GlassTabBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (i) => navigationShell.goBranch(
            i,
            initialLocation: i == navigationShell.currentIndex,
          ),
        ),
      ),
    );
  }
}
