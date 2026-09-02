/// Curated family feasts, multi-person combo platters, and event bundles.
class ComboItem {
  /// Unique identifier of the combo package.
  final String id;

  /// Headline title of the combo platter.
  final String title;

  /// Narrative description outlining dishes, heritage origin, and packaging.
  final String description;

  /// Recommended serving capacity (e.g. "Serves 3-4", "Family Pack (5-6)").
  final String serves;

  /// Discounted bundle price in Bangladeshi Taka (৳).
  final double price;

  /// Regular individual sum price before package discount.
  final double originalPrice;

  /// Calculated savings amount in Bangladeshi Taka (৳).
  final double saveAmount;

  /// Itemized inventory of dishes included in this platter.
  final List<String> items;

  /// Image asset or remote photo URL.
  final String imageUrl;

  /// Complimentary beverage or dessert inclusion (e.g. "Borhani 1L", "Jorda").
  final String? freeDrink;

  /// Whether this platter is highlighted as a trending best-seller.
  final bool isPopular;

  /// Aggregate customer satisfaction rating (out of 5.0).
  final double rating;

  /// Count of customer reviews submitted.
  final int ratingCount;

  /// Creates a [ComboItem] instance.
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

  /// Creates a modified clone of this [ComboItem].
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
