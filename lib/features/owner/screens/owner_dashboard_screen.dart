import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../notifications/providers/notifications_provider.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/quick_action_tile.dart';

/// Data model representing a Mess for switcher purposes
class MessData {
  final String name;
  final String status;
  final int activeCustomers;
  final int leaveCustomers;
  final String breakfastActual;
  final String breakfastExpected;
  final String lunchActual;
  final String lunchExpected;
  final String dinnerExpected;
  final List<JoinRequestData> pendingRequests;
  final List<ExpiringCustomerData> expiringCustomers;
  final String verifiedRevenue;
  final String pendingRevenue;

  const MessData({
    required this.name,
    required this.status,
    required this.activeCustomers,
    required this.leaveCustomers,
    required this.breakfastActual,
    required this.breakfastExpected,
    required this.lunchActual,
    required this.lunchExpected,
    required this.dinnerExpected,
    required this.pendingRequests,
    required this.expiringCustomers,
    required this.verifiedRevenue,
    required this.pendingRevenue,
  });
}

class JoinRequestData {
  final String id;
  final String name;
  final String planName;
  final int age;
  final String gender;
  final String requestTime;
  final String avatarUrl;

  const JoinRequestData({
    required this.id,
    required this.name,
    required this.planName,
    required this.age,
    required this.gender,
    required this.requestTime,
    required this.avatarUrl,
  });
}

class ExpiringCustomerData {
  final String id;
  final String name;
  final String timeline;
  final Color badgeColor;
  final String planName;

  const ExpiringCustomerData({
    required this.id,
    required this.name,
    required this.timeline,
    required this.badgeColor,
    required this.planName,
  });
}

