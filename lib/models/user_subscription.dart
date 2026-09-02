import 'meal_plan.dart';

/// Operational status of a customer meal subscription.
enum SubscriptionStatus {
  /// Deliveries are ongoing according to the weekly schedule.
  active,

  /// Temporarily on hold until a specified date.
  paused,

  /// Terminated prior to completion of term.
  cancelled,

  /// All scheduled meals have been successfully fulfilled.
  completed,
}

/// Tracks an active or historical recurring meal subscription for a customer.
class UserSubscription {
  /// Unique subscription contract identifier.
  final String id;

  /// Underlying meal plan package.
  final MealPlan plan;

  /// Selected culinary dietary style (e.g. "Low Carb", "Heritage Traditional").
  final String dietaryPreference;

  /// Duration of subscription commitment in weeks.
  final int weeks;

  /// Billed total cost in Bangladeshi Taka (৳).
  final double totalPrice;

  /// Start date when initial delivery commences.
  final DateTime startDate;

  /// Projected conclusion date for subscription deliveries.
  final DateTime? endDate;

  /// Current fulfillment state.
  final SubscriptionStatus status;

  /// Scheduled resumption date if subscription is paused.
  final DateTime? pausedUntil;

  /// Calendar dates when delivery skips have been registered.
  final List<DateTime> pausedDates;

  /// Total count of meals successfully delivered so far.
  final int mealsDelivered;

  /// Contracted total count of meals across the subscription duration.
  final int totalMeals;

  /// Creates a [UserSubscription] instance.
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

  /// Remaining number of meals yet to be fulfilled.
  int get remainingMeals => totalMeals - mealsDelivered;

  /// Percentage progress toward full term delivery completion (0.0 to 1.0).
  double get progress => totalMeals > 0 ? mealsDelivered / totalMeals : 0.0;
}
