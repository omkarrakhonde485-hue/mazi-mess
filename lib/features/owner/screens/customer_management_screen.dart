import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/dashboard_stat_card.dart';
import '../widgets/customer_card.dart';
import '../widgets/remove_customer_dialog.dart';

// Definition of the model expected by widgets
class MockCustomer {
  final String id;
  final String name;
  final String mobileNumber;
  final String currentPlan;
  final DateTime subscriptionExpiry;
  final String paymentStatus; // 'Paid', 'Pending', 'Overdue'
  final String todayAttendance; // 'Marked (BF)', 'Marked (Lunch)', 'Marked (BF & Lunch)', 'Not Marked', 'On Leave'
  final String status; // 'Active', 'On Leave', 'Expired'
  final String avatarUrl;
  final int age;
  final String gender;
  final String address;

  final String subscriptionDetails;
  final String attendanceSummary;
  final String paymentSummary;
  final String leaveSummary;

  MockCustomer({
    required this.id,
    required this.name,
    required this.mobileNumber,
    required this.currentPlan,
    required this.subscriptionExpiry,
    required this.paymentStatus,
    required this.todayAttendance,
    required this.status,
    required this.avatarUrl,
    required this.age,
    required this.gender,
    required this.address,
    required this.subscriptionDetails,
    required this.attendanceSummary,
    required this.paymentSummary,
    required this.leaveSummary,
  });

  // Helper copy method to mutate state
  MockCustomer copyWith({
    String? paymentStatus,
    String? todayAttendance,
    String? status,
    DateTime? subscriptionExpiry,
    String? subscriptionDetails,
    String? paymentSummary,
  }) {
    return MockCustomer(
      id: id,
      name: name,
      mobileNumber: mobileNumber,
      currentPlan: currentPlan,
      subscriptionExpiry: subscriptionExpiry ?? this.subscriptionExpiry,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      todayAttendance: todayAttendance ?? this.todayAttendance,
      status: status ?? this.status,
      avatarUrl: avatarUrl,
      age: age,
      gender: gender,
      address: address,
      subscriptionDetails: subscriptionDetails ?? this.subscriptionDetails,
      attendanceSummary: attendanceSummary,
      paymentSummary: paymentSummary ?? this.paymentSummary,
      leaveSummary: leaveSummary,
    );
  }
}

// Global list backing the mock data
final List<MockCustomer> globalCustomers = [
  MockCustomer(
    id: 'cust-1',
    name: 'Rohan Sharma',
    mobileNumber: '9876543210',
    currentPlan: 'Monthly Veg Premium',
    subscriptionExpiry: DateTime(2026, 7, 10),
    paymentStatus: 'Paid',
    todayAttendance: 'Marked (BF & Lunch)',
    status: 'Active',
    avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=150',
    age: 21,
    gender: 'Male',
    address: 'Room 304, Boys Hostel 2, COEP Tech University, Pune',
    subscriptionDetails: 'Monthly Veg Premium Plan (11 Jun 2026 - 10 Jul 2026)',
    attendanceSummary: '36/40 Meals Taken',
    paymentSummary: '₹3,000 paid via UPI on 11 Jun 2026',
    leaveSummary: '0 days taken / 2 planned',
  ),
  MockCustomer(
    id: 'cust-2',
    name: 'Sneha Patel',
    mobileNumber: '8765432109',
    currentPlan: 'Monthly Non-Veg Club',
    subscriptionExpiry: DateTime(2026, 6, 25), // Expiring soon
    paymentStatus: 'Pending',
    todayAttendance: 'Marked (Lunch)',
    status: 'Active',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    age: 22,
    gender: 'Female',
    address: 'Flat 402, Shanti Residency, Near COEP Campus, Pune',
    subscriptionDetails: 'Monthly Non-Veg Club (26 May 2026 - 25 Jun 2026)',
    attendanceSummary: '20/30 Meals Taken',
    paymentSummary: '₹3,500 pending admin verification',
    leaveSummary: '2 days taken / 2 approved',
  ),
  MockCustomer(
    id: 'cust-3',
    name: 'Aditya Patil',
    mobileNumber: '7654321098',
    currentPlan: 'Monthly Veg Deluxe',
    subscriptionExpiry: DateTime(2026, 6, 18), // Expired
    paymentStatus: 'Overdue',
    todayAttendance: 'Not Marked',
    status: 'Expired',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
    age: 20,
    gender: 'Male',
    address: 'Room 105, PG Royal Stay, Chinchwad, Pune',
    subscriptionDetails: 'Monthly Veg Deluxe (19 May 2026 - 18 Jun 2026)',
    attendanceSummary: '28/30 Meals Taken',
    paymentSummary: 'Outstanding fee of ₹2,800 is overdue',
    leaveSummary: '1 day taken / 1 planned',
  ),
  MockCustomer(
    id: 'cust-4',
    name: 'Tejas Deshmukh',
    mobileNumber: '9123456789',
    currentPlan: '15 Days Trial Veg',
    subscriptionExpiry: DateTime(2026, 7, 02),
    paymentStatus: 'Paid',
    todayAttendance: 'On Leave',
    status: 'On Leave',
    avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
    age: 23,
    gender: 'Male',
    address: 'Room 12, Sadanand PG, Shivajinagar, Pune',
    subscriptionDetails: '15 Days Trial Veg (18 Jun 2026 - 2 Jul 2026)',
    attendanceSummary: '1/15 Meals Taken',
    paymentSummary: '₹1,500 paid via Cash on 18 Jun 2026',
    leaveSummary: '2 days active leave (18 - 19 Jun)',
  ),
  MockCustomer(
    id: 'cust-5',
    name: 'Pranjal Joshi',
    mobileNumber: '9234567801',
    currentPlan: 'Monthly Veg Premium',
    subscriptionExpiry: DateTime(2026, 7, 15),
    paymentStatus: 'Paid',
    todayAttendance: 'Not Marked',
    status: 'Active',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=150',
    age: 21,
    gender: 'Female',
    address: 'Girls Hostel Block A, Fergusson College Road, Pune',
    subscriptionDetails: 'Monthly Veg Premium Plan (16 Jun 2026 - 15 Jul 2026)',
    attendanceSummary: '3/30 Meals Taken',
    paymentSummary: '₹3,000 paid via Card on 16 Jun 2026',
    leaveSummary: '0 days taken / 0 planned',
  ),
];

