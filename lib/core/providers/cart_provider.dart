import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_item.dart';

class CartState {
  final List<CartItem> items;
  final String? couponCode;
  final double discount;

  const CartState({
    this.items = const [],
    this.couponCode,
    this.discount = 0,
  });

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

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get total {
    final val = subtotal - discount;
    return val < 0 ? 0 : val;
  }
}

class CartProvider extends StateNotifier<CartState> {
  CartProvider() : super(const CartState());

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

  void removeItem(String foodId) {
    state = state.copyWith(
      items: state.items.where((item) => item.food.id != foodId).toList(),
    );
  }

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

  void applyCoupon(String code) {
    state = state.copyWith(couponCode: code, discount: 50);
  }

  void removeCoupon() {
    state = state.copyWith(couponCode: null, discount: 0);
  }

  void clear() {
    state = const CartState();
  }
}

final cartProvider = StateNotifierProvider<CartProvider, CartState>((ref) {
  return CartProvider();
});
