import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../models/admin_alert.dart';
import '../../../models/dashboard_stat.dart';
import '../widgets/admin_alert_card.dart';
import '../widgets/admin_quick_action_tile.dart';
import '../widgets/admin_stat_card.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  // Stat values stored in state for fully interactive real-time updates!
  int _totalCustomers = 1420;
  int _totalOwners = 154;
  int _totalMesses = 210;

  int _pendingOwners = 5;
  int _pendingMesses = 8;
  int _suspendedOwners = 2;

  int _paymentFailures = 4;
  int _webhookFailures = 1;
  int _activeMakeIntegrations = 12;

  int _monthlyRevenue = 345200;
  int _activeOwnerSubscriptions = 128;
  int _expiringOwnerSubscriptions = 14;

  // Webhook URLs & Maintenance state
  bool _maintenanceMode = false;
  bool _autoVerifyFssai = false;
  String _rateLimit = '120';
  String _makeWebhookUrl = 'https://hook.us1.make.com/xyz123abc789';

  // Alerts stored in state
  late List<AdminAlert> _alerts;

  // Mock pending owners list for dialogs
  final List<Map<String, String>> _mockPendingOwners = [
    {
      'id': 'owner_1',
      'name': 'Manoj Kumar',
      'email': 'manoj.kumar@gmail.com',
      'messName': 'Swami Mess',
      'date': '10m ago',
    },
    {
      'id': 'owner_2',
      'name': 'Rajesh Patil',
      'email': 'rajesh.patil@outlook.com',
      'messName': 'Gurukrupa Annex',
      'date': '2h ago',
    },
  ];

  // Mock pending messes list for dialogs
  final List<Map<String, String>> _mockPendingMesses = [
    {
      'id': 'mess_1',
      'name': 'Swami Mess Branch 2',
      'ownerName': 'Manoj Kumar',
      'location': 'Deccan, Pune',
      'date': '45m ago',
    },
    {
      'id': 'mess_2',
      'name': 'Annapurna Central Kitchen',
      'ownerName': 'Kedar Deshpande',
      'location': 'Kothrud, Pune',
      'date': '3h ago',
    },
  ];

  // Mock payment verification list
  final List<Map<String, String>> _mockPendingPayments = [
    {
      'id': 'pay_1',
      'txnId': 'TXN9872412',
      'customer': 'Amit Sharma',
      'amount': '₹4,200',
      'date': '5h ago',
      'reason': 'Invalid UPI reference number',
    },
    {
      'id': 'pay_2',
      'txnId': 'TXN9872415',
      'customer': 'Neha Patil',
      'amount': '₹3,500',
      'date': '8h ago',
      'reason': 'Bank server timed out',
    },
  ];

  @override
  void initState() {
    super.initState();
    _alerts = [
      AdminAlert(
        id: 'a1',
        title: 'Owner Verification Pending',
        description: 'Manoj Kumar (Swami Mess) uploaded business registration and PAN card for approval.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
        severity: AlertSeverity.warning,
      ),
      AdminAlert(
        id: 'a2',
        title: 'Mess Verification Pending',
        description: 'Annapurna mess central kitchen submitted certificate of registration.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        severity: AlertSeverity.info,
      ),
      AdminAlert(
        id: 'a3',
        title: 'Webhook Failure',
        description: 'Failed to dispatch event invoice.payment_failed to endpoint /webhooks/stripe.',
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        severity: AlertSeverity.critical,
      ),
      AdminAlert(
        id: 'a4',
        title: 'Owner Subscription Expiring',
        description: "Owner Sunil Joshi's 'Premium Tier' subscription is expiring in 2 days.",
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        severity: AlertSeverity.warning,
      ),
      AdminAlert(
        id: 'a5',
        title: 'Payment Verification Failed',
        description: 'Transaction ID TXN9872412 for ₹4,200 rejected due to invalid reference.',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        severity: AlertSeverity.critical,
      ),
    ];
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.error_outline,
              color: isSuccess ? Colors.green.shade100 : Colors.red.shade100,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // 1. Owner Verification Callback
  void _openOwnerVerification() {
    context.push(AppRoute.adminOwnerVerification.path);
  }

  // 2. Mess Approval Callback
  void _openMessApproval() {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.restaurant_outlined, color: Colors.orange.shade800),
                  const SizedBox(width: 8),
                  const Text('Mess Approvals'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: _mockPendingMesses.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('No pending mess approvals'),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _mockPendingMesses.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final mess = _mockPendingMesses[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        mess['name']!,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      mess['date']!,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Owner: ${mess['ownerName']}'),
                                Text('Location: ${mess['location']}'),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          _mockPendingMesses.removeAt(index);
                                        });
                                        setState(() {
                                          if (_pendingMesses > 0) _pendingMesses--;
                                        });
                                        Navigator.pop(context);
                                        _showSnackBar('Mess application declined.', isSuccess: false);
                                      },
                                      child: Text(
                                        'Decline',
                                        style: TextStyle(color: colorScheme.error),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          _mockPendingMesses.removeAt(index);
                                        });
                                        setState(() {
                                          if (_pendingMesses > 0) _pendingMesses--;
                                          _totalMesses++;
                                        });
                                        Navigator.pop(context);
                                        _showSnackBar('Mess outlet approved and live!');
                                      },
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(80, 36),
                                      ),
                                      child: const Text('Approve'),
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
      },
    );
  }

  // 3. Payment Monitoring Callback
  void _openPaymentMonitoring() {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.payment_outlined, color: Colors.green.shade800),
                  const SizedBox(width: 8),
                  const Text('Payment Monitoring'),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: _mockPendingPayments.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 24),
                          child: Text('All payment failures resolved'),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: _mockPendingPayments.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final payment = _mockPendingPayments[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      payment['txnId']!,
                                      style: textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                    Text(
                                      payment['date']!,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text('Customer: ${payment['customer']}'),
                                Text('Amount: ${payment['amount']}'),
                                Text(
                                  'Issue: ${payment['reason']}',
                                  style: TextStyle(
                                    color: colorScheme.error,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          _mockPendingPayments.removeAt(index);
                                        });
                                        setState(() {
                                          if (_paymentFailures > 0) _paymentFailures--;
                                        });
                                        Navigator.pop(context);
                                        _showSnackBar('Declined verification attempt.', isSuccess: false);
                                      },
                                      child: Text(
                                        'Decline',
                                        style: TextStyle(color: colorScheme.error),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    FilledButton(
                                      onPressed: () {
                                        setDialogState(() {
                                          _mockPendingPayments.removeAt(index);
                                        });
                                        setState(() {
                                          if (_paymentFailures > 0) _paymentFailures--;
                                          _monthlyRevenue += 4200; // Increase revenue
                                        });
                                        Navigator.pop(context);
                                        _showSnackBar('Payment manually verified & resolved!');
                                      },
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size(80, 36),
                                      ),
                                      child: const Text('Verify & Credit'),
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
      },
    );
  }

  // 4. Webhook Monitoring Callback
  void _openWebhookMonitoring() {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.sync_problem_rounded, color: colorScheme.error),
              const SizedBox(width: 8),
              const Text('Webhook Pipeline'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recent Webhook Status',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildWebhookLogTile(
                context,
                endpoint: '/webhooks/stripe',
                event: 'invoice.payment_failed',
                status: '500 Internal Server Error',
                time: '1h ago',
                isError: true,
              ),
              _buildWebhookLogTile(
                context,
                endpoint: '/webhooks/make-crm',
                event: 'owner.created',
                status: '200 OK',
                time: '15m ago',
                isError: false,
              ),
              const SizedBox(height: 16),
              Card(
                color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bolt, color: colorScheme.primary, size: 18),
                          const SizedBox(width: 4),
                          const Text(
                            'Active Make.com Route',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _makeWebhookUrl,
                        style: textTheme.bodySmall?.copyWith(fontFamily: 'Courier'),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _webhookFailures = 0;
                });
                Navigator.pop(context);
                _showSnackBar('Webhook queue flushed & re-delivered successfully!');
              },
              child: const Text('Re-deliver Failed'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                _showSnackBar('Test payload dispatched to Make.com pipeline!');
              },
              child: const Text('Send Test Payload'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWebhookLogTile(
    BuildContext context, {
    required String endpoint,
    required String event,
    required String status,
    required String time,
    required bool isError,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isError ? Colors.red.withOpacity(0.05) : Colors.green.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError ? Colors.red.withOpacity(0.2) : Colors.green.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isError ? Icons.error_outline : Icons.check_circle_outline,
            color: isError ? colorScheme.error : Colors.green,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$endpoint ($event)',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                Text(
                  status,
                  style: TextStyle(
                    color: isError ? colorScheme.error : Colors.green.shade800,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  // 5. Revenue Dashboard Callback
  void _openRevenueDashboard() {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.currency_rupee_rounded, color: Colors.green.shade800),
              const SizedBox(width: 8),
              const Text('Revenue Overview'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Collected This Month:'),
                    Text(
                      '₹${_formatCurrency(_monthlyRevenue)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Revenue Breakdown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildRevenueBar(context, title: 'Owner Subscriptions', amount: '₹1,95,000', percentage: 0.56, color: colorScheme.primary),
                _buildRevenueBar(context, title: 'Customer Transaction Fees (1.5%)', amount: '₹1,12,200', percentage: 0.32, color: Colors.teal),
                _buildRevenueBar(context, title: 'Setup & Domain Mapping Add-ons', amount: '₹38,000', percentage: 0.12, color: Colors.indigo),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.trending_up, color: Colors.green.shade700, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Platform processing volume grew +18% month-over-month. Stripe pipelines operating optimally.',
                          style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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

  Widget _buildRevenueBar(
    BuildContext context, {
    required String title,
    required String amount,
    required double percentage,
    required Color color,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12)),
              Text(amount, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 6. Global Settings Callback
  void _openGlobalSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Global Settings',
                        style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const Divider(),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: const Text('Maintenance Mode'),
                    subtitle: const Text('Disable client login and display updates page.'),
                    value: _maintenanceMode,
                    activeColor: colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setSheetState(() {
                        _maintenanceMode = val;
                      });
                      setState(() {
                        _maintenanceMode = val;
                      });
                      _showSnackBar('Maintenance Mode ${val ? "enabled" : "disabled"}');
                    },
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    title: const Text('Auto-verify FSSAI'),
                    subtitle: const Text('Automatically accept valid FSSAI registry ID checks.'),
                    value: _autoVerifyFssai,
                    activeColor: colorScheme.primary,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (val) {
                      setSheetState(() {
                        _autoVerifyFssai = val;
                      });
                      setState(() {
                        _autoVerifyFssai = val;
                      });
                      _showSnackBar('Auto-verify FSSAI ${val ? "enabled" : "disabled"}');
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'API Rate Limit (Requests/Min)',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: _rateLimit),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 120',
                    ),
                    onChanged: (value) {
                      _rateLimit = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Make.com Outbound Webhook URL',
                    style: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(text: _makeWebhookUrl),
                    decoration: const InputDecoration(
                      hintText: 'https://hook.us1.make.com/...',
                    ),
                    onChanged: (value) {
                      _makeWebhookUrl = value;
                    },
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showSnackBar('Global Settings saved successfully!');
                    },
                    child: const Text('Save Configuration'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // View All Alerts Bottom Sheet
  void _openViewAllAlerts() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.95,
              minChildSize: 0.5,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'System Alerts (${_alerts.length})',
                            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          TextButton(
                            onPressed: () {
                              setSheetState(() {
                                _alerts = _alerts.map((a) => a.copyWith(isRead: true)).toList();
                              });
                              _showSnackBar('All alerts marked as read.');
                            },
                            child: const Text('Mark all read'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: _alerts.isEmpty
                            ? const Center(child: Text('No active alerts'))
                            : ListView.builder(
                                controller: scrollController,
                                itemCount: _alerts.length,
                                itemBuilder: (context, index) {
                                  final alert = _alerts[index];
                                  return Opacity(
                                    opacity: alert.isRead ? 0.6 : 1.0,
                                    child: AdminAlertCard(
                                      alert: alert,
                                      onTap: () {
                                        // Mark as read on tap
                                        setSheetState(() {
                                          _alerts[index] = alert.copyWith(isRead: true);
                                        });
                                        // Detail Dialog
                                        _showAlertDetail(alert);
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _showAlertDetail(AdminAlert alert) {
    showDialog(
      context: context,
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(alert.title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('Severity: '),
                  Text(
                    alert.severity.label.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: alert.severity == AlertSeverity.critical
                          ? colorScheme.error
                          : (alert.severity == AlertSeverity.warning ? Colors.orange.shade800 : colorScheme.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(alert.description),
              const SizedBox(height: 12),
              Text(
                'Occurred at: ${alert.timestamp.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            FilledButton(
              onPressed: () {
                setState(() {
                  _alerts.removeWhere((a) => a.id == alert.id);
                });
                Navigator.pop(context);
                _showSnackBar('Alert dismissed & resolved!');
              },
              child: const Text('Resolve'),
            ),
          ],
        );
      },
    );
  }

  String _formatCurrency(int val) {
    // Basic currency formatting
    return val.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
  }

  // Responsive layout helper
  Widget _buildResponsiveGrid(BuildContext context, List<Widget> children) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) {
      // Mobile Layout: Column containing cards, wrap 2nd & 3rd cards side-by-side if they fit nicely
      if (children.length == 3) {
        return Column(
          children: [
            children[0],
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: children[1]),
                const SizedBox(width: 10),
                Expanded(child: children[2]),
              ],
            )
          ],
        );
      }
      return Column(
        children: children
            .map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: c,
                ))
            .toList(),
      );
    } else {
      // Desktop Layout: All side-by-side
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(children.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < children.length - 1 ? 10 : 0,
              ),
              child: children[index],
            ),
          );
        }),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mazi Mess Admin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'System Status',
            icon: const Icon(Icons.dns_outlined),
            onPressed: () {
              _showSnackBar('All nodes running: Swarm Container 3000 Active.');
            },
          ),
          IconButton(
            tooltip: 'Reset Live Counters',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _totalCustomers = 1420;
                _totalOwners = 154;
                _totalMesses = 210;
                _pendingOwners = 5;
                _pendingMesses = 8;
                _paymentFailures = 4;
                _webhookFailures = 1;
                _monthlyRevenue = 345200;
              });
              _showSnackBar('Dashboard mock statistics reset!');
            },
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
              // Welcome header card
              Card(
                margin: const EdgeInsets.only(bottom: 24),
                color: colorScheme.primaryContainer.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: colorScheme.primary.withOpacity(0.15)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.admin_panel_settings,
                          color: colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Platform Control Panel',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Overview and manual verification queue for mess owners & system integrations.',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 1. PLATFORM OVERVIEW SECTION
              _SectionHeader(
                title: 'Platform Overview',
                tooltip: 'General platform user and mess outlet counts.',
              ),
              const SizedBox(height: 12),
              _buildResponsiveGrid(
                context,
                [
                  AdminStatCard(
                    title: 'Total Customers',
                    value: _totalCustomers.toString(),
                    icon: Icons.people_alt_outlined,
                    trendValue: '+12%',
                    isTrendPositive: true,
                    subtitle: 'this month',
                  ),
                  AdminStatCard(
                    title: 'Total Owners',
                    value: _totalOwners.toString(),
                    icon: Icons.business_center_outlined,
                    trendValue: '+8%',
                    isTrendPositive: true,
                    subtitle: 'verified profiles',
                  ),
                  AdminStatCard(
                    title: 'Total Messes',
                    value: _totalMesses.toString(),
                    icon: Icons.restaurant_outlined,
                    trendValue: '+5%',
                    isTrendPositive: true,
                    subtitle: 'active across city',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 2. APPROVAL OVERVIEW SECTION
              _SectionHeader(
                title: 'Approval Overview',
                tooltip: 'Registration requests requiring verification.',
                badgeCount: _pendingOwners + _pendingMesses,
              ),
              const SizedBox(height: 12),
              _buildResponsiveGrid(
                context,
                [
                  AdminStatCard(
                    title: 'Pending Owners',
                    value: _pendingOwners.toString(),
                    icon: Icons.how_to_reg_outlined,
                    iconColor: Colors.orange,
                    valueColor: Colors.orange,
                    subtitle: 'Pending verification',
                    onTap: _openOwnerVerification,
                  ),
                  AdminStatCard(
                    title: 'Pending Messes',
                    value: _pendingMesses.toString(),
                    icon: Icons.domain_verification_outlined,
                    iconColor: Colors.orange,
                    valueColor: Colors.orange,
                    subtitle: 'FSSAI cert approval',
                    onTap: _openMessApproval,
                  ),
                  AdminStatCard(
                    title: 'Suspended Owners',
                    value: _suspendedOwners.toString(),
                    icon: Icons.block_flipped,
                    iconColor: Colors.red,
                    valueColor: Colors.red,
                    subtitle: 'Terms violation',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 3. SYSTEM HEALTH SECTION
              _SectionHeader(
                title: 'System Health',
                tooltip: 'External webhooks, Stripe integrations, and payment failures status.',
                badgeCount: _paymentFailures + _webhookFailures,
              ),
              const SizedBox(height: 12),
              _buildResponsiveGrid(
                context,
                [
                  AdminStatCard(
                    title: 'Payment Failures',
                    value: _paymentFailures.toString(),
                    icon: Icons.payment_outlined,
                    isCritical: _paymentFailures > 0,
                    subtitle: 'Stripe webhook mismatches',
                    onTap: _openPaymentMonitoring,
                  ),
                  AdminStatCard(
                    title: 'Webhook Failures',
                    value: _webhookFailures.toString(),
                    icon: Icons.sync_problem_rounded,
                    isCritical: _webhookFailures > 0,
                    subtitle: 'Delivery failures',
                    onTap: _openWebhookMonitoring,
                  ),
                  AdminStatCard(
                    title: 'Make Integrations',
                    value: _activeMakeIntegrations.toString(),
                    icon: Icons.bolt_outlined,
                    iconColor: Colors.blue,
                    valueColor: Colors.blue,
                    subtitle: 'Webhook pipelines normal',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // 4. REVENUE OVERVIEW SECTION
              _SectionHeader(
                title: 'Revenue Overview',
                tooltip: 'Stripe subscription payments and transaction commission logs.',
              ),
              const SizedBox(height: 12),
              _buildResponsiveGrid(
                context,
                [
                  AdminStatCard(
                    title: 'Monthly Revenue',
                    value: '₹${_formatCurrency(_monthlyRevenue)}',
                    icon: Icons.currency_rupee_rounded,
                    valueColor: Colors.green,
                    trendValue: '+18%',
                    isTrendPositive: true,
                    subtitle: 'from last month',
                    onTap: _openRevenueDashboard,
                  ),
                  AdminStatCard(
                    title: 'Active Subscriptions',
                    value: _activeOwnerSubscriptions.toString(),
                    icon: Icons.card_membership_rounded,
                    subtitle: 'Paid subscription active',
                  ),
                  AdminStatCard(
                    title: 'Expiring Subscriptions',
                    value: _expiringOwnerSubscriptions.toString(),
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: Colors.orange,
                    valueColor: Colors.orange,
                    subtitle: 'Expires within 7 days',
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // 5. RECENT ALERTS SECTION
              _SectionHeader(
                title: 'Recent System Alerts',
                badgeCount: _alerts.where((a) => !a.isRead).length,
              ),
              const SizedBox(height: 12),
              _buildRecentAlertsSection(),

              const SizedBox(height: 28),

              // 6. QUICK ACTIONS SECTION
              _SectionHeader(
                title: 'Quick Actions',
              ),
              const SizedBox(height: 12),
              _buildQuickActionsGrid(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentAlertsSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final previewAlerts = _alerts.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (previewAlerts.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: Text('No system alerts')),
            ),
          )
        else
          ...previewAlerts.map(
            (alert) => AdminAlertCard(
              alert: alert,
              onTap: () {
                // Mark alert as read on tap
                setState(() {
                  final idx = _alerts.indexWhere((a) => a.id == alert.id);
                  if (idx != -1) {
                    _alerts[idx] = alert.copyWith(isRead: true);
                  }
                });
                _showAlertDetail(alert);
              },
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: _openViewAllAlerts,
          icon: const Icon(Icons.notifications_active_outlined, size: 16),
          label: const Text('View All Alerts'),
        ),
      ],
    );
  }

  Widget _buildQuickActionsGrid() {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: AdminQuickActionTile(
                  icon: Icons.how_to_reg_outlined,
                  label: 'Owner Verification',
                  subtitle: 'Approve profiles',
                  accentColor: Theme.of(context).colorScheme.primary,
                  onTap: _openOwnerVerification,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AdminQuickActionTile(
                  icon: Icons.restaurant_outlined,
                  label: 'Mess Approval',
                  subtitle: 'Verify licenses',
                  accentColor: Colors.orange.shade800,
                  onTap: _openMessApproval,
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
                child: AdminQuickActionTile(
                  icon: Icons.payment_outlined,
                  label: 'Payment Monitoring',
                  subtitle: 'Audit transactions',
                  accentColor: Colors.green.shade800,
                  onTap: _openPaymentMonitoring,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AdminQuickActionTile(
                  icon: Icons.sync_problem_rounded,
                  label: 'Webhook Monitoring',
                  subtitle: 'Integrations',
                  accentColor: Colors.red.shade800,
                  onTap: _openWebhookMonitoring,
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
                child: AdminQuickActionTile(
                  icon: Icons.currency_rupee_rounded,
                  label: 'Revenue Dashboard',
                  subtitle: 'View earnings',
                  accentColor: Colors.teal.shade800,
                  onTap: _openRevenueDashboard,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: AdminQuickActionTile(
                  icon: Icons.settings_outlined,
                  label: 'Global Settings',
                  subtitle: 'System controls',
                  accentColor: Colors.blueGrey.shade800,
                  onTap: _openGlobalSettings,
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
    this.badgeCount,
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
                  child: Icon(
                    Icons.help_outline,
                    size: 14,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
              if (badgeCount != null && badgeCount! > 0) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    badgeCount.toString(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onError,
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