MockCustomer getMockCustomerById(String id) {
  return globalCustomers.firstWhere(
    (c) => c.id == id,
    orElse: () => fallbackMockCustomer,
  );
}

final fallbackMockCustomer = MockCustomer(
  id: 'cust-fallback',
  name: 'Guest Customer',
  mobileNumber: '9999999999',
  currentPlan: 'Basic Veg Plan',
  subscriptionExpiry: DateTime(2026, 6, 20),
  paymentStatus: 'Paid',
  todayAttendance: 'Not Marked',
  status: 'Active',
  avatarUrl: '',
  age: 20,
  gender: 'Male',
  address: 'Sarasbaug Area, Swargate, Pune',
  subscriptionDetails: 'Standard Trial Plan (15 Jun 2026 - 20 Jun 2026)',
  attendanceSummary: '4/5 meals completed',
  paymentSummary: 'Paid via Cash',
  leaveSummary: 'None',
);

class CustomerManagementScreen extends StatefulWidget {
  const CustomerManagementScreen({super.key});

  @override
  State<CustomerManagementScreen> createState() => _CustomerManagementScreenState();
}

class _CustomerManagementScreenState extends State<CustomerManagementScreen> {
  // Local mutable state copies
  late List<MockCustomer> _customers;
  String _searchQuery = '';
  String _activeFilter = 'All'; // 'All', 'Active', 'On Leave', 'Expired'

  @override
  void initState() {
    super.initState();
    _customers = List.from(globalCustomers);
  }

  // Calculated Statistics values
  int get _totalCount => _customers.length;
  int get _activeCount => _customers.where((c) => c.status == 'Active').length;
  int get _onLeaveCount => _customers.where((c) => c.status == 'On Leave').length;
  int get _expiringSoonCount {
    final now = DateTime.now();
    // Count customers whose sub expires in 7 days and is not already expired
    return _customers.where((c) {
      if (c.status == 'Expired') return false;
      final difference = c.subscriptionExpiry.difference(now).inDays;
      return difference >= 0 && difference <= 7;
    }).length;
  }

