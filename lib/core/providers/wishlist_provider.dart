import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/food_item.dart';

class WishlistState {
  final List<FoodItem> items;

  const WishlistState({this.items = const []});

  WishlistState copyWith({List<FoodItem>? items}) {
    return WishlistState(items: items ?? this.items);
  }

  bool isWishlisted(String foodId) =>
      items.any((item) => item.id == foodId);

  int get count => items.length;
}

class WishlistProvider extends StateNotifier<WishlistState> {
  WishlistProvider() : super(const WishlistState());

  void toggle(FoodItem food) {
    if (state.isWishlisted(food.id)) {
      remove(food.id);
    } else {
      add(food);
    }
  }

  void add(FoodItem food) {
    if (state.isWishlisted(food.id)) return;
    state = state.copyWith(items: [...state.items, food]);
  }

  void remove(String foodId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != foodId).toList(),
    );
  }

  void clear() {
    state = const WishlistState();
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistProvider, WishlistState>((ref) {
  return WishlistProvider();
});
