import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (cart.items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.shopping_bag_outlined,
                size: 64,
                color: AppColors.primary.withValues(alpha: 0.4),
              ),
              const SizedBox(height: 20),
              Text(
                'Your cart is empty',
                style: AppTypography.titleLarge(isDark: isDark),
              ),
              const SizedBox(height: 10),
              Text(
                'Browse the catalog and add items to get started.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium(isDark: isDark),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Cart (${cart.itemCount} items)',
          style: AppTypography.titleLarge(isDark: isDark),
        ),
        const SizedBox(height: 16),
        ...cart.items.map(
          (item) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              title: Text(item.food.name),
              subtitle: Text(
                'x${item.quantity} — ৳${item.totalPrice.toStringAsFixed(0)}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.remove_shopping_cart_outlined, size: 20),
                onPressed: () =>
                    ref.read(cartProvider.notifier).removeItem(item.food.id),
              ),
            ),
          ),
        ),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Total', style: AppTypography.titleMedium(isDark: isDark)),
            Text(
              '৳${cart.total.toStringAsFixed(0)}',
              style: AppTypography.titleMedium(isDark: isDark),
            ),
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
