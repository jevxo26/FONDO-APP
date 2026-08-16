import 'meal_plan.dart';

enum SubscriptionStatus { active, paused, cancelled, completed }

class UserSubscription {
  final String id;
  final MealPlan plan;
  final String dietaryPreference;
  final int weeks;
  final double totalPrice;
  final DateTime startDate;
  final DateTime? endDate;
  final SubscriptionStatus status;
  final DateTime? pausedUntil;
  final List<DateTime> pausedDates;
  final int mealsDelivered;
  final int totalMeals;

  const UserSubscription({
    required this.id,
    required this.plan,
    required this.dietaryPreference,
    required this.weeks,
    required this.totalPrice,
    required this.startDate,
    this.endDate,
    required this.status,
    this.pausedUntil,
    this.pausedDates = const [],
    required this.mealsDelivered,
    required this.totalMeals,
  });

  int get remainingMeals => totalMeals - mealsDelivered;

  double get progress => totalMeals > 0 ? mealsDelivered / totalMeals : 0.0;
}
