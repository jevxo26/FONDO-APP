class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final double rating;
  final int ratingCount;
  final bool isAvailable;
  final List<String> addOns;

  const FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl = '',
    required this.category,
    this.rating = 0,
    this.ratingCount = 0,
    this.isAvailable = true,
    this.addOns = const [],
  });
}

class CartItem {
  final FoodItem food;
  int quantity;
  final List<String> selectedAddOns;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.selectedAddOns = const [],
  });

  double get totalPrice {
    final addOnPrice = selectedAddOns.length * 0.50;
    return (food.price + addOnPrice) * quantity;
  }
}
