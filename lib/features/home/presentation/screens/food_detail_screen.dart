import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/food_item.dart';

class FoodDetailScreen extends ConsumerStatefulWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  ConsumerState<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends ConsumerState<FoodDetailScreen> {
  int _quantity = 1;
  final Set<String> _selectedAddOns = {};

  FoodItem? get _food => mockFoods.where((f) => f.id == widget.foodId).firstOrNull;

  double get _addOnTotal => _selectedAddOns.length * 0.50;
  double get _itemTotal => (_food?.price ?? 0) * _quantity + _addOnTotal;

  @override
  Widget build(BuildContext context) {
    final food = _food;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (food == null) {
      return Scaffold(
        appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => context.pop())),
        body: Center(child: Text('Item not found', style: AppTypography.bodyMedium(isDark: isDark))),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(Icons.restaurant, size: 72, color: AppColors.primary.withValues(alpha: 0.3)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(food.name, style: AppTypography.titleLarge(isDark: isDark)),
              ),
              Text('৳${food.price.toStringAsFixed(0)}', style: AppTypography.price(isDark: isDark)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.star_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('${food.rating}', style: AppTypography.bodyMedium(isDark: isDark).copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Text('(${food.ratingCount})', style: AppTypography.small(isDark: isDark)),
            ],
          ),
          const SizedBox(height: 16),
          Text(food.description, style: AppTypography.bodyMedium(isDark: isDark)),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Quantity', style: AppTypography.label(isDark: isDark)),
              const Spacer(),
              _QuantityStepper(
                value: _quantity,
                onDecrement: () {
                  if (_quantity > 1) setState(() => _quantity--);
                },
                onIncrement: () => setState(() => _quantity++),
                isDark: isDark,
              ),
            ],
          ),
          if (food.addOns.isNotEmpty) ...[
            const SizedBox(height: 24),
            Text('Add-ons (৳0.50 each)', style: AppTypography.label(isDark: isDark)),
            const SizedBox(height: 8),
            ...food.addOns.map((addOn) => CheckboxListTile(
              title: Text(addOn, style: AppTypography.bodyMedium(isDark: isDark)),
              value: _selectedAddOns.contains(addOn),
              activeColor: AppColors.primary,
              contentPadding: EdgeInsets.zero,
              dense: true,
              controlAffinity: ListTileControlAffinity.trailing,
              onChanged: (checked) {
                setState(() {
                  if (checked == true) {
                    _selectedAddOns.add(addOn);
                  } else {
                    _selectedAddOns.remove(addOn);
                  }
                });
              },
            )),
          ],
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.primarySurface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _PriceRow(label: 'Price (x$_quantity)', amount: (food.price * _quantity).toStringAsFixed(0), isDark: isDark),
                if (_addOnTotal > 0) ...[
                  const SizedBox(height: 6),
                  _PriceRow(label: 'Add-ons (${_selectedAddOns.length})', amount: _addOnTotal.toStringAsFixed(0), isDark: isDark),
                ],
                const Divider(height: 24),
                _PriceRow(label: 'Total', amount: _itemTotal.toStringAsFixed(0), isDark: isDark, isTotal: true),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {
              ref.read(cartProvider.notifier).addItem(
                food,
                quantity: _quantity,
                addOns: _selectedAddOns.toList(),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${food.name} added to cart'),
                  behavior: SnackBarBehavior.floating,
                  width: 280,
                ),
              );
              context.pop();
            },
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text('Add to Cart — ৳${_itemTotal.toStringAsFixed(0)}'),
            style: FilledButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryForeground,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final bool isDark;

  const _QuantityStepper({
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_rounded, size: 18),
            onPressed: onDecrement,
            color: AppColors.primary,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
          SizedBox(
            width: 32,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: AppTypography.label(isDark: isDark),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, size: 18),
            onPressed: onIncrement,
            color: AppColors.primary,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isDark;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amount,
    required this.isDark,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = isTotal
        ? AppTypography.label(isDark: isDark)
        : AppTypography.bodyMedium(isDark: isDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('৳$amount', style: isTotal ? AppTypography.price(isDark: isDark) : style),
      ],
    );
  }
}
