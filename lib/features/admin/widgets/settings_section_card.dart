import 'package:flutter/material.dart';

class SettingsSectionCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final List<Widget> children;
  final Widget? headerAction;

  const SettingsSectionCard({
    super.key,
    required this.title,
    this.icon,
    required this.children,
    this.headerAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: colorScheme.surfaceContainerLow,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.primary,
                      letterSpacing: 0.15,
                    ),
                  ),
                ),
                if (headerAction != null) headerAction!,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Column(
              children: children.map((widget) {
                // If this is not the last child, we can add a divider, but some tiles have their own padding.
                // We'll just list them out.
                return widget;
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
