import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/payment_item.dart';

class PaymentSummaryCard extends StatelessWidget {
  const PaymentSummaryCard({
    super.key,
    required this.payments,
  });

  final List<PaymentItem> payments;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    final successfulPayments = payments
        .where((p) => p.status == PaymentStatus.success)
        .fold(0.0, (sum, p) => sum + p.amount);

    final totalSuccessCount = payments.where((p) => p.status == PaymentStatus.success).length;
    final totalPendingCount = payments.where((p) => p.status == PaymentStatus.pending).length;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withOpacity(0.4),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: colorScheme.primary.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard_customize_outlined, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Overview',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Total Payments',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              currencyFormat.format(successfulPayments),
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 20),
            Divider(color: colorScheme.primary.withOpacity(0.1)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _SummaryStat(
                  label: 'Successful',
                  value: '$totalSuccessCount',
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                ),
                _SummaryStat(
                  label: 'Pending',
                  value: '$totalPendingCount',
                  icon: Icons.pending_actions,
                  iconColor: Colors.orange,
                ),
                _SummaryStat(
                  label: 'Total Trxs',
                  value: '${payments.length}',
                  icon: Icons.receipt_outlined,
                  iconColor: colorScheme.primary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  const _SummaryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

