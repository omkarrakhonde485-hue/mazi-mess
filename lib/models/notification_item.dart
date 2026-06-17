enum NotificationCategory {
  payment,
  subscription,
  notice,
  system;

  String get label => switch (this) {
        NotificationCategory.payment => 'Payment',
        NotificationCategory.subscription => 'Subscription',
        NotificationCategory.notice => 'Notice',
        NotificationCategory.system => 'System',
      };
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationCategory category;
  final bool isRead;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.category,
    this.isRead = false,
  });

  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    DateTime? timestamp,
    NotificationCategory? category,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      category: category ?? this.category,
      isRead: isRead ?? this.isRead,
    );
  }
}
