import 'package:flutter/material.dart';
import '../widgets/vendor_scaffold_with_bottom_nav.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_foods_screen.dart';
import 'vendor_orders_screen.dart';
import 'vendor_profile_screen.dart';

class VendorShell extends StatefulWidget {
  const VendorShell({super.key});

  @override
  State<VendorShell> createState() => _VendorShellState();
}

class _VendorShellState extends State<VendorShell> {
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    VendorDashboardScreen(),
    VendorOrdersScreen(),
    VendorFoodsScreen(),
    VendorProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return VendorScaffoldWithBottomNav(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      body: _screens[_currentIndex],
    );
  }
}
