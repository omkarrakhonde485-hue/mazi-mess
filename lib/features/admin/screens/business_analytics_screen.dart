import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../models/business_analytics_model.dart';
import '../widgets/business_stat_card.dart';
import '../widgets/owner_subscription_card.dart';
import '../widgets/analytics_placeholder_card.dart';

class BusinessAnalyticsScreen extends StatefulWidget {
  const BusinessAnalyticsScreen({super.key});

  @override
  State<BusinessAnalyticsScreen> createState() => _BusinessAnalyticsScreenState();
}

class _BusinessAnalyticsScreenState extends State<BusinessAnalyticsScreen> {
  // Main State for Subscription Records
  late List<OwnerSubscription> _subscriptions;

  // Search and Filter State
  String _searchQuery = '';
  String _selectedFilter = 'All';

  // Platform Metrics State (initialized with requested mock values)
  double _monthlyRevenue = 18450;
  double _yearlyRevenue = 221400;
  double _mrr = 19960;
  double _arr = 239520;
  int _activeSubscriptions = 42;
  int _expiringThisMonth = 7;
  int _expiredSubscriptions = 3;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  void _initializeMockData() {
    _subscriptions = [
      OwnerSubscription(
        id: 'SUB-101',
        ownerName: 'Rahul Patil',
        messName: 'Annapurna Mess',
        planName: 'Premium',
        billingCycle: BillingCycle.monthly,
        amountPaid: 499,
        paymentDate: DateTime.now().subtract(const Duration(days: 3)),
        expiryDate: DateTime.now().add(const Duration(days: 27)),
        status: OwnerSubscriptionStatus.active,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 3)),
            plan: 'Premium (Monthly)',
            amount: 499,
            status: 'Success',
          ),
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 33)),
            plan: 'Premium (Monthly)',
            amount: 499,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-102',
        ownerName: 'Neha Deshmukh',
        messName: 'Mauli Mess & Tiffin',
        planName: 'Basic',
        billingCycle: BillingCycle.monthly,
        amountPaid: 299,
        paymentDate: DateTime.now().subtract(const Duration(days: 28)),
        expiryDate: DateTime.now().add(const Duration(days: 2)),
        status: OwnerSubscriptionStatus.expiringSoon,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 28)),
            plan: 'Basic (Monthly)',
            amount: 299,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-103',
        ownerName: 'Sanjay Shinde',
        messName: 'Swad Mess',
        planName: 'Enterprise',
        billingCycle: BillingCycle.yearly,
        amountPaid: 4999,
        paymentDate: DateTime.now().subtract(const Duration(days: 360)),
        expiryDate: DateTime.now().subtract(const Duration(days: 5)),
        status: OwnerSubscriptionStatus.expired,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 360)),
            plan: 'Enterprise (Yearly)',
            amount: 4999,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-104',
        ownerName: 'Amit Sharma',
        messName: 'Gharkul Bhojanalay',
        planName: 'Enterprise',
        billingCycle: BillingCycle.yearly,
        amountPaid: 4999,
        paymentDate: DateTime.now().subtract(const Duration(days: 15)),
        expiryDate: DateTime.now().add(const Duration(days: 350)),
        status: OwnerSubscriptionStatus.active,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 15)),
            plan: 'Enterprise (Yearly)',
            amount: 4999,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-105',
        ownerName: 'Priya Joshi',
        messName: 'Chaitanya Mess',
        planName: 'Premium',
        billingCycle: BillingCycle.monthly,
        amountPaid: 499,
        paymentDate: DateTime.now().subtract(const Duration(days: 26)),
        expiryDate: DateTime.now().add(const Duration(days: 4)),
        status: OwnerSubscriptionStatus.expiringSoon,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 26)),
            plan: 'Premium (Monthly)',
            amount: 499,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-106',
        ownerName: 'Vikram Singh',
        messName: 'Rajput Bhoj',
        planName: 'Premium',
        billingCycle: BillingCycle.monthly,
        amountPaid: 499,
        paymentDate: DateTime.now().subtract(const Duration(days: 45)),
        expiryDate: DateTime.now().subtract(const Duration(days: 15)),
        status: OwnerSubscriptionStatus.expired,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 45)),
            plan: 'Premium (Monthly)',
            amount: 499,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-107',
        ownerName: 'Anil Mehta',
        messName: 'Taste of Home Mess',
        planName: 'Premium',
        billingCycle: BillingCycle.yearly,
        amountPaid: 4999,
        paymentDate: DateTime.now().subtract(const Duration(days: 100)),
        expiryDate: DateTime.now().add(const Duration(days: 265)),
        status: OwnerSubscriptionStatus.active,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 100)),
            plan: 'Premium (Yearly)',
            amount: 4999,
            status: 'Success',
          ),
        ],
      ),
      OwnerSubscription(
        id: 'SUB-108',
        ownerName: 'Sunita Rao',
        messName: 'Sai Suman Mess',
        planName: 'Basic',
        billingCycle: BillingCycle.monthly,
        amountPaid: 299,
        paymentDate: DateTime.now().subtract(const Duration(days: 12)),
        expiryDate: DateTime.now().add(const Duration(days: 18)),
        status: OwnerSubscriptionStatus.active,
        paymentHistory: [
          OwnerSubscriptionPayment(
            paymentDate: DateTime.now().subtract(const Duration(days: 12)),
            plan: 'Basic (Monthly)',
            amount: 299,
            status: 'Success',
          ),
        ],
      ),
    ];
  }

  // Filter & Search computation
  List<OwnerSubscription> get _filteredSubscriptions {
    return _subscriptions.where((sub) {
      final query = _searchQuery.toLowerCase().trim();
      final matchesSearch = sub.ownerName.toLowerCase().contains(query) ||
          sub.messName.toLowerCase().contains(query) ||
          sub.planName.toLowerCase().contains(query);

      if (!matchesSearch) return false;

      return switch (_selectedFilter) {
        'All' => true,
        'Active' => sub.status == OwnerSubscriptionStatus.active,
        'Expiring Soon' => sub.status == OwnerSubscriptionStatus.expiringSoon,
        'Expired' => sub.status == OwnerSubscriptionStatus.expired,
        'Monthly Plan' => sub.billingCycle == BillingCycle.monthly,
        'Yearly Plan' => sub.billingCycle == BillingCycle.yearly,
        _ => true,
      };
    }).toList();
  }

  // Handle Dynamic Renewal Actions in state
  void _executeRenewal(OwnerSubscription record, BillingCycle cycle, double amount) {
    setState(() {
      final index = _subscriptions.indexWhere((s) => s.id == record.id);
      if (index == -1) return;

      final previousStatus = record.status;

      // Update Dates
      final paymentDate = DateTime.now();
      final expiryDate = cycle == BillingCycle.monthly
          ? paymentDate.add(const Duration(days: 30))
          : paymentDate.add(const Duration(days: 365));

      final updatedPaymentHistory = [
        OwnerSubscriptionPayment(
          paymentDate: paymentDate,
          plan: '${record.planName} (${cycle.label})',
          amount: amount,
          status: 'Success',
        ),
        ...record.paymentHistory,
      ];

      final updated = record.copyWith(
        billingCycle: cycle,
        amountPaid: amount,
        paymentDate: paymentDate,
        expiryDate: expiryDate,
        status: OwnerSubscriptionStatus.active,
        paymentHistory: updatedPaymentHistory,
      );

      _subscriptions[index] = updated;

      // Recalculate dashboard analytics
      _monthlyRevenue += amount;
      _yearlyRevenue += amount;

      if (cycle == BillingCycle.monthly) {
        _mrr += amount;
      } else {
        _mrr += (amount / 12);
      }
      _arr = _mrr * 12;

      if (previousStatus == OwnerSubscriptionStatus.expired) {
        if (_expiredSubscriptions > 0) _expiredSubscriptions--;
        _activeSubscriptions++;
      } else if (previousStatus == OwnerSubscriptionStatus.expiringSoon) {
        if (_expiringThisMonth > 0) _expiringThisMonth--;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully renewed ${record.ownerName}\'s subscription!'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green.shade800,
      ),
    );
  }

  // Mark as Renewed directly (using standard plan info)
  void _executeMarkAsRenewed(OwnerSubscription record) {
    final amount = record.billingCycle == BillingCycle.monthly ? 499.0 : 4999.0;
    _executeRenewal(record, record.billingCycle, amount);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _initializeMockData();
                _monthlyRevenue = 18450;
                _yearlyRevenue = 221400;
                _mrr = 19960;
                _arr = 239520;
                _activeSubscriptions = 42;
                _expiringThisMonth = 7;
                _expiredSubscriptions = 3;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Mock analytics data reset successfully.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. PAGE TITLE & SUBTITLE
              Text(
                'Mazi Mess Subscription Dashboard',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Monitor subscription revenues, plans and owner accounts.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 24),

              // 2. TOP BUSINESS METRICS GRID
              LayoutBuilder(
                builder: (context, constraints) {
                  final width = constraints.maxWidth;
                  int crossAxisCount = 1;
                  if (width > 900) {
                    crossAxisCount = 4;
                  } else if (width > 600) {
                    crossAxisCount = 2;
                  }
                  return GridView.count(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: crossAxisCount == 1 ? 2.5 : 1.5,
                    children: [
                      BusinessStatCard(
                        title: 'Monthly Revenue',
                        value: '₹${_monthlyRevenue.toStringAsFixed(0)}',
                        icon: Icons.currency_rupee_rounded,
                        subtitle: 'Earnings this month',
                        iconColor: Colors.green.shade800,
                        iconBgColor: Colors.green.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Yearly Revenue',
                        value: '₹${_yearlyRevenue.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet_rounded,
                        subtitle: 'Cumulative earnings',
                        iconColor: Colors.blue.shade800,
                        iconBgColor: Colors.blue.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Monthly Recurring (MRR)',
                        value: '₹${_mrr.toStringAsFixed(0)}',
                        icon: Icons.repeat_rounded,
                        subtitle: 'Normalized monthly goal',
                        iconColor: Colors.purple.shade800,
                        iconBgColor: Colors.purple.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Annual Recurring (ARR)',
                        value: '₹${_arr.toStringAsFixed(0)}',
                        icon: Icons.analytics_rounded,
                        subtitle: 'ARR run rate',
                        iconColor: Colors.teal.shade800,
                        iconBgColor: Colors.teal.shade50,
                      ),
                      BusinessStatCard(
                        title: 'ARPO',
                        value: '₹475 / Owner',
                        icon: Icons.group_work_rounded,
                        subtitle: 'Avg revenue per owner',
                        iconColor: Colors.indigo.shade800,
                        iconBgColor: Colors.indigo.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Active Owners',
                        value: '$_activeSubscriptions',
                        icon: Icons.people_outline_rounded,
                        subtitle: 'Paid active accounts',
                        iconColor: Colors.green.shade800,
                        iconBgColor: Colors.green.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Expiring This Month',
                        value: '$_expiringThisMonth',
                        icon: Icons.warning_amber_rounded,
                        subtitle: 'Action required soon',
                        iconColor: Colors.orange.shade800,
                        iconBgColor: Colors.orange.shade50,
                      ),
                      BusinessStatCard(
                        title: 'Expired Subscriptions',
                        value: '$_expiredSubscriptions',
                        icon: Icons.cancel_outlined,
                        subtitle: 'Overdue renewal accounts',
                        iconColor: colorScheme.error,
                        iconBgColor: colorScheme.errorContainer.withValues(alpha: 0.15),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),

              // 3. ANALYTICS VISUALIZER CHARTS (REVENUE TREND & DISTRIBUTION)
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 800;
                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: const AnalyticsPlaceholderCard(
                            title: 'Revenue Trend',
                            subtitle: 'Monthly platform revenue for the last 12 months.',
                            badgeText: 'Live Trend',
                            isChartPlaceholder: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: const AnalyticsPlaceholderCard(
                            title: 'Subscription Distribution',
                            subtitle: 'Billing cycle plan distribution.',
                            badgeText: 'Active plans',
                            subscriptionDistributionData: {
                              'Monthly Plans': 30,
                              'Yearly Plans': 12,
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        const AnalyticsPlaceholderCard(
                          title: 'Revenue Trend',
                          subtitle: 'Monthly platform revenue for the last 12 months.',
                          badgeText: 'Live Trend',
                          isChartPlaceholder: true,
                        ),
                        const SizedBox(height: 16),
                        const AnalyticsPlaceholderCard(
                          title: 'Subscription Distribution',
                          subtitle: 'Billing cycle plan distribution.',
                          badgeText: 'Active plans',
                          subscriptionDistributionData: {
                            'Monthly Plans': 30,
                            'Yearly Plans': 12,
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // 4. BUSINESS INSIGHTS
              Text(
                'Business Insights',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildInsightsSection(context),
              const SizedBox(height: 24),

              // 5. SEARCH & FILTERS
              Text(
                'Owner Subscription Records',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              _buildSearchAndFilters(context),
              const SizedBox(height: 16),

              // 6. SUBSCRIBER LIST
              _buildSubscriptionsList(context),
            ],
          ),
        ),
      ),
    );
  }

  // Visual insights section rendering 4 clean columns/grid
  Widget _buildInsightsSection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final insights = [
      (
        'Highest Paying Owner',
        'Amit Sharma',
        '₹4,999 (Enterprise Plan)',
        Icons.star_rounded,
        Colors.amber.shade700
      ),
      (
        'Recently Renewed',
        'Anil Mehta',
        'Yearly Plan active',
        Icons.done_all_rounded,
        Colors.green.shade700
      ),
      (
        'Next Subscription Expiring',
        'Neha Deshmukh',
        'In 2 days (Basic Monthly)',
        Icons.hourglass_bottom_rounded,
        Colors.orange.shade700
      ),
      (
        'Avg Revenue per Owner',
        '₹475 / month',
        'Goal target ₹500',
        Icons.trending_up_rounded,
        Colors.blue.shade700
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 4 : (constraints.maxWidth > 500 ? 2 : 1);
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: insights.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 85,
          ),
          itemBuilder: (context, index) {
            final (title, value, desc, icon, color) = insights[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 20, color: color),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          value,
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          desc,
                          style: textTheme.bodySmall?.copyWith(
                            fontSize: 10,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  // Search input and Filter Chip row implementation
  Widget _buildSearchAndFilters(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final chips = [
      'All',
      'Active',
      'Expiring Soon',
      'Expired',
      'Monthly Plan',
      'Yearly Plan'
    ];

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Search by owner, mess, or plan name...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
            filled: true,
            fillColor: colorScheme.surfaceContainerHigh.withValues(alpha: 0.5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.7)),
            ),
          ),
          onChanged: (val) {
            setState(() {
              _searchQuery = val;
            });
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: chips.length,
            itemBuilder: (context, index) {
              final chipName = chips[index];
              final isSelected = _selectedFilter == chipName;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: FilterChip(
                  label: Text(chipName),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      _selectedFilter = chipName;
                    });
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  visualDensity: VisualDensity.compact,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Render lists of subscriptions
  Widget _buildSubscriptionsList(BuildContext context) {
    final filtered = _filteredSubscriptions;

    if (filtered.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off_rounded,
                size: 48,
                color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 12),
              Text(
                'No matching owner subscriptions found',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 4),
              const Text('Try adjusting your filters or search query.'),
            ],
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final useGrid = constraints.maxWidth > 750;
        if (useGrid) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 220,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final record = filtered[index];
              return OwnerSubscriptionCard(
                record: record,
                onViewDetails: () => _showDetailsDialog(record),
                onRenew: () => _showRenewDialog(record),
                onMarkAsRenewed: () => _showMarkAsRenewedDialog(record),
                onViewPaymentHistory: () => _showPaymentHistoryDialog(record),
              );
            },
          );
        } else {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: filtered.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final record = filtered[index];
              return OwnerSubscriptionCard(
                record: record,
                onViewDetails: () => _showDetailsDialog(record),
                onRenew: () => _showRenewDialog(record),
                onMarkAsRenewed: () => _showMarkAsRenewedDialog(record),
                onViewPaymentHistory: () => _showPaymentHistoryDialog(record),
              );
            },
          );
        }
      },
    );
  }

  // Dialogue 1: VIEW DETAILS DIALOG
  void _showDetailsDialog(OwnerSubscription record) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
                child: Text(record.ownerName[0].toUpperCase()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.ownerName,
                      style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      record.messName,
                      style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Divider(),
                  const SizedBox(height: 8),
                  _buildDetailRow('Owner Name', record.ownerName),
                  _buildDetailRow('Mess Name', record.messName),
                  _buildDetailRow('Subscription Plan', record.planName),
                  _buildDetailRow('Billing Cycle', record.billingCycle.label),
                  _buildDetailRow('Amount Paid', '₹${record.amountPaid.toStringAsFixed(0)}'),
                  _buildDetailRow('Payment Date', _formatDate(record.paymentDate)),
                  _buildDetailRow('Expiry Date', _formatDate(record.expiryDate)),
                  _buildDetailRow('Days Remaining', '${record.daysRemaining} days'),
                  _buildDetailRow('Current Status', record.status.label, isStatus: true, status: record.status),
                  const SizedBox(height: 16),
                  Text(
                    'Renewal History',
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (record.paymentHistory.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No previous renewal history available.'),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: record.paymentHistory.length,
                      itemBuilder: (context, i) {
                        final pay = record.paymentHistory[i];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    pay.plan,
                                    style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    _formatDate(pay.paymentDate),
                                    style: textTheme.bodySmall?.copyWith(fontSize: 10, color: colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '₹${pay.amount.toStringAsFixed(0)}',
                                    style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade50,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      pay.status,
                                      style: TextStyle(fontSize: 9, color: Colors.green.shade800, fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Dialogue 2: RENEW SUBSCRIPTION DIALOG
  void _showRenewDialog(OwnerSubscription record) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    BillingCycle selectedCycle = record.billingCycle;
    double amount = selectedCycle == BillingCycle.monthly ? 499.0 : 4999.0;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.autorenew_rounded, color: Colors.blue),
                  const SizedBox(width: 8),
                  const Text('Renew Subscription'),
                ],
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select a billing cycle for ${record.ownerName} (${record.messName}):',
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<BillingCycle>(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Monthly Plan'),
                        Text(
                          '₹499 / mo',
                          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    value: BillingCycle.monthly,
                    groupValue: selectedCycle,
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedCycle = val;
                          amount = 499.0;
                        });
                      }
                    },
                  ),
                  RadioListTile<BillingCycle>(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Yearly Plan'),
                        Text(
                          '₹4,999 / yr',
                          style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    value: BillingCycle.yearly,
                    groupValue: selectedCycle,
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() {
                          selectedCycle = val;
                          amount = 4999.0;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Due:',
                        style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹${amount.toStringAsFixed(0)}',
                        style: textTheme.titleMedium?.copyWith(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _executeRenewal(record, selectedCycle, amount);
                  },
                  child: const Text('Confirm Renewal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialogue 3: MARK AS RENEWED DIALOG
  void _showMarkAsRenewedDialog(OwnerSubscription record) {
    final textTheme = Theme.of(context).textTheme;

    final defaultAmount = record.billingCycle == BillingCycle.monthly ? 499.0 : 4999.0;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Colors.green),
              const SizedBox(width: 8),
              const Text('Confirm Platform Renewal'),
            ],
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Are you sure you want to mark ${record.ownerName}\'s subscription as manually renewed?',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mess: ${record.messName}', style: textTheme.bodySmall),
                    Text('Renewal Plan: ${record.planName} (${record.billingCycle.label})', style: textTheme.bodySmall),
                    Text('Amount Credit: ₹${defaultAmount.toStringAsFixed(0)}', style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This will reset the expiry days, update the subscription status to Active, and add a successful log entry in the database.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _executeMarkAsRenewed(record);
              },
              child: const Text('Confirm Renewal'),
            ),
          ],
        );
      },
    );
  }

  // Dialogue 4: PAYMENT HISTORY DIALOG
  void _showPaymentHistoryDialog(OwnerSubscription record) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.history_rounded, color: Colors.purple),
              const SizedBox(width: 8),
              const Text('Payment History'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: record.paymentHistory.isEmpty
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: Text('No payment logs recorded yet.'),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: record.paymentHistory.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final item = record.paymentHistory[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.plan,
                                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatDate(item.paymentDate),
                                  style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${item.amount.toStringAsFixed(0)}',
                                  style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    item.status,
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false, OwnerSubscriptionStatus? status}) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    Widget valueWidget;
    if (isStatus && status != null) {
      final (statusColor, statusBg, _) = switch (status) {
        OwnerSubscriptionStatus.active => (Colors.green.shade800, Colors.green.shade50, Icons.check),
        OwnerSubscriptionStatus.expiringSoon => (Colors.orange.shade800, Colors.orange.shade50, Icons.warning),
        OwnerSubscriptionStatus.expired => (colorScheme.error, colorScheme.errorContainer.withValues(alpha: 0.15), Icons.error),
      };

      valueWidget = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusBg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          value,
          style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
        ),
      );
    } else {
      valueWidget = Text(
        value,
        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
        textAlign: TextAlign.end,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(width: 16),
          Flexible(child: valueWidget),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
