import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../widgets/analytics_stat_card.dart';
import '../widgets/chart_placeholder_card.dart';
import '../widgets/insight_card.dart';

class AnalyticsPeriodData {
  final String periodName;
  // Revenue Stats
  final String monthlyRevenue;
  final double revenueGrowth;
  final String todayCollections;
  // Customer Analytics
  final int activeSubscribers;
  final int expiringThisWeek;
  final int newCustomersThisMonth;
  // Attendance stats
  final double breakfastAttendancePct;
  final double lunchAttendancePct;
  final double dinnerAttendancePct;
  final double averageAttendancePct;
  // Meal Forecast
  final int forecastBreakfast;
  final int forecastLunch;
  final int forecastDinner;
  // Chart Values
  final List<double> revenueChartValues;
  final List<String> revenueChartLabels;
  final List<double> customerShareValues;
  final List<String> customerShareLabels;
  final List<double> attendanceTrendValues;
  final List<String> attendanceTrendLabels;

  const AnalyticsPeriodData({
    required this.periodName,
    required this.monthlyRevenue,
    required this.revenueGrowth,
    required this.todayCollections,
    required this.activeSubscribers,
    required this.expiringThisWeek,
    required this.newCustomersThisMonth,
    required this.breakfastAttendancePct,
    required this.lunchAttendancePct,
    required this.dinnerAttendancePct,
    required this.averageAttendancePct,
    required this.forecastBreakfast,
    required this.forecastLunch,
    required this.forecastDinner,
    required this.revenueChartValues,
    required this.revenueChartLabels,
    required this.customerShareValues,
    required this.customerShareLabels,
    required this.attendanceTrendValues,
    required this.attendanceTrendLabels,
  });
}

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _timeTabController;
  int _activeTabIndex = 1; // Default to Monthly

  // Mock static datasets representing weekly vs monthly vs quarterly trends
  final Map<int, AnalyticsPeriodData> _periodMetrics = {
    // 0: Weekly Overview Action
    0: const AnalyticsPeriodData(
      periodName: 'Weekly',
      monthlyRevenue: '₹28,450',
      revenueGrowth: 4.8,
      todayCollections: '₹4,120',
      activeSubscribers: 242,
      expiringThisWeek: 14,
      newCustomersThisMonth: 12,
      breakfastAttendancePct: 82.5,
      lunchAttendancePct: 89.0,
      dinnerAttendancePct: 76.8,
      averageAttendancePct: 82.7,
      forecastBreakfast: 138,
      forecastLunch: 172,
      forecastDinner: 154,
      revenueChartValues: [15, 25, 18, 22, 30, 28, 32],
      revenueChartLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      customerShareValues: [130, 72, 40],
      customerShareLabels: ['Silver Tier', 'Gold VIP', 'Premium Monthly'],
      attendanceTrendValues: [78.0, 81.5, 85.0, 80.0, 83.2, 82.7],
      attendanceTrendLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
    ),
    // 1: Monthly Overview (Default)
    1: const AnalyticsPeriodData(
      periodName: 'Monthly',
      monthlyRevenue: '₹1,24,850',
      revenueGrowth: 12.4,
      todayCollections: '₹5,840',
      activeSubscribers: 256,
      expiringThisWeek: 3,
      newCustomersThisMonth: 38,
      breakfastAttendancePct: 86.2,
      lunchAttendancePct: 91.5,
      dinnerAttendancePct: 81.0,
      averageAttendancePct: 86.2,
      forecastBreakfast: 145,
      forecastLunch: 180,
      forecastDinner: 162,
      revenueChartValues: [40, 65, 52, 85, 95, 75, 124], // representing weeks/months values
      revenueChartLabels: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6', 'Current'],
      customerShareValues: [142, 85, 29],
      customerShareLabels: ['Silver Tier', 'Gold VIP', 'Premium Monthly'],
      attendanceTrendValues: [82.0, 84.5, 83.0, 87.2, 85.0, 86.2],
      attendanceTrendLabels: ['Week 1', 'Week 2', 'Week 3', 'Week 4', 'Week 5', 'Week 6'],
    ),
    // 2: Quarterly Overview
    2: const AnalyticsPeriodData(
      periodName: 'Quarterly',
      monthlyRevenue: '₹3,85,400',
      revenueGrowth: 18.2,
      todayCollections: '₹6,200',
      activeSubscribers: 278,
      expiringThisWeek: 28,
      newCustomersThisMonth: 95,
      breakfastAttendancePct: 88.0,
      lunchAttendancePct: 93.4,
      dinnerAttendancePct: 83.5,
      averageAttendancePct: 88.3,
      forecastBreakfast: 155,
      forecastLunch: 195,
      forecastDinner: 175,
      revenueChartValues: [110, 142, 130, 165, 185, 210, 385],
      revenueChartLabels: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar', 'Apr'],
      customerShareValues: [150, 95, 33],
      customerShareLabels: ['Silver Tier', 'Gold VIP', 'Premium Monthly'],
      attendanceTrendValues: [85.0, 86.4, 87.1, 86.8, 89.0, 88.3],
      attendanceTrendLabels: ['Oct', 'Nov', 'Dec', 'Jan', 'Feb', 'Mar'],
    ),
  };

  @override
  void initState() {
    super.initState();
    _timeTabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _timeTabController.addListener(() {
      if (!_timeTabController.indexIsChanging) {
        setState(() {
          _activeTabIndex = _timeTabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _timeTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final data = _periodMetrics[_activeTabIndex] ?? _periodMetrics[1]!;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Analytics & Insights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            tooltip: 'Refresh Analytics',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Analytics reports updated dynamically.'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Time interval tabs
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _timeTabController,
                indicator: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: colorScheme.onPrimary,
                unselectedLabelColor: colorScheme.onSurfaceVariant,
                labelStyle: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Weekly'),
                  Tab(text: 'Monthly'),
                  Tab(text: 'Quarterly'),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  // QUICK INSIGHTS SECTION (Requirement 6)
                  _buildSectionHeader('AI Business Insights', Icons.auto_awesome_outlined),
                  const SizedBox(height: 8),
                  InsightCard(
                    title: 'Attendance Trend Surge',
                    description: 'Daily dinner attendance is up by 8% over the past week. Preparing extra 10-15 plates recommended for upcoming week.',
                    type: InsightType.growth,
                    actionLabel: 'Check Attendance dashboard',
                    onActionPressed: () => context.push(AppRoute.attendanceDashboard.path),
                  ),
                  InsightCard(
                    title: 'Revenue Milestone Reached',
                    description: 'Your monthly revenue is up 12% compared to last period. Thanks for expanding VIP popular menus!',
                    type: InsightType.success,
                  ),
                  InsightCard(
                    title: 'Urgent Expirations Alerts',
                    description: '${data.expiringThisWeek} premium subscriber subscriptions are expiring tomorrow or within the next 48 hours.',
                    type: InsightType.warning,
                    actionLabel: 'View expiring subscriber details',
                    onActionPressed: () => context.push(AppRoute.customerManagement.path),
                  ),
                  const SizedBox(height: 16),

                  // REVENUE OVERVIEW SECTION (Requirement 1)
                  _buildSectionHeader('Revenue Overview', Icons.paid_outlined),
                  const SizedBox(height: 10),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 500;
                      return Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AnalyticsStatCard(
                                  title: 'Revenue Collections',
                                  value: data.monthlyRevenue,
                                  icon: Icons.account_balance_outlined,
                                  iconColor: colorScheme.primary,
                                  trendPercentage: data.revenueGrowth,
                                  trendLabel: 'vs last ${data.periodName.toLowerCase()}',
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AnalyticsStatCard(
                                  title: "Today's Collection",
                                  value: data.todayCollections,
                                  icon: Icons.today_outlined,
                                  iconColor: Colors.deepOrange,
                                  subtitle: 'Cleared & instant bank payouts',
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  ChartPlaceholderCard(
                    title: 'Revenue Inflow Tracker',
                    subtitle: 'Transaction amounts cleared (in Thousands)',
                    chartType: ChartType.line,
                    xAxisLabels: data.revenueChartLabels,
                    values: data.revenueChartValues,
                    legends: const ['Net Revenue'],
                    colors: [colorScheme.primary],
                  ),
                  const SizedBox(height: 24),

                  // CUSTOMER ANALYTICS (Requirement 2)
                  _buildSectionHeader('Customer Analytics', Icons.people_outline),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: AnalyticsStatCard(
                          title: 'Active Subscribers',
                          value: '${data.activeSubscribers}',
                          icon: Icons.badge_outlined,
                          iconColor: Colors.teal,
                          subtitle: 'With active food passes',
                          onTap: () => context.push(AppRoute.customerManagement.path),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AnalyticsStatCard(
                          title: 'Expiring Soon',
                          value: '${data.expiringThisWeek}',
                          icon: Icons.hourglass_bottom_rounded,
                          iconColor: Colors.amber,
                          subtitle: 'Within next 7 days',
                          onTap: () => context.push(AppRoute.customerManagement.path),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AnalyticsStatCard(
                          title: 'New Registers',
                          value: '+${data.newCustomersThisMonth}',
                          icon: Icons.person_add_alt_outlined,
                          iconColor: Colors.purple,
                          subtitle: 'Added during this span',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ATTENDANCE ANALYTICS (Requirement 3)
                  _buildSectionHeader('Attendance Logs & Density', Icons.analytics_outlined),
                  const SizedBox(height: 10),
                  ChartPlaceholderCard(
                    title: 'Meal Coverage Attendance',
                    subtitle: 'Day-to-day attendance level splits',
                    chartType: ChartType.metricsGrid,
                    xAxisLabels: const ['Breakfast', 'Lunch', 'Dinner'],
                    values: [data.breakfastAttendancePct, data.lunchAttendancePct, data.dinnerAttendancePct],
                    colors: [Colors.orange.shade700, Colors.teal, Colors.blueAccent],
                  ),
                  const SizedBox(height: 12),
                  ChartPlaceholderCard(
                    title: 'Overall Attendance Trend',
                    subtitle: 'Average tracking percentage metrics',
                    chartType: ChartType.bar,
                    xAxisLabels: data.attendanceTrendLabels,
                    values: data.attendanceTrendValues,
                    colors: [colorScheme.primaryContainer],
                  ),
                  const SizedBox(height: 24),

                  // MEAL FORECAST (Requirement 4)
                  _buildSectionHeader("Tomorrow's Plate Forecasts", Icons.batch_prediction_outlined),
                  const SizedBox(height: 6),
                  Text(
                    'Predicted attendance based on historical check-in statistics.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withAlpha(160),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withAlpha(60),
                      ),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildForecastRow(
                          context,
                          mealName: 'Breakfast',
                          predictedCount: data.forecastBreakfast,
                          timeSpan: '08:00 AM - 10:00 AM',
                          barColor: Colors.amber,
                          icon: Icons.wb_sunny_outlined,
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildForecastRow(
                          context,
                          mealName: 'Lunch',
                          predictedCount: data.forecastLunch,
                          timeSpan: '12:30 PM - 02:30 PM',
                          barColor: Colors.teal,
                          icon: Icons.sunny,
                        ),
                        const Divider(height: 24, thickness: 0.5),
                        _buildForecastRow(
                          context,
                          mealName: 'Dinner',
                          predictedCount: data.forecastDinner,
                          timeSpan: '08:00 PM - 10:00 PM',
                          barColor: Colors.indigo,
                          icon: Icons.nightlight_round_sharp,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // POPULAR PLANS (Requirement 5)
                  _buildSectionHeader('Plan Popularity Share', Icons.workspace_premium_outlined),
                  const SizedBox(height: 10),
                  ChartPlaceholderCard(
                    title: 'Subscriber Plan Share',
                    subtitle: 'Distribution of active monthly passes',
                    chartType: ChartType.donut,
                    xAxisLabels: data.customerShareLabels,
                    values: data.customerShareValues,
                    legends: const ['Silver', 'Gold', 'Premium'],
                    colors: [
                      colorScheme.primary,
                      colorScheme.secondary,
                      colorScheme.tertiary,
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Icon(icon, size: 20, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastRow(
    BuildContext context, {
    required String mealName,
    required int predictedCount,
    required String timeSpan,
    required Color barColor,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: barColor.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: barColor, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mealName,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                timeSpan,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withAlpha(150),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              textBaseline: TextBaseline.alphabetic,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                Text(
                  '$predictedCount',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  'plates',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant.withAlpha(150),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'High Confidence',
                style: textTheme.labelSmall?.copyWith(
                  color: Colors.green.shade800,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
