import 'package:flutter/material.dart';
import '../../../models/owner_profile_model.dart';

class OwnerVerificationCard extends StatelessWidget {
  const OwnerVerificationCard({
    super.key,
    required this.owner,
    required this.onApprove,
    required this.onReject,
    required this.onSuspend,
    required this.onReactivate,
    this.onViewDocument,
  });

  final OwnerProfile owner;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onSuspend;
  final VoidCallback onReactivate;
  final VoidCallback? onViewDocument;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color statusColor, Color statusBg, IconData statusIcon) =
        switch (owner.verificationStatus) {
      OwnerVerificationStatus.pending => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.pending_actions_outlined
        ),
      OwnerVerificationStatus.approved => (
          Colors.green.shade800,
          Colors.green.shade50,
          Icons.verified_user_outlined
        ),
      OwnerVerificationStatus.rejected => (
          colorScheme.error,
          colorScheme.errorContainer.withOpacity(0.2),
          Icons.gpp_bad_outlined
        ),
      OwnerVerificationStatus.suspended => (
          Colors.grey.shade800,
          Colors.grey.shade200,
          Icons.block_outlined
        ),
    };

    final dateStr = _formatDate(owner.submissionDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: owner.verificationStatus == OwnerVerificationStatus.pending
              ? Colors.orange.withOpacity(0.4)
              : colorScheme.outlineVariant.withOpacity(0.6),
          width: owner.verificationStatus == OwnerVerificationStatus.pending ? 1.5 : 1.0,
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
                        owner.verificationStatus.label.toUpperCase(),
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

            // Owner Basic details
            Text(
              owner.fullName,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.business, size: 14, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${owner.businessName} • Proposed: ${owner.messName}',
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

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Documents / Meta details
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 400;
                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildMetaItem(context, 'FSSAI License', owner.fssaiLicense)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildMetaItem(context, 'PAN Number', owner.panNumber)),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildMetaItem(context, 'FSSAI License', owner.fssaiLicense),
                          const SizedBox(height: 8),
                          _buildMetaItem(context, 'PAN Number', owner.panNumber),
                        ],
                      );
              },
            ),

            const SizedBox(height: 8),
            _buildMetaItem(context, 'Contact Info', '${owner.phoneNumber} | ${owner.email}'),

            if (owner.verificationStatus == OwnerVerificationStatus.rejected &&
                owner.rejectionReason != null) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: colorScheme.error.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Rejection Reason:',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      owner.rejectionReason!,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Document button and Actions
            Row(
              children: [
                if (onViewDocument != null)
                  OutlinedButton.icon(
                    onPressed: onViewDocument,
                    icon: const Icon(Icons.description_outlined, size: 16),
                    label: const Text('View Docs'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildMetaItem(BuildContext context, String title, String value) {
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
            fontFamily: title.contains('License') || title.contains('PAN') ? 'Courier' : null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (owner.verificationStatus) {
      case OwnerVerificationStatus.pending:
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
      case OwnerVerificationStatus.approved:
        return TextButton.icon(
          onPressed: onSuspend,
          icon: Icon(Icons.block, size: 16, color: colorScheme.error),
          label: Text('Suspend', style: TextStyle(color: colorScheme.error)),
        );
      case OwnerVerificationStatus.rejected:
        return OutlinedButton.icon(
          onPressed: onApprove,
          icon: const Icon(Icons.refresh, size: 16),
          label: const Text('Re-evaluate'),
        );
      case OwnerVerificationStatus.suspended:
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
