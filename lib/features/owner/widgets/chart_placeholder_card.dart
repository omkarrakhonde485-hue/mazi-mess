import 'package:flutter/material.dart';

enum ChartType {
  line,
  bar,
  donut,
  metricsGrid,
}

class ChartPlaceholderCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final ChartType chartType;
  final List<String> xAxisLabels;
  final List<double> values;
  final List<String>? legends;
  final List<Color>? colors;

  const ChartPlaceholderCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.chartType = ChartType.bar,
    this.xAxisLabels = const [],
    this.values = const [],
    this.legends,
    this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                    ),
                  ],
                ),
                // Legend indicators
                if (legends != null && legends!.isNotEmpty)
                  Wrap(
                    spacing: 8,
                    children: List.generate(legends!.length, (index) {
                      final markerColor = colors != null && colors!.length > index
                          ? colors![index]
                          : colorScheme.primary;
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: markerColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            legends![index],
                            style: textTheme.bodySmall?.copyWith(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Chart area
            SizedBox(
              height: 160,
              child: _buildChartContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartContent(BuildContext context) {
    switch (chartType) {
      case ChartType.line:
        return _buildLineChart(context);
      case ChartType.donut:
        return _buildDonutChart(context);
      case ChartType.metricsGrid:
        return _buildMetricsGrid(context);
      case ChartType.bar:
        return _buildBarChart(context);
    }
  }

  Widget _buildBarChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Use default values if none specified
    final List<double> listValues = values.isNotEmpty ? values : [40.0, 65.0, 52.0, 85.0, 95.0, 75.0, 90.0];
    final labels = xAxisLabels.isNotEmpty ? xAxisLabels : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxVal = listValues.reduce((double curr, double next) => curr > next ? curr : next);

    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(listValues.length, (index) {
              final pct = listValues[index] / (maxVal == 0 ? 1 : maxVal);
              final barCol = colors != null && colors!.length > index
                  ? colors![index]
                  : (index == listValues.length - 1
                      ? colorScheme.primary // last one highlighted
                      : colorScheme.primary.withAlpha(120));

              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Value tooltip simulation visible on modern desks
                      Text(
                        '${listValues[index].toInt()}%',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Bar structure
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return Container(
                              width: double.infinity,
                              height: constraints.maxHeight * pct,
                              decoration: BoxDecoration(
                                color: barCol,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(6),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            return Expanded(
              child: Text(
                labels[index],
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant.withAlpha(150),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLineChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final List<double> listValues = values.isNotEmpty ? values : [32.0, 41.0, 38.0, 52.0, 48.0, 64.0];
    final labels = xAxisLabels.isNotEmpty ? xAxisLabels : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final maxVal = listValues.reduce((double curr, double next) => curr > next ? curr : next);

    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            size: Size.infinite,
            painter: _MockLineChartPainter(
              values: listValues,
              maxVal: maxVal,
              lineColor: colors != null && colors!.isNotEmpty ? colors!.first : colorScheme.primary,
              fillColor: (colors != null && colors!.isNotEmpty ? colors!.first : colorScheme.primary).withAlpha(20),
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, thickness: 0.5),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            return Text(
              labels[index],
              style: textTheme.bodySmall?.copyWith(
                fontSize: 10,
                color: colorScheme.onSurfaceVariant.withAlpha(150),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDonutChart(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final List<double> listValues = values.isNotEmpty ? values : [55.0, 30.0, 15.0];
    final labels = xAxisLabels.isNotEmpty ? xAxisLabels : ['Silver Plan', 'Gold Plan', 'Premium Monthly'];
    final total = listValues.reduce((double a, double b) => a + b);

    final itemColors = colors ?? [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary,
    ];

    return Row(
      children: [
        // Donut circle
        Expanded(
          flex: 4,
          child: Center(
            child: SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(110, 110),
                    painter: _MockDonutPainter(
                      values: listValues,
                      colors: itemColors,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total',
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 10,
                          color: colorScheme.onSurfaceVariant.withAlpha(150),
                        ),
                      ),
                      Text(
                        '${total.toInt()}',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Custom Legend Side Panel
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(listValues.length, (index) {
              final pct = (listValues[index] / total) * 100;
              final color = itemColors[index % itemColors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        labels[index],
                        style: textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurface,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '${pct.toStringAsFixed(0)}%',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricsGrid(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final labels = xAxisLabels.isNotEmpty ? xAxisLabels : ['Breakfast', 'Lunch', 'Dinner'];
    final listValues = values.isNotEmpty ? values : [85.0, 92.0, 78.0];

    return Row(
      children: List.generate(labels.length, (index) {
        final pct = listValues[index] / 100.0;
        final color = colors != null && colors!.length > index
            ? colors![index]
            : colorScheme.primary;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outlineVariant.withAlpha(50),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        value: pct,
                        strokeWidth: 5,
                        color: color,
                        backgroundColor: color.withAlpha(30),
                      ),
                    ),
                    Text(
                      '${listValues[index].toInt()}%',
                      style: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  labels[index],
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _MockLineChartPainter extends CustomPainter {
  final List<double> values;
  final double maxVal;
  final Color lineColor;
  final Color fillColor;

  const _MockLineChartPainter({
    required this.values,
    required this.maxVal,
    required this.lineColor,
    required this.fillColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double stepX = size.width / (values.length - 1);
    final double maxPossible = maxVal == 0 ? 1 : maxVal;

    final Path linePath = Path();
    final Path areaPath = Path();

    // Start coordinates
    final startY = size.height - (values[0] / maxPossible) * size.height * 0.8;
    linePath.moveTo(0, startY);
    areaPath.moveTo(0, size.height);
    areaPath.lineTo(0, startY);

    for (int i = 1; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxPossible) * size.height * 0.8;
      linePath.lineTo(x, y);
      areaPath.lineTo(x, y);
    }

    areaPath.lineTo(size.width, size.height);
    areaPath.close();

    // Draw area fill
    final Paint fillPaint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(areaPath, fillPaint);

    // Draw outline path
    final Paint strokePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, strokePaint);

    // Draw little points
    final Paint itemMarkerPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;
    final Paint whiteCorePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxPossible) * size.height * 0.8;
      canvas.drawCircle(Offset(x, y), 5, itemMarkerPaint);
      canvas.drawCircle(Offset(x, y), 2.5, whiteCorePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _MockLineChartPainter oldDelegate) => true;
}

class _MockDonutPainter extends CustomPainter {
  final List<double> values;
  final List<Color> colors;

  const _MockDonutPainter({
    required this.values,
    required this.colors,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final double total = values.reduce((double a, double b) => a + b);
    if (total == 0) return;

    final double sizeValue = size.width;
    final Rect rect = Rect.fromLTWH(6, 6, sizeValue - 12, sizeValue - 12);
    const double strokeWidth = 12.0;

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double startAngle = -3.14159265 / 2; // Start from top 12 o'clock

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / total) * 2 * 3.14159265;
      paint.color = colors[i % colors.length];

      // Draw arc slightly smaller to avoid overlapping rounded edges
      canvas.drawArc(rect, startAngle + 0.05, sweepAngle - 0.1, false, paint);
      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant _MockDonutPainter oldDelegate) => true;
}
