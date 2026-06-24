import 'package:flutter/material.dart';
import '../../../models/admin_alert.dart';

class AdminAlertCard extends StatelessWidget {
  const AdminAlertCard({
    super.key,
    required this.alert,
    this.onTap,
  });

  final AdminAlert alert;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color accentColor, IconData icon) = switch (alert.severity) {
      AlertSeverity.info => (
          colorScheme.primary,
          Icons.info_outline
        ),
      AlertSeverity.warning => (
          Colors.orange.shade800,
          Icons.warning_amber_rounded
        ),
      AlertSeverity.critical => (
          colorScheme.error,
          Icons.error_outline_rounded
        ),
    };

    Color resolvedBg;
    Color resolvedBorder;

    if (theme.brightness == Brightness.dark) {
      resolvedBg = colorScheme.surfaceContainerLow;
      resolvedBorder = alert.severity == AlertSeverity.critical
          ? colorScheme.error.withOpacity(0.4)
          : colorScheme.outlineVariant;
    } else {
      if (alert.severity == AlertSeverity.critical) {
        resolvedBg = colorScheme.errorContainer.withOpacity(0.08);
        resolvedBorder = colorScheme.error.withOpacity(0.3);
      } else if (alert.severity == AlertSeverity.warning) {
        resolvedBg = Colors.orange.shade50.withOpacity(0.6);
        resolvedBorder = Colors.orange.shade300.withOpacity(0.4);
      } else {
        resolvedBg = colorScheme.surfaceContainerLow;
        resolvedBorder = colorScheme.outlineVariant;
      }
    }

    final timeStr = _formatTimestamp(alert.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: resolvedBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: resolvedBorder,
          width: alert.severity == AlertSeverity.critical ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            alert.severity.label.toUpperCase(),
                            style: textTheme.labelSmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        Text(
                          timeStr,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.description,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
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

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    final difference = now.difference(dt);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
