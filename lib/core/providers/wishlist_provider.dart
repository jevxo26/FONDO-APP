import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../mock/mock_foods.dart';
import '../../models/food_item.dart';

/// State representation of the customer's bookmarked favorite dishes.
class WishlistState {
  /// Curated list of customer-favorited [FoodItem] entities.
  final List<FoodItem> items;

  /// Creates a [WishlistState] instance.
  const WishlistState({this.items = const []});

  /// Creates a modified copy of this [WishlistState].
  WishlistState copyWith({List<FoodItem>? items}) {
    return WishlistState(items: items ?? this.items);
  }

  /// Checks whether a food dish is currently bookmarked.
  bool isWishlisted(String foodId) =>
      items.any((item) => item.id == foodId);

  /// Total count of bookmarked favorite items.
  int get count => items.length;
}

/// State notifier managing bookmark toggling, additions, and removals.
class WishlistProvider extends StateNotifier<WishlistState> {
  /// Creates a [WishlistProvider] seeded with representative dishes.
  WishlistProvider()
      : super(WishlistState(items: mockFoods.where((f) => f.id != 'f_002' && f.id != 'f_010').take(6).toList()));

  /// Toggles bookmark state for the specified [FoodItem].
  void toggle(FoodItem food) {
    if (state.isWishlisted(food.id)) {
      remove(food.id);
    } else {
      add(food);
    }
  }

  /// Adds a dish to the favorites list if not already present.
  void add(FoodItem food) {
    if (state.isWishlisted(food.id)) return;
    state = state.copyWith(items: [...state.items, food]);
  }

  /// Removes a dish from the favorites list by its food identifier.
  void remove(String foodId) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != foodId).toList(),
    );
  }

  /// Clears all items from the favorites collection.
  void clear() {
    state = const WishlistState();
  }
}

/// Central Riverpod provider exposing reactive [WishlistState].
final wishlistProvider =
    StateNotifierProvider<WishlistProvider, WishlistState>((ref) {
  return WishlistProvider();
});
