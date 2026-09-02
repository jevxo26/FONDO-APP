import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_item.dart';

/// Immutable state snapshot of the customer's current cart and bill breakdown.
class CartState {
  /// Itemized lines present in the shopping cart.
  final List<CartItem> items;

  /// Active applied promotional or referral coupon code, if any.
  final String? couponCode;

  /// Applied coupon discount in Bangladeshi Taka (৳).
  final double discount;

  /// Creates a [CartState] instance.
  const CartState({
    this.items = const [],
    this.couponCode,
    this.discount = 0,
  });

  /// Creates a modified copy of this [CartState].
  CartState copyWith({
    List<CartItem>? items,
    String? couponCode,
    double? discount,
  }) {
    return CartState(
      items: items ?? this.items,
      couponCode: couponCode ?? this.couponCode,
      discount: discount ?? this.discount,
    );
  }

  /// Total count of individual food portions across all cart lines.
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Raw subtotal before applying voucher discounts.
  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  /// Final net total after applying discounts.
  double get total {
    final val = subtotal - discount;
    return val < 0 ? 0 : val;
  }
}

/// State notifier managing cart mutations, item additions, quantity updates, and vouchers.
class CartProvider extends StateNotifier<CartState> {
  /// Creates a [CartProvider] with an initial empty [CartState].
  CartProvider() : super(const CartState());

  /// Appends a [FoodItem] or increments existing quantity with selected customizations.
  void addItem(FoodItem food, {int quantity = 1, List<String> addOns = const []}) {
    final index = state.items.indexWhere((item) => item.food.id == food.id);
    if (index >= 0) {
      final updated = [...state.items];
      updated[index] = CartItem(
        food: food,
        quantity: updated[index].quantity + quantity,
        selectedAddOns: addOns,
      );
      state = state.copyWith(items: updated);
    } else {
      state = state.copyWith(
        items: [
          ...state.items,
          CartItem(food: food, quantity: quantity, selectedAddOns: addOns),
        ],
      );
    }
  }

  /// Removes an item line entirely from the cart by its food identifier.
  void removeItem(String foodId) {
    state = state.copyWith(
      items: state.items.where((item) => item.food.id != foodId).toList(),
    );
  }

  /// Updates the quantity for an existing cart item, removing if [quantity] is zero or negative.
  void updateQuantity(String foodId, int quantity) {
    if (quantity <= 0) {
      removeItem(foodId);
      return;
    }
    final index = state.items.indexWhere((item) => item.food.id == foodId);
    if (index < 0) return;
    final updated = [...state.items];
    updated[index] = CartItem(
      food: updated[index].food,
      quantity: quantity,
      selectedAddOns: updated[index].selectedAddOns,
    );
    state = state.copyWith(items: updated);
  }

  /// Applies a promotional coupon code and recalculates discount deduction.
  void applyCoupon(String code) {
    state = state.copyWith(couponCode: code, discount: 50);
  }

  /// Clears any currently applied voucher.
  void removeCoupon() {
    state = state.copyWith(couponCode: null, discount: 0);
  }

  /// Clears all items and resets cart to initial empty state.
  void clear() {
    state = const CartState();
  }
}

/// Central Riverpod provider exposing reactive [CartState].
final cartProvider = StateNotifierProvider<CartProvider, CartState>((ref) {
  return CartProvider();
});
