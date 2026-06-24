import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/webhook_integration_model.dart';

class WebhookIntegrationCard extends StatefulWidget {
  final WebhookIntegration integration;
  final VoidCallback onEdit;
  final VoidCallback onActivate;
  final VoidCallback onDeactivate;

  const WebhookIntegrationCard({
    super.key,
    required this.integration,
    required this.onEdit,
    required this.onActivate,
    required this.onDeactivate,
  });

  @override
  State<WebhookIntegrationCard> createState() => _WebhookIntegrationCardState();
}

class _WebhookIntegrationCardState extends State<WebhookIntegrationCard> {
  bool _obscurePassword = true;

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.copy, color: Theme.of(context).colorScheme.onInverseSurface, size: 18),
            const SizedBox(width: 8),
            const Text('Webhook URL copied to clipboard!'),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final (Color statusColor, Color statusBg, IconData statusIcon) =
        switch (widget.integration.status) {
      WebhookIntegrationStatus.setupRequired => (
          Colors.orange.shade800,
          Colors.orange.shade50,
          Icons.settings_suggest_outlined
        ),
      WebhookIntegrationStatus.active => (
          Colors.green.shade800,
          Colors.green.shade50,
          Icons.check_circle_outline
        ),
      WebhookIntegrationStatus.inactive => (
          Colors.grey.shade800,
          Colors.grey.shade100,
          Icons.pause_circle_outline
        ),
      WebhookIntegrationStatus.error => (
          colorScheme.error,
          colorScheme.errorContainer.withOpacity(0.2),
          Icons.error_outline
        ),
    };

    final dateStr = _formatDate(widget.integration.setupDate);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: widget.integration.status == WebhookIntegrationStatus.setupRequired
              ? Colors.orange.withOpacity(0.4)
              : widget.integration.status == WebhookIntegrationStatus.error
                  ? colorScheme.error.withOpacity(0.4)
                  : colorScheme.outlineVariant.withOpacity(0.6),
          width: 1.0,
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
                        widget.integration.status.label.toUpperCase(),
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
                  'Setup: $dateStr',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Mess Title & Owner details
            Text(
              widget.integration.messName,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_outline, size: 14, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Owner: ${widget.integration.ownerName}',
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

            // Metadata items
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 500;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isWide) ...[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'Verification Gmail',
                              widget.integration.verificationGmail.isEmpty
                                  ? 'Not Configured'
                                  : widget.integration.verificationGmail,
                              icon: Icons.mail_outline,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetaItem(
                              context,
                              'Make Account Email',
                              widget.integration.makeAccountEmail.isEmpty
                                  ? 'Not Configured'
                                  : widget.integration.makeAccountEmail,
                              icon: Icons.account_circle_outlined,
                            ),
                          ),
                        ],
                      ),
                    ] else ...[
                      _buildMetaItem(
                        context,
                        'Verification Gmail',
                        widget.integration.verificationGmail.isEmpty
                            ? 'Not Configured'
                            : widget.integration.verificationGmail,
                        icon: Icons.mail_outline,
                      ),
                      const SizedBox(height: 10),
                      _buildMetaItem(
                        context,
                        'Make Account Email',
                        widget.integration.makeAccountEmail.isEmpty
                            ? 'Not Configured'
                            : widget.integration.makeAccountEmail,
                        icon: Icons.account_circle_outlined,
                      ),
                    ],
                    const SizedBox(height: 10),
                    // Password field with toggle
                    _buildPasswordItem(context),
                    const SizedBox(height: 10),
                    // Webhook URL field with copy button
                    _buildWebhookUrlItem(context),
                    const SizedBox(height: 10),
                    _buildMetaItem(
                      context,
                      'Configured By',
                      widget.integration.configuredBy.isEmpty
                          ? 'N/A'
                          : widget.integration.configuredBy,
                      icon: Icons.admin_panel_settings_outlined,
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // Card Actions Row
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: widget.onEdit,
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  label: const Text('Edit'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    minimumSize: const Size(0, 36),
                  ),
                ),
                const Spacer(),
                if (widget.integration.status == WebhookIntegrationStatus.active)
                  FilledButton.icon(
                    onPressed: widget.onDeactivate,
                    icon: const Icon(Icons.power_settings_new, size: 16),
                    label: const Text('Deactivate'),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                  )
                else
                  FilledButton.icon(
                    onPressed: widget.onActivate,
                    icon: const Icon(Icons.play_arrow_outlined, size: 16),
                    label: const Text('Activate'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      minimumSize: const Size(0, 36),
                    ),
                  ),
              ],
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
              const SizedBox(width: 4),
            ],
            Text(
              title,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildPasswordItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String displayPassword = widget.integration.makeAccountPassword.isEmpty
        ? 'Not Configured'
        : _obscurePassword
            ? '••••••••'
            : widget.integration.makeAccountPassword;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.lock_outline, size: 12, color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
            const SizedBox(width: 4),
            Text(
              'Make Account Password',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                displayPassword,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontFamily: widget.integration.makeAccountPassword.isNotEmpty ? 'Courier' : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.integration.makeAccountPassword.isNotEmpty)
              IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                  size: 18,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                tooltip: _obscurePassword ? 'Show Password' : 'Hide Password',
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWebhookUrlItem(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final String displayUrl = widget.integration.webhookUrl.isEmpty
        ? 'Not Configured'
        : widget.integration.webhookUrl;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link_outlined, size: 12, color: colorScheme.onSurfaceVariant.withOpacity(0.6)),
            const SizedBox(width: 4),
            Text(
              'Webhook URL',
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Expanded(
              child: Text(
                displayUrl,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.integration.webhookUrl.isNotEmpty ? colorScheme.primary : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.integration.webhookUrl.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.copy_outlined, size: 18),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => _copyToClipboard(context, widget.integration.webhookUrl),
                tooltip: 'Copy Webhook URL',
              ),
          ],
        ),
      ],
    );
  }
}