  // Filtered customer list
  List<MockCustomer> get _filteredCustomers {
    return _customers.where((customer) {
      // 1. Filter by tabs
      if (_activeFilter == 'Active' && customer.status != 'Active') {
        return false;
      }
      if (_activeFilter == 'On Leave' && customer.status != 'On Leave') {
        return false;
      }
      if (_activeFilter == 'Expired' && customer.status != 'Expired') {
        return false;
      }

      // 2. Filter by search query
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final nameMatch = customer.name.toLowerCase().contains(query);
        final phoneMatch = customer.mobileNumber.contains(query);
        return nameMatch || phoneMatch;
      }

      return true;
    }).toList();
  }

  // Action methods
  void _renewSubscription(MockCustomer customer) {
    setState(() {
      final index = _customers.indexWhere((c) => c.id == customer.id);
      if (index != -1) {
        final extendedDate = _customers[index].subscriptionExpiry.add(const Duration(days: 30));
        _customers[index] = _customers[index].copyWith(
          subscriptionExpiry: extendedDate,
          status: 'Active',
          subscriptionDetails: 'Monthly Plan Renewed (Extended for 30 Days to ${extendedDate.day}/${extendedDate.month}/${extendedDate.year})',
        );
        // Keep global reference updated
        final globalIndex = globalCustomers.indexWhere((c) => c.id == customer.id);
        if (globalIndex != -1) {
          globalCustomers[globalIndex] = _customers[index];
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscription extended for 30 days for ${customer.name}'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  void _markPayment(MockCustomer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Text('Mark Payment: ${customer.name}'),
          children: [
            SimpleDialogOption(
              onPressed: () {
                _updatePaymentStatus(customer.id, 'Paid', 'Cash');
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.money, color: Colors.green),
                title: Text('Paid via Cash'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                _updatePaymentStatus(customer.id, 'Paid', 'UPI');
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.qr_code, color: Colors.blue),
                title: Text('Paid via UPI'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                _updatePaymentStatus(customer.id, 'Paid', 'Card');
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.credit_card, color: Colors.purple),
                title: Text('Paid via Card'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                _updatePaymentStatus(customer.id, 'Pending', 'Awaiting Confirm');
                Navigator.pop(context);
              },
              child: const ListTile(
                leading: Icon(Icons.history, color: Colors.orange),
                title: Text('Set as Pending'),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updatePaymentStatus(String customerId, String newStatus, String method) {
    setState(() {
      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        _customers[index] = _customers[index].copyWith(
          paymentStatus: newStatus,
          paymentSummary: '₹3,000 paid via $method on ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
        );
        // Update global backing copy too
        final globalIndex = globalCustomers.indexWhere((c) => c.id == customerId);
        if (globalIndex != -1) {
          globalCustomers[globalIndex] = _customers[index];
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment status updated to $newStatus via $method'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _removeCustomer(MockCustomer customer) {
    showDialog(
      context: context,
      builder: (context) {
        return RemoveCustomerDialog(
          customerName: customer.name,
          onRemove: (reason) {
            setState(() {
              _customers.removeWhere((c) => c.id == customer.id);
              globalCustomers.removeWhere((c) => c.id == customer.id);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Removed ${customer.name} (Reason: $reason)'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Directory'),
        actions: [
          IconButton(
            tooltip: 'Add Customer',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Manual Add Customer flow coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            icon: const Icon(Icons.person_add_outlined),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 1. TOP STATS PREVIEW MATRIX
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Total Customers',
                          value: '$_totalCount',
                          icon: Icons.people_outline,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Active Accounts',
                          value: '$_activeCount',
                          icon: Icons.check_circle_outline,
                          iconColor: Colors.green,
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
                          title: 'On Leave Mode',
                          value: '$_onLeaveCount',
                          icon: Icons.time_to_leave,
                          iconColor: Colors.amber,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: DashboardStatCard(
                          title: 'Expiring Soon',
                          value: '$_expiringSoonCount',
                          icon: Icons.warning_amber,
                          iconColor: Colors.orange,
                          backgroundColor: colorScheme.surfaceContainerLow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. SEARCH BAR
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: WidgetStatePropertyAll(colorScheme.surfaceContainerHigh),
                hintText: 'Search by Name or Mobile No...',
                leading: const Icon(Icons.search, size: 20),
                trailing: _searchQuery.isNotEmpty
                    ? [
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            setState(() {
                              _searchQuery = '';
                            });
                          },
                        ),
                      ]
                    : null,
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

            // 3. HORIZONTAL FILTERS CHIPS
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    _buildFilterChip('All'),
                    _buildFilterChip('Active'),
                    _buildFilterChip('On Leave'),
                    _buildFilterChip('Expired'),
                  ],
                ),
              ),
            ),

            // 4. CUSTOMERS DIRECTORY LIST
            Expanded(
              child: _filteredCustomers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.group_off_outlined,
                            size: 48,
                            color: colorScheme.onSurfaceVariant.withAlpha(120),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Customers Found',
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _searchQuery.isNotEmpty
                                ? 'Try refining your search keyword'
                                : 'No customers exist in this category',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: _filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = _filteredCustomers[index];
                        return CustomerCard(
                          customer: customer,
                          onViewProfile: () {
                            // Route directly using router state or context push
                            context.push('/owner-dashboard/customers/${customer.id}');
                          },
                          onRenewSubscription: () => _renewSubscription(customer),
                          onMarkPayment: () => _markPayment(customer),
                          onRemoveCustomer: () => _removeCustomer(customer),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String filterName) {
    final theme = Theme.of(context);
    final isSelected = _activeFilter == filterName;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: isSelected,
        label: Text(filterName),
        onSelected: (selected) {
          setState(() {
            _activeFilter = filterName;
          });
        },
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return '';
  }
}
