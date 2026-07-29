import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/widgets/scaffold_with_bottom_nav.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import 'home_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pages = <Widget>[
      const HomeScreen(),
      _buildPlaceholder(
        isDark: isDark,
        icon: Icons.menu_book_outlined,
        title: 'Full Menu',
        subtitle: 'Browse all available dishes, filter by category and explore add-ons.',
      ),
      _buildPlaceholder(
        isDark: isDark,
        icon: Icons.card_giftcard_outlined,
        title: 'Meal Packages',
        subtitle: 'Subscribe to weekly or monthly meal plans coming soon.',
      ),
      _buildCartTab(isDark: isDark),
      _buildPlaceholder(
        isDark: isDark,
        icon: Icons.person_outline,
        title: 'Your Profile',
        subtitle: 'Manage your account, addresses and preferences.',
      ),
    ];

    return ScaffoldWithBottomNav(
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
            icon: Icon(Icons.logout_rounded, color: isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      currentIndex: _currentIndex,
      onIndexChange: (i) => setState(() => _currentIndex = i),
    );
  }

  Widget _buildPlaceholder({
    required bool isDark,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: AppColors.primary.withValues(alpha: 0.4)),
            const SizedBox(height: 20),
            Text(title, style: AppTypography.titleLarge(isDark: isDark)),
            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMedium(isDark: isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTab({required bool isDark}) {
    final cart = ref.watch(cartProvider);

    if (cart.items.isEmpty) {
      return _buildPlaceholder(
        isDark: isDark,
        icon: Icons.shopping_bag_outlined,
        title: 'Your cart is empty',
        subtitle: 'Browse the catalog and add items to get started.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Cart (${cart.itemCount} items)', style: AppTypography.titleLarge(isDark: isDark)),
        const SizedBox(height: 16),
        ...cart.items.map((item) => Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            title: Text(item.food.name),
            subtitle: Text('x${item.quantity} — ৳${item.totalPrice.toStringAsFixed(0)}'),
            trailing: IconButton(
              icon: const Icon(Icons.remove_shopping_cart_outlined, size: 20),
              onPressed: () => ref.read(cartProvider.notifier).removeItem(item.food.id),
            ),
          ),
        )),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: AppTypography.titleMedium(isDark: isDark)),
            Text('৳${cart.total.toStringAsFixed(0)}', style: AppTypography.titleMedium(isDark: isDark)),
          ],
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => ref.read(cartProvider.notifier).clear(),
          icon: const Icon(Icons.delete_outline),
          label: const Text('Clear cart'),
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.destructive,
            foregroundColor: AppColors.primaryForeground,
          ),
        ),
      ],
    );
  }
}
