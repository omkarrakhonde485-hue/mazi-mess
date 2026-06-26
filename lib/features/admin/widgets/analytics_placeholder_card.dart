import 'package:flutter/material.dart';

class AnalyticsPlaceholderCard extends StatelessWidget {
  const AnalyticsPlaceholderCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.isChartPlaceholder = false,
    this.subscriptionDistributionData,
  });

  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final bool isChartPlaceholder;
  final Map<String, int>? subscriptionDistributionData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      margin: EdgeInsets.zero,
      color: colorScheme.surfaceContainerLow,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (badgeText != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: badgeColor ?? colorScheme.primaryContainer.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      badgeText!,
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (isChartPlaceholder)
              _buildMockRevenueChart(context)
            else if (subscriptionDistributionData != null)
              _buildSubscriptionDistribution(context, subscriptionDistributionData!)
            else
              const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildMockRevenueChart(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // List of 12 mock heights representing relative revenue heights
    final List<double> relativeHeights = [0.3, 0.45, 0.4, 0.55, 0.7, 0.6, 0.8, 0.75, 0.9, 0.85, 0.95, 1.0];
    final List<String> shortMonths = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];

    return Column(
      children: [
        SizedBox(
          height: 130,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(12, (index) {
              final isCurrentMonth = index == 11;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final barHeight = constraints.maxHeight * relativeHeights[index];
                            return Container(
                              height: barHeight,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isCurrentMonth
                                      ? [
                                          colorScheme.primary,
                                          colorScheme.primary.withValues(alpha: 0.7),
                                        ]
                                      : [
                                          colorScheme.primaryContainer,
                                          colorScheme.primaryContainer.withValues(alpha: 0.5),
                                        ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        shortMonths[index],
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          fontWeight: isCurrentMonth ? FontWeight.bold : FontWeight.normal,
                          color: isCurrentMonth ? colorScheme.primary : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionDistribution(
    BuildContext context,
    Map<String, int> data,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final int total = data.values.fold(0, (sum, val) => sum + val);

    return Column(
      children: data.entries.map((entry) {
        final percentage = total > 0 ? (entry.value / total) : 0.0;
        final isMonthly = entry.key.toLowerCase().contains('monthly');
        final barColor = isMonthly ? colorScheme.primary : colorScheme.secondary;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry.key,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '${entry.value} owners (${(percentage * 100).toStringAsFixed(0)}%)',
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: barColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 12,
                  width: double.infinity,
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: percentage,
                    child: Container(
                      decoration: BoxDecoration(
                        color: barColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
