import 'package:flutter/material.dart';
import '../../../models/payment_monitoring_model.dart';

class PaymentRecordCard extends StatelessWidget {
  final PaymentVerificationRecord record;
  final VoidCallback onViewDetails;
  final VoidCallback onRetryVerification;
  final VoidCallback onMarkAsVerified;
  final VoidCallback onMarkAsFailed;

  const PaymentRecordCard({
    super.key,
    required this.record,
    required this.onViewDetails,
    required this.onRetryVerification,
    required this.onMarkAsVerified,
    required this.onMarkAsFailed,
  });

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    return '${dt.day} ${months[dt.month - 1]} ${dt.year} • $hour:$minute $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color statusColor, Color statusBg, IconData statusIcon) =
        switch (record.status) {
      PaymentVerificationStatus.pending => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.pending_actions_outlined
        ),
      PaymentVerificationStatus.verified => (
          Colors.green.shade800,
          Colors.green.shade50,
          Icons.verified_outlined
        ),
      PaymentVerificationStatus.failed => (
          colorScheme.error,
          colorScheme.errorContainer.withValues(alpha: 0.2),
          Icons.gpp_bad_outlined
        ),
      PaymentVerificationStatus.manualOverride => (
          Colors.blue.shade800,
          Colors.blue.shade50,
          Icons.admin_panel_settings_outlined
        ),
      PaymentVerificationStatus.retryRequired => (
          Colors.purple.shade800,
          Colors.purple.shade50,
          Icons.refresh_outlined
        ),
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: record.status == PaymentVerificationStatus.failed
              ? colorScheme.error.withValues(alpha: 0.3)
              : record.status == PaymentVerificationStatus.pending
                  ? Colors.orange.withValues(alpha: 0.3)
                  : colorScheme.outlineVariant.withValues(alpha: 0.6),
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row: Status Badge and Time
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, color: statusColor, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        record.status.label.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  _formatDateTime(record.paymentTime),
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Customer Name & Mobile
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.4),
                  child: Text(
                    record.customerName.isNotEmpty ? record.customerName[0].toUpperCase() : 'C',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.customerName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Mobile: ${record.customerMobile}',
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                // Amount styling
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${record.amount.toStringAsFixed(2)}',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                        color: record.status == PaymentVerificationStatus.verified
                            ? Colors.green.shade800
                            : colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Ref: ${record.transactionRef}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                        fontFamily: 'Courier',
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Metadata: Mess, Verification Source, Failure Reason
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;
                return Column(
                  children: [
                    if (isWide) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'Mess Outlet',
                              record.messName,
                              icon: Icons.restaurant_outlined,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'Verification Source',
                              record.verificationSource,
                              icon: Icons.api_outlined,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildMetaItem(
                        context,
                        'Mess Outlet',
                        record.messName,
                        icon: Icons.restaurant_outlined,
                      ),
                      const SizedBox(height: 8),
                      _buildMetaItem(
                        context,
                        'Verification Source',
                        record.verificationSource,
                        icon: Icons.api_outlined,
                      ),
                    ],

                    // Show failure reason if verification failed
                    if (record.status == PaymentVerificationStatus.failed && record.failureReason != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: colorScheme.error.withValues(alpha: 0.2),
                            width: 1.0,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_outlined, color: colorScheme.error, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
                                  children: [
                                    const TextSpan(
                                      text: 'Failure Reason: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: record.failureReason!.label),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Actions Row
            // Important: Let's wrap action buttons properly to avoid layout constraint overflows
            // Let's use a Wrap instead of a Row for ultra-safety, or an elegant responsive row!
            LayoutBuilder(
              builder: (context, constraints) {
                // If width is tiny, render vertical stack of buttons, or a compact row of icons + text.
                // Wrap is the most robust way to ensure we never overflow.
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: onViewDetails,
                      icon: const Icon(Icons.info_outline, size: 14),
                      label: const Text('Details'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onRetryVerification,
                      icon: const Icon(Icons.refresh, size: 14),
                      label: const Text('Retry'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        minimumSize: const Size(0, 32),
                      ),
                    ),
                    if (record.status != PaymentVerificationStatus.verified &&
                        record.status != PaymentVerificationStatus.manualOverride)
                      FilledButton.icon(
                        onPressed: onMarkAsVerified,
                        icon: const Icon(Icons.check, size: 14),
                        label: const Text('Verify'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                    if (record.status != PaymentVerificationStatus.failed)
                      FilledButton.icon(
                        onPressed: onMarkAsFailed,
                        icon: const Icon(Icons.close, size: 14),
                        label: const Text('Fail'),
                        style: FilledButton.styleFrom(
                          backgroundColor: colorScheme.error,
                          foregroundColor: colorScheme.onError,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: const Size(0, 32),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(BuildContext context, String title, String value, {IconData? icon}) {
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
              Text(
                value,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
