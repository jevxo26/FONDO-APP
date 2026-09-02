/// Represents a recurring subscription meal plan offering curated dishes.
class MealPlan {
  /// Unique identifier for the meal plan.
  final String id;

  /// Display name of the plan (e.g., "Heritage Daily", "Fitness Pro").
  final String name;

  /// Detailed summary of the plan's culinary focus and portion standards.
  final String description;

  /// Cost per individual meal in Bangladeshi Taka (৳).
  final double pricePerMeal;

  /// Number of meals delivered per week under this plan.
  final int mealsPerWeek;

  /// Minimum subscription duration in weeks.
  final int minWeeks;

  /// Key highlights and included perks for this plan.
  final List<String> features;

  /// Supported dietary customizations (e.g., Halal, Low-Carb, High-Protein).
  final List<String> dietaryOptions;

  /// Creates a [MealPlan] instance.
  const MealPlan({
    required this.id,
    required this.name,
    required this.description,
    required this.pricePerMeal,
    required this.mealsPerWeek,
    required this.minWeeks,
    required this.features,
    this.dietaryOptions = const [],
  });

  /// Computed total cost for one week of deliveries under this plan.
  double get weeklyTotal => pricePerMeal * mealsPerWeek;
}
