/// Categorization of in-app and push notification events.
enum NotificationCategory {
  /// Real-time order dispatch, kitchen status, and delivery milestones.
  order,

  /// Promotional vouchers, seasonal offers, and flash discounts.
  promotion,

  /// Subscription renewal, scheduled meal reminders, and cart abandoned prompts.
  reminder,

  /// Account security alerts, app updates, and platform system announcements.
  system,
}

/// In-app notification payload rendered in customer alert drawers and banners.
class AppNotification {
  /// Unique identifier of the notification event.
  final String id;

  /// Operational category determining icon and routing behavior.
  final NotificationCategory category;

  /// Headline title for customer display.
  final String title;

  /// Detailed contextual message body.
  final String message;

  /// Timestamp when the notification was generated.
  final DateTime time;

  /// Whether the customer has viewed or acknowledged this notification.
  bool read;

  /// Creates an [AppNotification] instance.
  AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.time,
    this.read = false,
  });
}
