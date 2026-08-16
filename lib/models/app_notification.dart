enum NotificationCategory { order, promotion, reminder, system }

class AppNotification {
  final String id;
  final NotificationCategory category;
  final String title;
  final String message;
  final DateTime time;
  bool read;

  AppNotification({
    required this.id,
    required this.category,
    required this.title,
    required this.message,
    required this.time,
    this.read = false,
  });
}
