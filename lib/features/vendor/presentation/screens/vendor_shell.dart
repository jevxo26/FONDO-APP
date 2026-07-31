import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/vendor_scaffold_with_bottom_nav.dart';

class VendorShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const VendorShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return VendorScaffoldWithBottomNav(navigationShell: navigationShell);
  }
}
