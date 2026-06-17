import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/mock_data/fake_notifications.dart';
import '../../../models/notification_item.dart';

class NotificationsNotifier extends StateNotifier<List<NotificationItem>> {
  NotificationsNotifier() : super(fakeNotifications);

  void markAsRead(String id) {
    state = [
      for (final notif in state)
        if (notif.id == id)
          notif.copyWith(isRead: true)
        else
          notif
    ];
  }

  void markAllAsRead() {
    state = [
      for (final notif in state)
        notif.copyWith(isRead: true)
    ];
  }

  void clearAll() {
    state = [];
  }
}

final notificationsProvider = StateNotifierProvider<NotificationsNotifier, List<NotificationItem>>((ref) {
  return NotificationsNotifier();
});
