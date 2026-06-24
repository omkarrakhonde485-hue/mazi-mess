import 'package:flutter/material.dart';

class AdminStatCard extends StatelessWidget {
  const AdminStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.valueColor,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
    this.trendValue,
    this.isTrendPositive,
    this.isCritical = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? valueColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;
  final String? trendValue;
  final bool? isTrendPositive;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final resolvedBg = isCritical
        ? (backgroundColor ?? colorScheme.errorContainer.withOpacity(0.08))
        : (backgroundColor ?? colorScheme.surfaceContainerLow);

    final resolvedBorderColor = isCritical
        ? colorScheme.error.withOpacity(0.3)
        : colorScheme.outlineVariant;

    return Card(
      margin: EdgeInsets.zero,
      color: resolvedBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: resolvedBorderColor,
          width: isCritical ? 1.5 : 1.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: textTheme.labelLarge?.copyWith(
                            color: isCritical
                                ? colorScheme.error
                                : colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isCritical
                              ? colorScheme.errorContainer.withOpacity(0.15)
                              : colorScheme.surfaceContainerHighest.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          icon,
                          color: isCritical
                              ? colorScheme.error
                              : (iconColor ?? colorScheme.primary),
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isCritical
                          ? colorScheme.error
                          : (valueColor ?? colorScheme.onSurface),
                    ),
                  ),
                ],
              ),
              if (trendValue != null || subtitle != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    if (trendValue != null) ...[
                      Icon(
                        isTrendPositive == true
                            ? Icons.trending_up
                            : Icons.trending_down,
                        color: isTrendPositive == true
                            ? Colors.green
                            : Colors.orange,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trendValue!,
                        style: textTheme.bodySmall?.copyWith(
                          color: isTrendPositive == true
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    if (subtitle != null)
                      Expanded(
                        child: Text(
                          subtitle!,
                          style: textTheme.bodySmall?.copyWith(
                            color: isCritical
                                ? colorScheme.error.withOpacity(0.8)
                                : colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
