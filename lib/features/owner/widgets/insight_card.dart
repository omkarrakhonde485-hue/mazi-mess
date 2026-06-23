import 'package:flutter/material.dart';

enum InsightType {
  info,
  success,
  warning,
  growth,
}

class InsightCard extends StatelessWidget {
  final String title;
  final String description;
  final InsightType type;
  final IconData? customIcon;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  const InsightCard({
    super.key,
    required this.title,
    required this.description,
    this.type = InsightType.info,
    this.customIcon,
    this.actionLabel,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // Type-specific colors and icons
    Color baseColor;
    Color bgColor;
    IconData icon;

    switch (type) {
      case InsightType.success:
        baseColor = Colors.green.shade700;
        bgColor = Colors.green.shade50;
        icon = Icons.check_circle_outline;
        break;
      case InsightType.warning:
        baseColor = Colors.amber.shade800;
        bgColor = Colors.amber.shade50;
        icon = Icons.warning_amber_rounded;
        break;
      case InsightType.growth:
        baseColor = Colors.teal.shade700;
        bgColor = Colors.teal.shade50;
        icon = Icons.trending_up_rounded;
        break;
      case InsightType.info:
        baseColor = Colors.blue.shade700;
        bgColor = Colors.blue.shade50;
        icon = Icons.lightbulb_outline_rounded;
        break;
    }

    // Override icon if customIcon is provided
    final finalIcon = customIcon ?? icon;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: baseColor.withAlpha(50),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon Accent Container
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: baseColor.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(
                finalIcon,
                color: baseColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),

            // Text Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: baseColor,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: Color.lerp(baseColor, Colors.black87, 0.75),
                      height: 1.35,
                    ),
                  ),
                  if (actionLabel != null && onActionPressed != null) ...[
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: onActionPressed,
                      borderRadius: BorderRadius.circular(4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              actionLabel!,
                              style: textTheme.labelMedium?.copyWith(
                                color: baseColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, size: 14, color: baseColor),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
