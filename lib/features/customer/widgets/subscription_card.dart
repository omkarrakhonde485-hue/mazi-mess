import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../models/subscription_model.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  final Subscription subscription;

  static final _dateFormat = DateFormat('d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isActive = subscription.status.isActive;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subscription.messName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subscription.planName,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: subscription.status),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(
              icon: Icons.calendar_today_outlined,
              label: 'Start date',
              value: _dateFormat.format(subscription.startDate),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.event_outlined,
              label: 'End date',
              value: _dateFormat.format(subscription.endDate),
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.timelapse_outlined,
              label: 'Days remaining',
              value: isActive
                  ? '${subscription.daysRemaining} days'
                  : '—',
              valueStyle: isActive
                  ? textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SubscriptionStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isActive = status.isActive;

    final backgroundColor = isActive
        ? colorScheme.primaryContainer
        : colorScheme.surfaceContainerHighest;
    final foregroundColor = isActive
        ? colorScheme.onPrimaryContainer
        : colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Text(
        status.label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foregroundColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ?? textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
