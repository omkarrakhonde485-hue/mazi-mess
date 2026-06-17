import '../../models/notification_item.dart';

final List<NotificationItem> fakeNotifications = [
  NotificationItem(
    id: 'notif_001',
    title: 'Payment Successful',
    message: 'Your payment of ₹1,800 for Annapurna Mess June subscription has been processed successfully.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    category: NotificationCategory.payment,
    isRead: false,
  ),
  NotificationItem(
    id: 'notif_002',
    title: 'New Subscription Active',
    message: 'Your monthly subscription to Premium Veg Plan at Royal Mess is now active. Enjoy your meals!',
    timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    category: NotificationCategory.subscription,
    isRead: false,
  ),
  NotificationItem(
    id: 'notif_003',
    title: 'Mess Closed on Sunday',
    message: 'Notice: Royal Mess will remain closed this Sunday (June 14) for deep cleaning and kitchen renovation.',
    timestamp: DateTime.now().subtract(const Duration(days: 1)),
    category: NotificationCategory.notice,
    isRead: true,
  ),
  NotificationItem(
    id: 'notif_004',
    title: 'System Update Completed',
    message: 'We have updated our QR scanner service to be faster. Please make sure to update your app if you face issues.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    category: NotificationCategory.system,
    isRead: true,
  ),
  NotificationItem(
    id: 'notif_005',
    title: 'Payment Reminder',
    message: 'Your pending payment for Mother\'s Kitchen is due by June 15 to avoid subscription suspension.',
    timestamp: DateTime.now().subtract(const Duration(days: 3)),
    category: NotificationCategory.payment,
    isRead: true,
  ),
  NotificationItem(
    id: 'notif_006',
    title: 'Leave Approved',
    message: 'Your leave request for June 18 - June 20 has been approved. The respective days will be credited to your wallet.',
    timestamp: DateTime.now().subtract(const Duration(days: 4)),
    category: NotificationCategory.subscription,
    isRead: true,
  ),
];