class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  // Pre-configured elegant mock masses
  final List<MessData> _messes = [
    const MessData(
      name: 'Annapurna Mess',
      status: 'Active',
      activeCustomers: 50,
      leaveCustomers: 4,
      breakfastActual: '44',
      breakfastExpected: '48',
      lunchActual: '42',
      lunchExpected: '46',
      dinnerExpected: '45',
      pendingRequests: [
        JoinRequestData(
          id: 'req1',
          name: 'Rohan Gaikwad',
          planName: 'Premium Unlimited L&D',
          age: 21,
          gender: 'Male',
          requestTime: '10 mins ago',
          avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150&q=80',
        ),
        JoinRequestData(
          id: 'req2',
          name: 'Kajal Patil',
          planName: 'Standard 2 Meals/Day',
          age: 20,
          gender: 'Female',
          requestTime: '1 hour ago',
          avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80',
        ),
        JoinRequestData(
          id: 'req3',
          name: 'Tanmay Deshmukh',
          planName: 'Monthly Basic Plan',
          age: 22,
          gender: 'Male',
          requestTime: '4 hours ago',
          avatarUrl: 'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?auto=format&fit=crop&w=150&q=80',
        ),
      ],
      expiringCustomers: [
        ExpiringCustomerData(
          id: 'exp1',
          name: 'Priya',
          timeline: 'Today',
          badgeColor: Colors.red,
          planName: 'Premium Monthly',
        ),
        ExpiringCustomerData(
          id: 'exp2',
          name: 'Rahul',
          timeline: '1 day left',
          badgeColor: Colors.orange,
          planName: 'Basic Lunch Only',
        ),
        ExpiringCustomerData(
          id: 'exp3',
          name: 'Amit',
          timeline: 'Tomorrow',
          badgeColor: Colors.amber,
          planName: 'Standard 2 Meals',
        ),
      ],
      verifiedRevenue: '₹45,200',
      pendingRevenue: '₹6,800',
    ),
    const MessData(
      name: 'Mazi Mess Main',
      status: 'Active',
      activeCustomers: 65,
      leaveCustomers: 7,
      breakfastActual: '55',
      breakfastExpected: '60',
      lunchActual: '38',
      lunchExpected: '58',
      dinnerExpected: '57',
      pendingRequests: [
        JoinRequestData(
          id: 'req4',
          name: 'Sneha Kulkarni',
          planName: 'Premium Unlimited L&D',
          age: 19,
          gender: 'Female',
          requestTime: '2 mins ago',
          avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?auto=format&fit=crop&w=150&q=80',
        ),
        JoinRequestData(
          id: 'req5',
          name: 'Vineet Joshi',
          planName: 'Monthly Basic Plan',
          age: 23,
          gender: 'Male',
          requestTime: '30 mins ago',
          avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80',
        ),
      ],
      expiringCustomers: [
        ExpiringCustomerData(
          id: 'exp4',
          name: 'Rohit',
          timeline: 'Today',
          badgeColor: Colors.red,
          planName: 'Standard Monthly',
        ),
        ExpiringCustomerData(
          id: 'exp5',
          name: 'Shruti',
          timeline: 'Tomorrow',
          badgeColor: Colors.amber,
          planName: 'Premium 2 Meals',
        ),
      ],
      verifiedRevenue: '₹62,400',
      pendingRevenue: '₹8,100',
    ),
    const MessData(
      name: 'Gurukrupa Dining',
      status: 'Active',
      activeCustomers: 35,
      leaveCustomers: 3,
      breakfastActual: '31',
      breakfastExpected: '35',
      lunchActual: '29',
      lunchExpected: '33',
      dinnerExpected: '32',
      pendingRequests: [],
      expiringCustomers: [
        ExpiringCustomerData(
          id: 'exp6',
          name: 'Chetan',
          timeline: 'Tomorrow',
          badgeColor: Colors.amber,
          planName: 'Basic Monthly',
        ),
        ExpiringCustomerData(
          id: 'exp7',
          name: 'Yash',
          timeline: 'Today',
          badgeColor: Colors.red,
          planName: 'Premium Unlimited',
        ),
      ],
      verifiedRevenue: '₹24,000',
      pendingRevenue: '₹1,500',
    ),
  ];

  late int _selectedMessIndex;
  late List<JoinRequestData> _currentRequests;

  @override
  void initState() {
    super.initState();
    _selectedMessIndex = 0;
    _currentRequests = List.from(_messes[_selectedMessIndex].pendingRequests);
  }

  MessData get _currentMess => _messes[_selectedMessIndex];

  void _showComingSoon(String actionName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$actionName features coming soon! (No Firebase Sandbox)'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _switchMess(int index) {
    setState(() {
      _selectedMessIndex = index;
      _currentRequests = List.from(_messes[_selectedMessIndex].pendingRequests);
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to ${_messes[index].name}'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showMessSelector() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'Select Mess Outlet',
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                const Divider(),
                ...List.generate(_messes.length, (index) {
                  final mess = _messes[index];
                  final isSelected = index == _selectedMessIndex;

                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.storefront_outlined,
                        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
                      ),
                    ),
                    title: Text(
                      mess.name,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      '${mess.activeCustomers} active customers • ${mess.status}',
                      style: textTheme.bodySmall,
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: colorScheme.primary)
                        : null,
                    onTap: () => _switchMess(index),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleRequestAction(String id, bool approved) {
    setState(() {
      _currentRequests.removeWhere((item) => item.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(approved ? 'Request Approved' : 'Request Declined'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: 70,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Good Morning, Omkar',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            GestureDetector(
              onTap: _showMessSelector,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentMess.name,
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: colorScheme.primary,
                    size: 24,
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Notifications',
            onPressed: () => context.push(AppRoute.notifications.path),
            icon: Badge(
              isLabelVisible: ref.watch(notificationsProvider).any((n) => !n.isRead),
              label: Text(
                '${ref.watch(notificationsProvider).where((n) => !n.isRead).length}',
              ),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. MEAL ATTENDANCE SUMMARY SECTION
              _SectionHeader(
                title: "Today's Meal Attendance Summary",
                badgeCount: null,
                tooltip: "Dynamic attendance dashboard highlighting Live & Complete schedules",
              ),
              const SizedBox(height: 12),
              _buildAttendanceSummary(),
              const SizedBox(height: 12),
              _buildExpectedCountExplanation(),

              const SizedBox(height: 28),

              // 2. PENDING JOIN REQUESTS SECTION
              _SectionHeader(
                title: "Pending Join Requests",
                badgeCount: _currentRequests.length,
              ),
              const SizedBox(height: 12),
              _buildPendingRequestsList(),

              const SizedBox(height: 28),

              // 3. EXPIRING CUSTOMERS SECTION
              _SectionHeader(
                title: "Expiring Customers",
                badgeCount: _currentMess.expiringCustomers.length,
              ),
              const SizedBox(height: 12),
              _buildExpiringCustomersList(),

              const SizedBox(height: 28),

              // 4. REVENUE SUMMARY SECTION
              _SectionHeader(
                title: "Revenue Summary",
                badgeCount: null,
              ),
              const SizedBox(height: 12),
              _buildRevenueSummarySection(),

              const SizedBox(height: 28),

              // 5. QUICK ACTIONS SECTION
              _SectionHeader(
                title: "Quick Actions",
                badgeCount: null,
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  /// SECTION: Today's Meal Attendance Summary
  Widget _buildAttendanceSummary() {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.outlineVariant, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Breakfast - Completed
            _buildMealRow(
              icon: Icons.wb_sunny_outlined,
              iconColor: Colors.orange,
              mealTitle: 'Breakfast',
              mealSubtitle: 'Completed',
              attendanceText: '${_currentMess.breakfastActual} / ${_currentMess.breakfastExpected}',
              isLive: false,
              isFuture: false,
            ),
            const Divider(height: 24),

            // Lunch - Current Live
            _buildMealRow(
              icon: Icons.light_mode,
              iconColor: Colors.amber[700]!,
              mealTitle: 'Lunch',
              mealSubtitle: 'Current Active',
              attendanceText: 'Live ${_currentMess.lunchActual} / ${_currentMess.lunchExpected}',
              isLive: true,
              isFuture: false,
            ),
            const Divider(height: 24),

            // Dinner - Future
            _buildMealRow(
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.indigo,
              mealTitle: 'Dinner',
              mealSubtitle: 'Future Meal',
              attendanceText: _currentMess.dinnerExpected,
              isLive: false,
              isFuture: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealRow({
    required IconData icon,
    required Color iconColor,
    required String mealTitle,
    required String mealSubtitle,
    required String attendanceText,
    required bool isLive,
    required bool isFuture,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      mealTitle,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isLive) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 6,
                            height: 6,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.5,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                mealSubtitle,
                style: textTheme.bodySmall?.copyWith(
                  color: isLive ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  fontWeight: isLive ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        Text(
          attendanceText,
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isLive ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildExpectedCountExplanation() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerHighest.withAlpha(80),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.info_outline, size: 16, color: colorScheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Expected calculation: Active Customers (${_currentMess.activeCustomers}) - Leave Customers (${_currentMess.leaveCustomers}) = Expected Meals',
                style: textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION: Pending Join Requests
  Widget _buildPendingRequestsList() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (_currentRequests.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_outline, size: 40, color: colorScheme.onSurfaceVariant.withAlpha(100)),
              const SizedBox(height: 12),
              Text(
                'No pending join requests',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ..._currentRequests.map((req) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage: NetworkImage(req.avatarUrl),
                        backgroundColor: colorScheme.primaryContainer,
                        onBackgroundImageError: (_, __) {},
                        child: Text(
                          req.name[0],
                          style: TextStyle(color: colorScheme.onPrimaryContainer),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    req.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Text(
                                  req.requestTime,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              req.planName,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Age: ${req.age} • Gender: ${req.gender}',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(90, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () => _handleRequestAction(req.id, false),
                        child: const Text('Decline'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(90, 36),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        onPressed: () => _handleRequestAction(req.id, true),
                        child: const Text('Accept'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 4),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoute.joinRequests.path),
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text('View All Requests'),
        ),
      ],
    );
  }

  /// SECTION: Expiring Customers
  Widget _buildExpiringCustomersList() {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: colorScheme.outlineVariant, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _currentMess.expiringCustomers.length,
              separatorBuilder: (context, index) => const Divider(height: 8),
              itemBuilder: (context, index) {
                final customer = _currentMess.expiringCustomers[index];

                return ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    radius: 16,
                    backgroundColor: customer.badgeColor.withAlpha(25),
                    child: Icon(
                      Icons.hourglass_bottom_outlined,
                      color: customer.badgeColor,
                      size: 16,
                    ),
                  ),
                  title: Text(
                    customer.name,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  subtitle: Text(
                    customer.planName,
                    style: textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: customer.badgeColor.withAlpha(25),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      customer.timeline,
                      style: textTheme.labelSmall?.copyWith(
                        color: customer.badgeColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => context.push(AppRoute.customerManagement.path),
          icon: const Icon(Icons.people_outline, size: 16),
          label: const Text('View All'),
        ),
      ],
    );
  }

  /// SECTION: Revenue Summary
  Widget _buildRevenueSummarySection() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: DashboardStatCard(
                title: 'Verified Revenue',
                value: _currentMess.verifiedRevenue,
                icon: Icons.check_circle_outline,
                iconColor: Colors.green,
                subtitle: 'Current Month',
                backgroundColor: colorScheme.surfaceContainerLow,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DashboardStatCard(
                title: 'Pending Verification',
                value: _currentMess.pendingRevenue,
                icon: Icons.hourglass_empty_outlined,
                iconColor: Colors.orange,
                subtitle: 'Awaiting admin confirm',
                backgroundColor: colorScheme.surfaceContainerLow,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => _showComingSoon('View Analytics'),
          icon: const Icon(Icons.analytics_outlined, size: 16),
          label: const Text('View Analytics'),
        ),
      ],
    );
  }

  /// SECTION: Quick Actions Grid
  Widget _buildQuickActionsGrid() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: QuickActionTile(
                  icon: Icons.qr_code_scanner,
                  label: 'Scan Attendance',
                  subtitle: 'Verify codes',
                  trailingIcon: null,
                  onTap: () => context.push(AppRoute.attendanceDashboard.path),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionTile(
                  icon: Icons.campaign_outlined,
                  label: 'Create Notice',
                  subtitle: 'Publish alerts',
                  trailingIcon: null,
                  onTap: () => _showComingSoon('Create Notice'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: QuickActionTile(
                  icon: Icons.restaurant_menu_outlined,
                  label: 'Manage Plans',
                  subtitle: 'Edit offers',
                  trailingIcon: null,
                  onTap: () => context.push(AppRoute.planManagement.path),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: QuickActionTile(
                  icon: Icons.people_outline,
                  label: 'Manage Customers',
                  subtitle: 'Customer list',
                  trailingIcon: null,
                  onTap: () => context.push(AppRoute.customerManagement.path),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.badgeCount,
    this.tooltip,
  });

  final String title;
  final int? badgeCount;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.5,
                  ),
                ),
              ),
              if (tooltip != null) ...[
                const SizedBox(width: 4),
                Tooltip(
                  message: tooltip!,
                  child: Icon(Icons.help_outline, size: 14, color: colorScheme.onSurfaceVariant),
                ),
              ],
              if (badgeCount != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeCount! > 0 ? colorScheme.error : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: textTheme.labelSmall?.copyWith(
                      color: badgeCount! > 0 ? colorScheme.onError : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
