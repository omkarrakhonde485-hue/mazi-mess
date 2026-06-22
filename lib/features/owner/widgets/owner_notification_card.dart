import 'package:flutter/material.dart';

class OwnerNotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final String category; // 'Join Requests', 'Payments', 'Subscriptions', 'Attendance', 'System'
  final String timestamp;
  final bool isRead;
  final VoidCallback? onMarkAsRead;
  final VoidCallback? onViewCustomer;
  final VoidCallback? onViewRequest;

  const OwnerNotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.category,
    required this.timestamp,
    required this.isRead,
    this.onMarkAsRead,
    this.onViewCustomer,
    this.onViewRequest,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Determine category styling
    Color categoryColor;
    Color categoryBg;
    IconData categoryIcon;

    switch (category) {
      case 'Join Requests':
        categoryColor = Colors.blue.shade700;
        categoryBg = Colors.blue.shade50;
        categoryIcon = Icons.person_add_outlined;
        break;
      case 'Payments':
        categoryColor = Colors.green.shade700;
        categoryBg = Colors.green.shade50;
        categoryIcon = Icons.account_balance_wallet_outlined;
        break;
      case 'Subscriptions':
        categoryColor = Colors.teal.shade700;
        categoryBg = Colors.teal.shade50;
        categoryIcon = Icons.card_membership_outlined;
        break;
      case 'Attendance':
        categoryColor = Colors.orange.shade800;
        categoryBg = Colors.orange.shade50;
        categoryIcon = Icons.fact_check_outlined;
        break;
      case 'System':
      default:
        categoryColor = Colors.red.shade700;
        categoryBg = Colors.red.shade50;
        categoryIcon = Icons.error_outline;
        break;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isRead 
              ? colorScheme.outlineVariant.withAlpha(80) 
              : colorScheme.primary.withAlpha(80),
          width: isRead ? 0.8 : 1.2,
        ),
      ),
      color: isRead 
          ? colorScheme.surface 
          : colorScheme.primaryContainer.withAlpha(20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row with category, timestamp, and unread indicator
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: categoryBg,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: categoryColor.withAlpha(50),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(categoryIcon, size: 12, color: categoryColor),
                      const SizedBox(width: 4),
                      Text(
                        category,
                        style: textTheme.labelSmall?.copyWith(
                          color: categoryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  timestamp,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(180),
                    fontSize: 11,
                  ),
                ),
                if (!isRead) ...[
                  const SizedBox(width: 8),
                  Container(
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
            const SizedBox(height: 12),

            // Title and description
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: isRead ? FontWeight.bold : FontWeight.w900,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Divider and Action buttons
            const Divider(height: 1, thickness: 0.5),
            const SizedBox(height: 12),

            // Responsive contextual action buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.end,
              children: [
                if (!isRead && onMarkAsRead != null)
                  OutlinedButton.icon(
                    onPressed: onMarkAsRead,
                    icon: const Icon(Icons.check, size: 14),
                    label: const Text('Mark Read', style: TextStyle(fontSize: 11)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                if (onViewCustomer != null)
                  FilledButton.icon(
                    onPressed: onViewCustomer,
                    icon: const Icon(Icons.person_outline, size: 14),
                    label: const Text('View Customer', style: TextStyle(fontSize: 11)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      backgroundColor: colorScheme.secondaryContainer,
                      foregroundColor: colorScheme.onSecondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                if (onViewRequest != null)
                  FilledButton.icon(
                    onPressed: onViewRequest,
                    icon: const Icon(Icons.arrow_forward, size: 14),
                    label: const Text('View Request', style: TextStyle(fontSize: 11)),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
