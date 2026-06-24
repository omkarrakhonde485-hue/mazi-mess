import 'package:flutter/material.dart';
import '../../../models/mess_approval_model.dart';

class MessApprovalCard extends StatelessWidget {
  const MessApprovalCard({
    super.key,
    required this.mess,
    required this.onApprove,
    required this.onReject,
    required this.onSuspend,
    required this.onReactivate,
    required this.onViewDocuments,
  });

  final MessApproval mess;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onSuspend;
  final VoidCallback onReactivate;
  final VoidCallback onViewDocuments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color statusColor, Color statusBg, IconData statusIcon) =
        switch (mess.status) {
      MessApprovalStatus.pending => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.hourglass_empty_rounded
        ),
      MessApprovalStatus.approved => (
          Colors.green.shade800,
          Colors.green.shade50,
          Icons.verified_outlined
        ),
      MessApprovalStatus.rejected => (
          colorScheme.error,
          colorScheme.errorContainer.withOpacity(0.15),
          Icons.cancel_outlined
        ),
      MessApprovalStatus.suspended => (
          Colors.red.shade800,
          Colors.red.shade50,
          Icons.block_outlined
        ),
    };

    final dateStr = _formatDate(mess.submissionDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: mess.status == MessApprovalStatus.pending
              ? Colors.orange.withOpacity(0.4)
              : colorScheme.outlineVariant.withOpacity(0.6),
          width: mess.status == MessApprovalStatus.pending ? 1.5 : 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status and Date Row
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
                        mess.status.label.toUpperCase(),
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
                  'Submitted $dateStr',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mess Title and Subtitle Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mess.messName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.person_outline, size: 14, color: colorScheme.onSurfaceVariant),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              'Owner: ${mess.ownerName}',
                              style: textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Food Type Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: mess.foodType.toLowerCase().contains('veg') && !mess.foodType.toLowerCase().contains('non')
                        ? Colors.green.shade50
                        : (mess.foodType.toLowerCase().contains('non') ? Colors.red.shade50 : Colors.teal.shade50),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: mess.foodType.toLowerCase().contains('veg') && !mess.foodType.toLowerCase().contains('non')
                          ? Colors.green.shade300
                          : (mess.foodType.toLowerCase().contains('non') ? Colors.red.shade300 : Colors.teal.shade300),
                    ),
                  ),
                  child: Text(
                    mess.foodType,
                    style: textTheme.labelSmall?.copyWith(
                      color: mess.foodType.toLowerCase().contains('veg') && !mess.foodType.toLowerCase().contains('non')
                          ? Colors.green.shade900
                          : (mess.foodType.toLowerCase().contains('non') ? Colors.red.shade900 : Colors.teal.shade900),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Description
            Text(
              mess.description,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),

            // Address & Contact info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined, size: 16, color: colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    mess.address,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 400;
                return isWide
                    ? Row(
                        children: [
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'FSSAI License',
                              mess.fssaiLicense,
                              isCode: true,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'Starting Plan Price',
                              '₹${mess.startingPrice}/month',
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetaItem(
                            context,
                            'FSSAI License',
                            mess.fssaiLicense,
                            isCode: true,
                          ),
                          const SizedBox(height: 8),
                          _buildMetaItem(
                            context,
                            'Starting Plan Price',
                            '₹${mess.startingPrice}/month',
                          ),
                        ],
                      );
              },
            ),

            const SizedBox(height: 8),
            _buildMetaItem(context, 'Contact Information', '${mess.contactNumber} • ${mess.email}'),

            // Rejection reason banner
            if (mess.status == MessApprovalStatus.rejected && mess.rejectionReasonType != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.error.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error_outline, size: 14, color: colorScheme.error),
                        const SizedBox(width: 6),
                        Text(
                          'Rejection Reason: ${mess.rejectionReasonType!.label}',
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (mess.rejectionReasonDetails != null && mess.rejectionReasonDetails!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        mess.rejectionReasonDetails!,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.error.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: onViewDocuments,
                  icon: const Icon(Icons.description_outlined, size: 16),
                  label: const Text('View Docs'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: const Size(0, 36),
                  ),
                ),
                const Spacer(),
                _buildActionButtons(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(BuildContext context, String title, String value, {bool isCode = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withOpacity(0.7),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: isCode ? 'Courier' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (mess.status) {
      case MessApprovalStatus.pending:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton.filledTonal(
              tooltip: 'Reject Application',
              icon: Icon(Icons.close, color: colorScheme.error),
              style: IconButton.styleFrom(
                backgroundColor: colorScheme.errorContainer.withOpacity(0.4),
              ),
              onPressed: onReject,
            ),
            const SizedBox(width: 8),
            IconButton.filled(
              tooltip: 'Approve Application',
              icon: const Icon(Icons.check),
              style: IconButton.styleFrom(
                backgroundColor: Colors.green.shade700,
              ),
              onPressed: onApprove,
            ),
          ],
        );
      case MessApprovalStatus.approved:
        return TextButton.icon(
          onPressed: onSuspend,
          icon: Icon(Icons.block, size: 16, color: colorScheme.error),
          label: Text('Suspend', style: TextStyle(color: colorScheme.error)),
        );
      case MessApprovalStatus.rejected:
        return OutlinedButton.icon(
          onPressed: onApprove,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Re-evaluate'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(0, 36),
          ),
        );
      case MessApprovalStatus.suspended:
        return FilledButton.icon(
          onPressed: onReactivate,
          icon: const Icon(Icons.check_circle_outline, size: 16),
          label: const Text('Reactivate'),
        );
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }
}
