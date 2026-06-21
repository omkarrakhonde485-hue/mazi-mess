import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../widgets/attendance_record_card.dart';
import '../widgets/manual_attendance_sheet.dart';
import '../widgets/meal_attendance_summary_card.dart';
import '../widgets/dashboard_stat_card.dart';

class AttendanceLog {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String mealType; // 'Breakfast', 'Lunch', 'Dinner'
  final String time;
  final String status; // 'Present', 'Absent', 'Pending Approval'
  final String method; // 'QR', 'Manual'
  final String? reason;

  AttendanceLog({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.mealType,
    required this.time,
    required this.status,
    required this.method,
    this.reason,
  });

  AttendanceLog copyWith({
    String? id,
    String? customerName,
    String? phoneNumber,
    String? mealType,
    String? time,
    String? status,
    String? method,
    String? reason,
  }) {
    return AttendanceLog(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      mealType: mealType ?? this.mealType,
      time: time ?? this.time,
      status: status ?? this.status,
      method: method ?? this.method,
      reason: reason ?? this.reason,
    );
  }
}

class AttendanceDashboardScreen extends StatefulWidget {
  const AttendanceDashboardScreen({super.key});

  @override
  State<AttendanceDashboardScreen> createState() => _AttendanceDashboardScreenState();
}

class _AttendanceDashboardScreenState extends State<AttendanceDashboardScreen> {
  // Stateful mock attendance logs
  final List<AttendanceLog> _logs = [
    AttendanceLog(
      id: 'log_1',
      customerName: 'Omkar Rakhonde',
      phoneNumber: '+91 98765 43210',
      mealType: 'Breakfast',
      time: '08:12 AM',
      status: 'Present',
      method: 'QR',
    ),
    AttendanceLog(
      id: 'log_2',
      customerName: 'Sneha Kulkarni',
      phoneNumber: '+91 65432 10987',
      mealType: 'Lunch',
      time: '01:05 PM',
      status: 'Present',
      method: 'QR',
    ),
    AttendanceLog(
      id: 'log_3',
      customerName: 'Rohan Mehta',
      phoneNumber: '+91 76543 21098',
      mealType: 'Breakfast',
      time: '10:00 AM',
      status: 'Absent',
      method: 'Manual',
      reason: 'Network Issue',
    ),
    AttendanceLog(
      id: 'log_4',
      customerName: 'Priya Sharma',
      phoneNumber: '+91 87654 32109',
      mealType: 'Lunch',
      time: '12:45 PM',
      status: 'Pending Approval',
      method: 'Manual',
      reason: 'QR Failed',
    ),
    AttendanceLog(
      id: 'log_5',
      customerName: 'Akash Patil',
      phoneNumber: '+91 99112 23344',
      mealType: 'Dinner',
      time: '07:44 PM',
      status: 'Present',
      method: 'QR',
    ),
    AttendanceLog(
      id: 'log_6',
      customerName: 'Shruti Joshi',
      phoneNumber: '+91 88334 45566',
      mealType: 'Breakfast',
      time: '08:32 AM',
      status: 'Present',
      method: 'QR',
    ),
    AttendanceLog(
      id: 'log_7',
      customerName: 'Rahul Deshmukh',
      phoneNumber: '+91 77445 56677',
      mealType: 'Lunch',
      time: '01:15 PM',
      status: 'Present',
      method: 'Manual',
      reason: 'Phone Camera Issue',
    ),
  ];

  // Filtering states
  String _searchQuery = '';
  String _selectedMealFilter = 'All'; // 'All', 'Breakfast', 'Lunch', 'Dinner'
  String _selectedStatusFilter = 'All'; // 'All', 'Present', 'Absent', 'Pending Approval'

  // Live progress counts matching the system spec examples
  int _breakfastActual = 44;
  int _breakfastExpected = 48;
  int _lunchActual = 42;
  int _lunchExpected = 46;
  int _dinnerActual = 31;
  int _dinnerExpected = 45;

  // Mock Confirmation Card state
  bool _showMockConfirmationCard = true;
  String _mockConfMeal = 'Dinner';
  String _mockConfReason = 'QR Failed';
  String _mockConfRequestedBy = 'Annapurna Mess';

