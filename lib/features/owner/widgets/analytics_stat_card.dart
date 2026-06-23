import 'package:flutter/material.dart';

class AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final String? subtitle;
  final double? trendPercentage; // Positive for up, negative for down, null if none
  final String? trendLabel; // e.g. "vs last month"
  final VoidCallback? onTap;

  const AnalyticsStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.subtitle,
    this.trendPercentage,
    this.trendLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isTrendPositive = trendPercentage != null && trendPercentage! >= 0;
    final trendColor = isTrendPositive ? Colors.green.shade700 : Colors.red.shade700;
    final trendBg = isTrendPositive ? Colors.green.shade50 : Colors.red.shade50;

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(50),
          width: 0.8,
        ),
      ),
      color: backgroundColor ?? colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Icon
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
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: (iconColor ?? colorScheme.primary).withAlpha(15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? colorScheme.primary,
                      size: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Value
              Text(
                value,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),

              // Trend chip or generic subtitle
              if (trendPercentage != null) ...[
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: trendBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isTrendPositive ? Icons.trending_up : Icons.trending_down,
                            size: 10,
                            color: trendColor,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${trendPercentage! >= 0 ? "+" : ""}${trendPercentage!.toStringAsFixed(1)}%',
                            style: textTheme.labelSmall?.copyWith(
                              color: trendColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (trendLabel != null) ...[
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          trendLabel!,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant.withAlpha(150),
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ] else if (subtitle != null) ...[
                Text(
                  subtitle!,
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(180),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
