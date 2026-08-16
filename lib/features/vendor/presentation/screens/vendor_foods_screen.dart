import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class VendorFoodsScreen extends StatefulWidget {
  const VendorFoodsScreen({super.key});

  @override
  State<VendorFoodsScreen> createState() => _VendorFoodsScreenState();
}

class _VendorFoodsScreenState extends State<VendorFoodsScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Foods'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.restaurant_menu_outlined,
              size: 48,
              color: isDark
                  ? AppColors.mutedForegroundDark
                  : AppColors.mutedForegroundLight,
            ),
            const SizedBox(height: 16),
            Text(
              'Your menu will appear here',
              style: AppTypography.titleLarge(isDark: isDark),
            ),
            const SizedBox(height: 8),
            Text(
              'Food management is coming in the next steps',
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }
}