  void _openManualAttendanceSheet() async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => const ManualAttendanceSheet(),
    );

    if (result != null) {
      setState(() {
        // Create a new log
        final newLog = AttendanceLog(
          id: 'log_${DateTime.now().millisecondsSinceEpoch}',
          customerName: result['customerName'],
          phoneNumber: result['phoneNumber'],
          mealType: result['mealType'],
          time: result['time'],
          status: result['status'],
          method: result['method'],
          reason: result['reason'],
        );

        _logs.insert(0, newLog);

        // Update counts appropriately
        if (result['mealType'] == 'Breakfast') {
          _breakfastExpected++;
        } else if (result['mealType'] == 'Lunch') {
          _lunchExpected++;
        } else if (result['mealType'] == 'Dinner') {
          _dinnerExpected++;
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Manual request created for ${result['customerName']} and sent for approval!'),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Today's total expectations
    final totalExpected = _breakfastExpected + _lunchExpected + _dinnerExpected;
    final totalActual = _breakfastActual + _lunchActual + _dinnerActual;
    final double attendancePercentage = totalExpected > 0 ? (totalActual / totalExpected) * 100 : 0.0;

    // Filtering logic
    final filteredLogs = _logs.where((log) {
      final matchesSearch = log.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          log.phoneNumber.contains(_searchQuery);
      
      final matchesMeal = _selectedMealFilter == 'All' || log.mealType == _selectedMealFilter;
      final matchesStatus = _selectedStatusFilter == 'All' || log.status == _selectedStatusFilter;

      return matchesSearch && matchesMeal && matchesStatus;
    }).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Attendance Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync_outlined),
            tooltip: 'Refresh',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Syncing latest QR logs...')),
              );
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // 1. TOP STATISTICS SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Daily Expectations',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Exp Breakfast',
                          value: '$_breakfastExpected',
                          icon: Icons.wb_twilight_outlined,
                          iconColor: Colors.orange,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Exp Lunch',
                          value: '$_lunchExpected',
                          icon: Icons.wb_sunny_outlined,
                          iconColor: Colors.blue,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Exp Dinner',
                          value: '$_dinnerExpected',
                          icon: Icons.nights_stay_outlined,
                          iconColor: Colors.indigo,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Attendance %',
                          value: '${attendancePercentage.toStringAsFixed(0)}%',
                          icon: Icons.percent_outlined,
                          iconColor: Colors.green,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 2. LIVE MEAL SUMMARY SECTION
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Live Meal Summaries',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 10),
                  MealAttendanceSummaryCard(
                    mealName: 'Breakfast',
                    actual: _breakfastActual,
                    expected: _breakfastExpected,
                    icon: Icons.wb_twilight_outlined,
                    timeRange: '07:00 AM - 10:00 AM',
                    themeColor: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  MealAttendanceSummaryCard(
                    mealName: 'Lunch',
                    actual: _lunchActual,
                    expected: _lunchExpected,
                    icon: Icons.wb_sunny_outlined,
                    timeRange: '12:00 PM - 03:00 PM',
                    themeColor: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  MealAttendanceSummaryCard(
                    mealName: 'Dinner',
                    actual: _dinnerActual,
                    expected: _dinnerExpected,
                    icon: Icons.nights_stay_outlined,
                    timeRange: '07:00 PM - 10:00 PM',
                    themeColor: Colors.indigo,
                  ),
                ],
              ),
            ),
          ),

          // 3. MOCK CUSTOMER APPROVAL PREVIEW SECTION (from requirements)
          if (_showMockConfirmationCard)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Customer Approval Preview',
                          style: textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '(Simulator Card)',
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.amber[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Card(
                      elevation: 0,
                      color: Colors.amber.withAlpha(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: Colors.amber.withAlpha(120),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.verified_user_outlined, color: Colors.amber[800], size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Attendance Confirmation',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber[900],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20, thickness: 0.5),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'MealType:',
                                        style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _mockConfMeal,
                                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Reason:',
                                        style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _mockConfReason,
                                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Requested By:',
                              style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _mockConfRequestedBy,
                              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _showMockConfirmationCard = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Verification Request Rejected'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.red,
                                  ),
                                  child: const Text('Reject'),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _showMockConfirmationCard = false;
                                      // Realize it under manual present logs
                                      _logs.insert(0, AttendanceLog(
                                        id: 'conf_log_1',
                                        customerName: 'Aman Saxena',
                                        phoneNumber: '+91 99881 12233',
                                        mealType: _mockConfMeal,
                                        time: 'Today (Approved)',
                                        status: 'Present',
                                        method: 'Manual',
                                        reason: _mockConfReason,
                                      ));

                                      if (_mockConfMeal == 'Dinner') {
                                        _dinnerActual++;
                                      } else if (_mockConfMeal == 'Breakfast') {
                                        _breakfastActual++;
                                      } else {
                                        _lunchActual++;
                                      }
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Verification Request Approved successfully!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Approve'),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // 4. SEARCH & SHARP FILTERS
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Search & Filtering Logs',
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search by Customer Name or Mobile...',
                      hintStyle: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant.withAlpha(150),
                      ),
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerLow,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: colorScheme.outlineVariant.withAlpha(120),
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  // Session Filter Row (Meal Type)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Meal: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        ...['All', 'Breakfast', 'Lunch', 'Dinner'].map((type) {
                          final isSelected = _selectedMealFilter == type;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: FilterChip(
                              label: Text(type, style: const TextStyle(fontSize: 11)),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedMealFilter = type;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Status Filter Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Text(
                          'Status: ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(width: 8),
                        ...['All', 'Present', 'Absent', 'Pending Approval'].map((status) {
                          final isSelected = _selectedStatusFilter == status;
                          return Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: FilterChip(
                              label: Text(status, style: const TextStyle(fontSize: 11)),
                              selected: isSelected,
                              onSelected: (_) {
                                setState(() {
                                  _selectedStatusFilter = status;
                                });
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Showing (${filteredLogs.length}) records',
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.filter_alt_off_outlined, size: 14),
                        label: const Text('Reset', style: TextStyle(fontSize: 11)),
                        onPressed: () {
                          setState(() {
                            _selectedMealFilter = 'All';
                            _selectedStatusFilter = 'All';
                            _searchQuery = '';
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 5. ATTENDANCE LOG LIST
          if (filteredLogs.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.search_off_outlined,
                        size: 48,
                        color: colorScheme.onSurfaceVariant.withAlpha(120),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'No matching records found',
                        style: textTheme.titleMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Try relaxing your search terms or filters',
                        textAlign: TextAlign.center,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant.withAlpha(180),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final log = filteredLogs[index];
                    return AttendanceRecordCard(
                      customerName: log.customerName,
                      phoneNumber: log.phoneNumber,
                      mealType: log.mealType,
                      time: log.time,
                      status: log.status,
                      method: log.method,
                      reason: log.reason,
                    );
                  },
                  childCount: filteredLogs.length,
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openManualAttendanceSheet,
        icon: const Icon(Icons.edit_note),
        label: const Text('Manual Entry'),
        tooltip: 'Mark Attendance Manually',
      ),
    );
  }
}
