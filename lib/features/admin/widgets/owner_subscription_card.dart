import 'package:flutter/material.dart';
import '../../../models/business_analytics_model.dart';

class OwnerSubscriptionCard extends StatelessWidget {
  const OwnerSubscriptionCard({
    super.key,
    required this.record,
    required this.onViewDetails,
    required this.onRenew,
    required this.onMarkAsRenewed,
    required this.onViewPaymentHistory,
  });

  final OwnerSubscription record;
  final VoidCallback onViewDetails;
  final VoidCallback onRenew;
  final VoidCallback onMarkAsRenewed;
  final VoidCallback onViewPaymentHistory;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Get color based on status
    final (statusColor, statusBg, statusIcon) = switch (record.status) {
      OwnerSubscriptionStatus.active => (
          Colors.green.shade800,
          Colors.green.shade50,
          Icons.check_circle_outline_rounded
        ),
      OwnerSubscriptionStatus.expiringSoon => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.error_outline_rounded
        ),
      OwnerSubscriptionStatus.expired => (
          colorScheme.error,
          colorScheme.errorContainer.withValues(alpha: 0.15),
          Icons.cancel_outlined
        ),
    };

    final daysText = record.status == OwnerSubscriptionStatus.expired
        ? 'Expired'
        : '${record.daysRemaining} days left';

    final daysColor = record.status == OwnerSubscriptionStatus.expired
        ? colorScheme.error
        : record.status == OwnerSubscriptionStatus.expiringSoon
            ? Colors.orange.shade800
            : Colors.green.shade800;

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: record.status == OwnerSubscriptionStatus.expiringSoon
              ? Colors.orange.withValues(alpha: 0.4)
              : record.status == OwnerSubscriptionStatus.expired
                  ? colorScheme.error.withValues(alpha: 0.3)
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Owner Name & Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.ownerName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        record.messName,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 14, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        record.status.label,
                        style: textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Plan Info Grid
            LayoutBuilder(
              builder: (context, constraints) {
                // Determine whether to use a Row or Column for layout based on screen width
                final useTwoColumns = constraints.maxWidth > 300;
                if (useTwoColumns) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoField(
                              context,
                              'Subscription Plan',
                              '${record.planName} (${record.billingCycle.label})',
                              icon: Icons.card_membership_outlined,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoField(
                              context,
                              'Paid On',
                              _formatDate(record.paymentDate),
                              icon: Icons.calendar_today_outlined,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoField(
                              context,
                              'Amount Paid',
                              '₹${record.amountPaid.toStringAsFixed(0)}',
                              icon: Icons.currency_rupee_outlined,
                            ),
                            const SizedBox(height: 12),
                            _buildInfoField(
                              context,
                              'Expiry Date',
                              _formatDate(record.expiryDate),
                              icon: Icons.event_busy_outlined,
                              valueColor: daysColor,
                              customTrailing: Container(
                                margin: const EdgeInsets.only(left: 6),
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: daysColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  daysText,
                                  style: textTheme.bodySmall?.copyWith(
                                    fontSize: 9,
                                    color: daysColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoField(
                        context,
                        'Subscription Plan',
                        '${record.planName} (${record.billingCycle.label})',
                        icon: Icons.card_membership_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoField(
                        context,
                        'Amount Paid',
                        '₹${record.amountPaid.toStringAsFixed(0)}',
                        icon: Icons.currency_rupee_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoField(
                        context,
                        'Paid On',
                        _formatDate(record.paymentDate),
                        icon: Icons.calendar_today_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildInfoField(
                        context,
                        'Expiry Date',
                        _formatDate(record.expiryDate),
                        icon: Icons.event_busy_outlined,
                        valueColor: daysColor,
                        customTrailing: Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: daysColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            daysText,
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: daysColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Action Buttons Row (using Wrap for responsive layout and preventing overflow)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.start,
              children: [
                OutlinedButton.icon(
                  onPressed: onViewDetails,
                  icon: const Icon(Icons.info_outline, size: 14),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    textStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: onViewPaymentHistory,
                  icon: const Icon(Icons.history_rounded, size: 14),
                  label: const Text('Payments'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    visualDensity: VisualDensity.compact,
                    textStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                if (record.status == OwnerSubscriptionStatus.expired)
                  FilledButton.icon(
                    onPressed: onMarkAsRenewed,
                    icon: const Icon(Icons.check_rounded, size: 14),
                    label: const Text('Mark Renewed'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      textStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: onRenew,
                    icon: const Icon(Icons.autorenew_rounded, size: 14),
                    label: const Text('Renew Plan'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      visualDensity: VisualDensity.compact,
                      textStyle: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoField(
    BuildContext context,
    String title,
    String value, {
    IconData? icon,
    Color? valueColor,
    Widget? customTrailing,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, size: 14, color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7)),
          const SizedBox(width: 6),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: valueColor ?? colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (customTrailing != null) customTrailing,
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
