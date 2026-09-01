/// Core model representing a dish, grocery item, or menu offering in FONDO.
class FoodItem {
  /// Unique identifier for the food item.
  final String id;

  /// Display title of the dish.
  final String name;

  /// Detailed description and heritage story note.
  final String description;

  /// Base price in Bangladeshi Taka (৳).
  final double price;

  /// Image asset or network URL path.
  final String imageUrl;

  /// Primary category (e.g. Kacchi, Tehari, Kebab, Groceries).
  final String category;

  /// User rating out of 5.0.
  final double rating;

  /// Total customer review count.
  final int ratingCount;

  /// Availability status in active inventory.
  final bool isAvailable;

  /// Optional customizable add-ons with dynamic pricing.
  final List<String> addOns;

  /// Estimated kitchen preparation time.
  final String prepTime;

  /// Key ingredients list.
  final List<String> ingredients;

  /// Dietary and heritage badges (e.g. 100% Halal, Coal Slow Oven).
  final List<String> dietaryTags;

  /// Whether dish is featured as today's signature plate.
  final bool isSignature;

  /// Whether dish is highlighted as a popular best-seller.
  final bool isPopular;

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
    this.prepTime = '20-30 min',
    this.ingredients = const [],
    this.dietaryTags = const ['100% Halal'],
    this.isSignature = false,
    this.isPopular = false,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    double? rating,
    int? ratingCount,
    bool? isAvailable,
    List<String>? addOns,
    String? prepTime,
    List<String>? ingredients,
    List<String>? dietaryTags,
    bool? isSignature,
    bool? isPopular,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
      isAvailable: isAvailable ?? this.isAvailable,
      addOns: addOns ?? this.addOns,
      prepTime: prepTime ?? this.prepTime,
      ingredients: ingredients ?? this.ingredients,
      dietaryTags: dietaryTags ?? this.dietaryTags,
      isSignature: isSignature ?? this.isSignature,
      isPopular: isPopular ?? this.isPopular,
    );
  }
}

/// Model representing an item placed in the customer's active shopping cart.
class CartItem {
  /// Selected food item.
  final FoodItem food;

  /// Quantity ordered.
  int quantity;

  /// List of custom add-on names chosen.
  final List<String> selectedAddOns;

  CartItem({
    required this.food,
    this.quantity = 1,
    this.selectedAddOns = const [],
  });

  /// Computed total price including add-ons multiplied by quantity.
  double get totalPrice {
    final addOnPrice = selectedAddOns.length * 0.50;
    return (food.price + addOnPrice) * quantity;
  }
}
