import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/mock/mock_foods.dart';
import '../../../../core/providers/cart_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/press_scale.dart';
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

  FoodItem? get _food =>
      mockFoods.where((f) => f.id == widget.foodId).firstOrNull;

  double get _addOnTotal => _selectedAddOns.length * 0.50;
  double get _itemTotal => (_food?.price ?? 0) * _quantity + _addOnTotal;

  void _showAddOnsSheet(FoodItem food, bool isDark) {
    final tempAddOns = Set<String>.from(_selectedAddOns);

    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final sheetDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              decoration: BoxDecoration(
                color: sheetDark ? AppColors.surfaceDark : AppColors.cardLight,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12),
                    Container(
                      width: 32,
                      height: 4,
                      decoration: BoxDecoration(
                        color: (sheetDark
                                ? Colors.white
                                : Colors.black)
                            .withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Add-ons (৳0.50 each)',
                      style: AppTypography.titleMedium(isDark: sheetDark),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: food.addOns.map((addOn) {
                          final selected = tempAddOns.contains(addOn);
                          return CheckboxListTile(
                            value: selected,
                            activeColor: AppColors.primary,
                            title: Text(
                              addOn,
                              style:
                                  AppTypography.bodyMedium(isDark: sheetDark),
                            ),
                            contentPadding: EdgeInsets.zero,
                            dense: true,
                            controlAffinity:
                                ListTileControlAffinity.trailing,
                            onChanged: (checked) {
                              setSheetState(() {
                                if (checked == true) {
                                  tempAddOns.add(addOn);
                                } else {
                                  tempAddOns.remove(addOn);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton(
                          onPressed: () {
                            setState(() {
                              _selectedAddOns
                                ..clear()
                                ..addAll(tempAddOns);
                            });
                            Navigator.pop(ctx);
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Done (${tempAddOns.length} selected)',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final food = _food;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (food == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child:
              Text('Item not found', style: AppTypography.bodyMedium(isDark: isDark)),
        ),
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
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
        children: [
          Container(
            height: 240,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant,
                size: 80,
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(food.name,
                    style: AppTypography.titleLarge(isDark: isDark)),
              ),
              Text('৳${food.price.toStringAsFixed(0)}',
                  style: AppTypography.price(isDark: isDark)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 4),
              Text('${food.rating}',
                  style: AppTypography.bodyMedium(isDark: isDark)
                      .copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(width: 4),
              Text('(${food.ratingCount})',
                  style: AppTypography.small(isDark: isDark)),
            ],
          ),
          const SizedBox(height: 16),
          Text(food.description,
              style: AppTypography.bodyMedium(isDark: isDark)),
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
            PressScale(
              child: GestureDetector(
                onTap: () => _showAddOnsSheet(food, isDark),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add_circle_outline_rounded,
                            color: AppColors.primary, size: 22),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Add-ons',
                                style:
                                    AppTypography.label(isDark: isDark)),
                            if (_selectedAddOns.isEmpty)
                              Text(
                                '${food.addOns.length} options available',
                                style:
                                    AppTypography.small(isDark: isDark),
                              )
                            else
                              Text(
                                '${_selectedAddOns.length} selected — ৳${_addOnTotal.toStringAsFixed(0)}',
                                style: AppTypography.small(isDark: isDark)
                                    .copyWith(color: AppColors.primary),
                              ),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded,
                          color: isDark
                              ? AppColors.mutedForegroundDark
                              : AppColors.mutedForegroundLight),
                    ],
                  ),
                ),
              ),
            ),
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
                _PriceRow(
                    label: 'Price (x$_quantity)',
                    amount: (food.price * _quantity).toStringAsFixed(0),
                    isDark: isDark),
                if (_addOnTotal > 0) ...[
                  const SizedBox(height: 6),
                  _PriceRow(
                      label: 'Add-ons (${_selectedAddOns.length})',
                      amount: _addOnTotal.toStringAsFixed(0),
                      isDark: isDark),
                ],
                const Divider(height: 24),
                _PriceRow(
                    label: 'Total',
                    amount: _itemTotal.toStringAsFixed(0),
                    isDark: isDark,
                    isTotal: true),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white)
                  .withValues(alpha: 0.7),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: FilledButton.icon(
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
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
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
        border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight),
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
    final style =
        isTotal ? AppTypography.label(isDark: isDark) : AppTypography.bodyMedium(isDark: isDark);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text('৳$amount',
            style: isTotal ? AppTypography.price(isDark: isDark) : style),
      ],
    );
  }
}
