class MealPlan {
  final String id;
  final String name;
  final String description;
  final double pricePerMeal;
  final int mealsPerWeek;
  final int minWeeks;
  final List<String> features;
  final List<String> dietaryOptions;

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

  double get weeklyTotal => pricePerMeal * mealsPerWeek;
}
