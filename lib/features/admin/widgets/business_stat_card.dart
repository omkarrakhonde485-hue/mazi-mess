import 'package:flutter/material.dart';

class BusinessStatCard extends StatelessWidget {
  const BusinessStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.valueColor,
    this.backgroundColor,
    this.iconColor,
    this.iconBgColor,
    this.onTap,
    this.trendValue,
    this.isTrendPositive,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? valueColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? iconBgColor;
  final VoidCallback? onTap;
  final String? trendValue;
  final bool? isTrendPositive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final resolvedBg = backgroundColor ?? colorScheme.surfaceContainerLow;
    final resolvedBorderColor = colorScheme.outlineVariant;

    return Card(
      margin: EdgeInsets.zero,
      color: resolvedBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: resolvedBorderColor,
          width: 1.0,
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
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: iconBgColor ?? colorScheme.primaryContainer.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          icon,
                          color: iconColor ?? colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: valueColor ?? colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                            ? Icons.trending_up_rounded
                            : Icons.trending_down_rounded,
                        color: isTrendPositive == true
                            ? Colors.green
                            : Colors.orange,
                        size: 16,
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
                            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
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
