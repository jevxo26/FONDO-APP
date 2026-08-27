/// Model for MERN Heritage family feasts, combo platters, and event bundles.
class ComboItem {
  final String id;
  final String title;
  final String description;
  final String serves;
  final double price;
  final double originalPrice;
  final double saveAmount;
  final List<String> items;
  final String imageUrl;
  final String? freeDrink;
  final bool isPopular;
  final double rating;
  final int ratingCount;

  const ComboItem({
    required this.id,
    required this.title,
    required this.description,
    required this.serves,
    required this.price,
    required this.originalPrice,
    required this.saveAmount,
    required this.items,
    this.imageUrl = '',
    this.freeDrink,
    this.isPopular = false,
    this.rating = 4.8,
    this.ratingCount = 45,
  });

  ComboItem copyWith({
    String? id,
    String? title,
    String? description,
    String? serves,
    double? price,
    double? originalPrice,
    double? saveAmount,
    List<String>? items,
    String? imageUrl,
    String? freeDrink,
    bool? isPopular,
    double? rating,
    int? ratingCount,
  }) {
    return ComboItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      serves: serves ?? this.serves,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      saveAmount: saveAmount ?? this.saveAmount,
      items: items ?? this.items,
      imageUrl: imageUrl ?? this.imageUrl,
      freeDrink: freeDrink ?? this.freeDrink,
      isPopular: isPopular ?? this.isPopular,
      rating: rating ?? this.rating,
      ratingCount: ratingCount ?? this.ratingCount,
    );
  }
}
