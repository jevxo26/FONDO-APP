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
  final String prepTime;
  final List<String> ingredients;
  final List<String> dietaryTags;
  final bool isSignature;
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
