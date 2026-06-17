import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/notification_item.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final NotificationItem notification;
  final VoidCallback onTap;

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }

  IconData _getCategoryIcon(NotificationCategory category) {
    return switch (category) {
      NotificationCategory.payment => Icons.receipt_long_outlined,
      NotificationCategory.subscription => Icons.subscriptions_outlined,
      NotificationCategory.notice => Icons.campaign_outlined,
      NotificationCategory.system => Icons.settings_outlined,
    };
  }

  Color _getCategoryColor(BuildContext context, NotificationCategory category) {
    final colorScheme = Theme.of(context).colorScheme;
    return switch (category) {
      NotificationCategory.payment => Colors.green,
      NotificationCategory.subscription => colorScheme.primary,
      NotificationCategory.notice => Colors.orange,
      NotificationCategory.system => colorScheme.secondary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final categoryColor = _getCategoryColor(context, notification.category);

    return Card(
      elevation: notification.isRead ? 0 : 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: notification.isRead
              ? colorScheme.outlineVariant.withOpacity(0.4)
              : colorScheme.primary.withOpacity(0.3),
          width: notification.isRead ? 1 : 1.5,
        ),
      ),
      color: notification.isRead
          ? colorScheme.surface
          : colorScheme.primaryContainer.withOpacity(0.05),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Icon Container
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: notification.isRead
                      ? colorScheme.surfaceVariant.withOpacity(0.4)
                      : categoryColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCategoryIcon(notification.category),
                  color: notification.isRead
                      ? colorScheme.onSurfaceVariant.withOpacity(0.8)
                      : categoryColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              // Notification details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Category Label
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: notification.isRead
                                ? colorScheme.surfaceVariant.withOpacity(0.3)
                                : categoryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: notification.isRead
                                  ? colorScheme.outlineVariant.withOpacity(0.5)
                                  : categoryColor.withOpacity(0.2),
                            ),
                          ),
                          child: Text(
                            notification.category.label,
                            style: textTheme.labelSmall?.copyWith(
                              color: notification.isRead
                                  ? colorScheme.onSurfaceVariant
                                  : categoryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // Timestamp
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: textTheme.titleSmall?.copyWith(
                              fontWeight: notification.isRead ? FontWeight.w600 : FontWeight.w800,
                              color: notification.isRead
                                  ? colorScheme.onSurface
                                  : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        // Unread Dot Indicator
                        if (!notification.isRead) ...[
                          const SizedBox(width: 8),
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Message
                    Text(
                      notification.message,
                      style: textTheme.bodyMedium?.copyWith(
                        color: notification.isRead
                            ? colorScheme.onSurfaceVariant
                            : colorScheme.onSurfaceVariant.withOpacity(0.95),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
