import 'package:flutter/material.dart';

class DeletePlanDialog extends StatelessWidget {
  final String planName;
  final int subscriberCount;
  final VoidCallback onDelete;
  final VoidCallback onDeactivateInstead;

  const DeletePlanDialog({
    super.key,
    required this.planName,
    required this.subscriberCount,
    required this.onDelete,
    required this.onDeactivateInstead,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final hasSubscribers = subscriberCount > 0;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      icon: Icon(
        hasSubscribers ? Icons.warning_amber_rounded : Icons.delete_outline,
        color: hasSubscribers ? colorScheme.warning : colorScheme.error,
        size: 40,
      ),
      title: Text(
        hasSubscribers ? 'Cannot Delete Plan' : 'Delete Plan',
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Text(
          hasSubscribers
              ? 'Customers are currently subscribed to this plan.\n\nDeactivate the plan instead.'
              : 'Are you sure you want to delete the plan "$planName"? This action is permanent and cannot be undone.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      actions: [
        if (hasSubscribers) ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onDeactivateInstead();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.secondaryContainer,
              foregroundColor: colorScheme.onSecondaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.block, size: 18),
            label: const Text('Deactivate Instead'),
          ),
        ] else ...[
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.onSurfaceVariant,
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 8),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.delete_forever, size: 18),
            label: const Text('Delete'),
          ),
        ],
      ],
    );
  }
}

// Simple color extension or fallback helper to fetch color safe warnings
extension on ColorScheme {
  Color get warning => Colors.orange;
}
