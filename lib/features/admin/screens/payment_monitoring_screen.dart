import 'package:flutter/material.dart';
import '../../../models/payment_monitoring_model.dart';
import '../widgets/admin_stat_card.dart';
import '../widgets/payment_record_card.dart';

class PaymentMonitoringScreen extends StatefulWidget {
  const PaymentMonitoringScreen({super.key});

  @override
  State<PaymentMonitoringScreen> createState() => _PaymentMonitoringScreenState();
}

class _PaymentMonitoringScreenState extends State<PaymentMonitoringScreen> {
  late List<PaymentVerificationRecord> _records;
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _records = [
      PaymentVerificationRecord(
        id: 'TXN1001',
        customerName: 'Omkar Rakhonde',
        customerMobile: '9876543210',
        messName: 'Annapurna Mess',
        amount: 3000.01,
        paymentTime: DateTime.now().subtract(const Duration(minutes: 15)),
        status: PaymentVerificationStatus.failed,
        verificationSource: 'Make Automation',
        transactionRef: 'PAYTM_9876543',
        failureReason: PaymentFailureReason.amountMismatch,
        auditLogs: [
          PaymentAuditLog(
            action: 'Automation Process',
            timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
            adminName: 'System',
            reason: 'Gemini extracted ₹3000.00 but Paytm notification showed ₹3000.01',
          ),
        ],
      ),
      PaymentVerificationRecord(
        id: 'TXN1002',
        customerName: 'Kunal Shinde',
        customerMobile: '8888888888',
        messName: 'Swami Mess',
        amount: 2500.00,
        paymentTime: DateTime.now().subtract(const Duration(hours: 2)),
        status: PaymentVerificationStatus.verified,
        verificationSource: 'Make Automation',
        transactionRef: 'PAYTM_1234567',
        auditLogs: [
          PaymentAuditLog(
            action: 'Automation Process',
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            adminName: 'System',
            reason: 'UPI transaction verified instantly with Paytm statement',
          ),
        ],
      ),
      PaymentVerificationRecord(
        id: 'TXN1003',
        customerName: 'Snehal Patil',
        customerMobile: '7777777777',
        messName: 'Gurukrupa Annex',
        amount: 3200.00,
        paymentTime: DateTime.now().subtract(const Duration(hours: 4)),
        status: PaymentVerificationStatus.pending,
        verificationSource: 'Gmail Pipeline',
        transactionRef: 'PAYTM_8811223',
        auditLogs: [
          PaymentAuditLog(
            action: 'Email Detection',
            timestamp: DateTime.now().subtract(const Duration(hours: 4)),
            adminName: 'System',
            reason: 'Payment notification email received. Undergoing extraction.',
          ),
        ],
      ),
      PaymentVerificationRecord(
        id: 'TXN1004',
        customerName: 'Amol Deshmukh',
        customerMobile: '9900112233',
        messName: 'Royal Mess',
        amount: 2800.50,
        paymentTime: DateTime.now().subtract(const Duration(hours: 6)),
        status: PaymentVerificationStatus.manualOverride,
        verificationSource: 'Admin Intervention',
        transactionRef: 'PAYTM_9911882',
        auditLogs: [
          PaymentAuditLog(
            action: 'Marked as Verified',
            timestamp: DateTime.now().subtract(const Duration(hours: 5)),
            adminName: 'Admin',
            reason: 'Customer submitted payment proof; Paytm delay on notification',
          ),
        ],
      ),
      PaymentVerificationRecord(
        id: 'TXN1005',
        customerName: 'Prashant More',
        customerMobile: '9012345678',
        messName: 'Annapurna Mess',
        amount: 3000.00,
        paymentTime: DateTime.now().subtract(const Duration(hours: 8)),
        status: PaymentVerificationStatus.retryRequired,
        verificationSource: 'Make Automation',
        transactionRef: 'PAYTM_4455667',
        failureReason: PaymentFailureReason.webhookFailure,
        auditLogs: [
          PaymentAuditLog(
            action: 'Automation Failure',
            timestamp: DateTime.now().subtract(const Duration(hours: 8)),
            adminName: 'System',
            reason: 'Webhook endpoint returned 504 Gateway Timeout during callback',
          ),
        ],
      ),
      PaymentVerificationRecord(
        id: 'TXN1006',
        customerName: 'Shubham Gade',
        customerMobile: '9112233445',
        messName: 'Swami Mess',
        amount: 2500.00,
        paymentTime: DateTime.now().subtract(const Duration(hours: 12)),
        status: PaymentVerificationStatus.failed,
        verificationSource: 'Make Automation',
        transactionRef: 'PAYTM_8899001',
        failureReason: PaymentFailureReason.emailNotFound,
        auditLogs: [
          PaymentAuditLog(
            action: 'Extraction Error',
            timestamp: DateTime.now().subtract(const Duration(hours: 12)),
            adminName: 'System',
            reason: 'Gmail parsing failed to locate any Paytm Business email matching reference',
          ),
        ],
      ),
    ];
  }

  // Statistics calculated reactively from current in-memory state
  int get _pendingCount => _records.where((r) => r.status == PaymentVerificationStatus.pending).length;
  int get _verifiedCount => _records.where((r) => r.status == PaymentVerificationStatus.verified).length;
  int get _failedCount => _records.where((r) => r.status == PaymentVerificationStatus.failed).length;
  int get _overrideCount => _records.where((r) => r.status == PaymentVerificationStatus.manualOverride).length;

  List<PaymentVerificationRecord> get _filteredRecords {
    return _records.where((r) {
      final matchesSearch = r.customerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.customerMobile.contains(_searchQuery) ||
          r.messName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          r.transactionRef.toLowerCase().contains(_searchQuery.toLowerCase());

      if (!matchesSearch) return false;

      if (_selectedFilter == 'All') return true;
      if (_selectedFilter == 'Pending') return r.status == PaymentVerificationStatus.pending;
      if (_selectedFilter == 'Verified') return r.status == PaymentVerificationStatus.verified;
      if (_selectedFilter == 'Failed') return r.status == PaymentVerificationStatus.failed;
      if (_selectedFilter == 'Manual Override') return r.status == PaymentVerificationStatus.manualOverride;
      if (_selectedFilter == 'Retry Required') return r.status == PaymentVerificationStatus.retryRequired;

      return true;
    }).toList();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Theme.of(context).colorScheme.onInverseSurface,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _retryVerification(PaymentVerificationRecord record) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 24),
              Expanded(child: Text('Retrying payment pipeline verification...')),
            ],
          ),
        );
      },
    );

    // Mock API delay of 1.5 seconds, then update status
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        Navigator.pop(context); // close loader dialog
        setState(() {
          final idx = _records.indexWhere((r) => r.id == record.id);
          if (idx != -1) {
            // Randomly succeed or remain failed for interactive feel
            final isSuccess = DateTime.now().millisecond % 2 == 0;
            if (isSuccess) {
              _records[idx] = _records[idx].copyWith(
                status: PaymentVerificationStatus.verified,
                verificationSource: 'Make Automation (Retried)',
                failureReason: null,
                auditLogs: [
                  ..._records[idx].auditLogs,
                  PaymentAuditLog(
                    action: 'Retried Pipeline Success',
                    timestamp: DateTime.now(),
                    adminName: 'System',
                    reason: 'Pipeline retried. Verification succeeded via Webhook trigger.',
                  ),
                ],
              );
              _showSnackBar('Verification succeeded on retry! ${record.customerName} is now Verified.');
            } else {
              _records[idx] = _records[idx].copyWith(
                status: PaymentVerificationStatus.retryRequired,
                failureReason: PaymentFailureReason.verificationTimeout,
                auditLogs: [
                  ..._records[idx].auditLogs,
                  PaymentAuditLog(
                    action: 'Retried Pipeline Failure',
                    timestamp: DateTime.now(),
                    adminName: 'System',
                    reason: 'Verification timeout occurred again during automated lookup.',
                  ),
                ],
              );
              _showSnackBar('Retry completed. Still awaiting payment notification.', isError: true);
            }
          }
        });
      }
    });
  }

  void _markAsVerified(PaymentVerificationRecord record) {
    final formKey = GlobalKey<FormState>();
    String selectedReason = 'Customer submitted payment proof';
    final customReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(Icons.verified_outlined, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Mark as Verified'),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Choose the verification override reason:'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Standard Reason',
                      ),
                      items: [
                        'Customer submitted payment proof',
                        'Email delivery delay',
                        'Manual verification completed',
                        'Other',
                      ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedReason = val;
                          });
                        }
                      },
                    ),
                    if (selectedReason == 'Other') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: customReasonController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Custom Reason *',
                          hintText: 'Describe details...',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please specify reason' : null,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      final finalReason = selectedReason == 'Other'
                          ? customReasonController.text.trim()
                          : selectedReason;

                      setState(() {
                        final idx = _records.indexWhere((r) => r.id == record.id);
                        if (idx != -1) {
                          _records[idx] = _records[idx].copyWith(
                            status: PaymentVerificationStatus.manualOverride,
                            verificationSource: 'Admin Intervention',
                            failureReason: null,
                            auditLogs: [
                              ..._records[idx].auditLogs,
                              PaymentAuditLog(
                                action: 'Manual Override (Verified)',
                                timestamp: DateTime.now(),
                                adminName: 'Admin',
                                reason: finalReason,
                              ),
                            ],
                          );
                        }
                      });
                      Navigator.pop(context);
                      _showSnackBar('Transaction ${record.id} manually verified!');
                    }
                  },
                  child: const Text('Confirm Verification'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _markAsFailed(PaymentVerificationRecord record) {
    final formKey = GlobalKey<FormState>();
    String selectedReason = 'Fake payment proof';
    final customReasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.gpp_bad_outlined, color: Theme.of(context).colorScheme.error),
                  const SizedBox(width: 8),
                  const Text('Mark as Failed'),
                ],
              ),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Please choose the failure classification reason:'),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedReason,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Standard Failure Reason',
                      ),
                      items: [
                        'Fake payment proof',
                        'Duplicate payment',
                        'Invalid transaction',
                        'Other',
                      ].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedReason = val;
                          });
                        }
                      },
                    ),
                    if (selectedReason == 'Other') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: customReasonController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Custom Failure Reason *',
                          hintText: 'Describe details...',
                        ),
                        validator: (v) => v == null || v.trim().isEmpty ? 'Please specify reason' : null,
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    foregroundColor: Theme.of(context).colorScheme.onError,
                  ),
                  onPressed: () {
                    if (formKey.currentState?.validate() == true) {
                      final finalReason = selectedReason == 'Other'
                          ? customReasonController.text.trim()
                          : selectedReason;

                      setState(() {
                        final idx = _records.indexWhere((r) => r.id == record.id);
                        if (idx != -1) {
                          _records[idx] = _records[idx].copyWith(
                            status: PaymentVerificationStatus.failed,
                            verificationSource: 'Admin Rejection',
                            failureReason: PaymentFailureReason.unknownError,
                            auditLogs: [
                              ..._records[idx].auditLogs,
                              PaymentAuditLog(
                                action: 'Manual Rejection (Failed)',
                                timestamp: DateTime.now(),
                                adminName: 'Admin',
                                reason: finalReason,
                              ),
                            ],
                          );
                        }
                      });
                      Navigator.pop(context);
                      _showSnackBar('Transaction ${record.id} marked as Failed.', isError: true);
                    }
                  },
                  child: const Text('Confirm Rejection'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _viewDetails(PaymentVerificationRecord record) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;

        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Record Details (${record.id})',
                  style: const TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 550,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildDetailRow(context, 'Customer Name', record.customerName),
                  _buildDetailRow(context, 'Customer Mobile', record.customerMobile),
                  _buildDetailRow(context, 'Mess Name', record.messName),
                  _buildDetailRow(context, 'Amount Paid', '₹${record.amount.toStringAsFixed(2)}', isBold: true),
                  _buildDetailRow(context, 'Transaction Ref', record.transactionRef, isCode: true),
                  _buildDetailRow(context, 'Payment Time', record.paymentTime.toLocal().toString()),
                  _buildDetailRow(context, 'Verification Status', record.status.label.toUpperCase()),
                  if (record.failureReason != null)
                    _buildDetailRow(context, 'Failure Category', record.failureReason!.label, isError: true),
                  _buildDetailRow(context, 'Verification Source', record.verificationSource),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    'Audit & System Pipeline Logs',
                    style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  if (record.auditLogs.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text('No audit logs available for this transaction.'),
                    )
                  else
                    ...record.auditLogs.map((log) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: colorScheme.surfaceContainerHighest.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: colorScheme.outlineVariant.withOpacity(0.4)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    log.action,
                                    style: textTheme.labelMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Text(
                                    '${log.timestamp.hour}:${log.timestamp.minute.toString().padLeft(2, '0')}',
                                    style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                log.reason,
                                style: textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'By: ${log.adminName}',
                                style: textTheme.labelSmall?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
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

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {bool isBold = false, bool isCode = false, bool isError = false}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              label,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                fontFamily: isCode ? 'Courier' : null,
                color: isError
                    ? colorScheme.error
                    : isBold
                        ? colorScheme.primary
                        : colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveStatsGrid() {
    final width = MediaQuery.of(context).size.width;

    final List<Widget> stats = [
      AdminStatCard(
        title: 'Pending Verification',
        value: _pendingCount.toString(),
        icon: Icons.hourglass_top_outlined,
        iconColor: Colors.orange,
        valueColor: Colors.orange.shade800,
        isCritical: _pendingCount > 0,
        subtitle: 'Awaiting webhook statement matches',
      ),
      AdminStatCard(
        title: 'Verified Today',
        value: _verifiedCount.toString(),
        icon: Icons.check_circle_outline,
        iconColor: Colors.green,
        valueColor: Colors.green.shade700,
        subtitle: 'Automated verification pipelines successful',
      ),
      AdminStatCard(
        title: 'Failed Today',
        value: _failedCount.toString(),
        icon: Icons.gpp_bad_outlined,
        iconColor: Colors.red,
        valueColor: Colors.red.shade700,
        subtitle: 'Validation mismatch or timeout pipelines',
      ),
      AdminStatCard(
        title: 'Manual Overrides',
        value: _overrideCount.toString(),
        icon: Icons.admin_panel_settings_outlined,
        iconColor: Colors.blue,
        valueColor: Colors.blue.shade700,
        subtitle: 'Manually certified verification pipeline logs',
      ),
    ];

    if (width >= 900) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(stats.length, (index) {
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                right: index < stats.length - 1 ? 12 : 0,
              ),
              child: stats[index],
            ),
          );
        }),
      );
    } else if (width >= 550) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: stats[0]),
              const SizedBox(width: 12),
              Expanded(child: stats[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: stats[2]),
              const SizedBox(width: 12),
              Expanded(child: stats[3]),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: stats
            .map((card) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: card,
                ))
            .toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final filteredList = _filteredRecords;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payment Monitoring',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Payment Verification Pipeline'),
                  content: const Text(
                    'The verification flow processes payments in real-time:\n\n'
                    'Customer → Pays via UPI → Paytm Business Email → Dedicated Mess Gmail → Make.com Scenario → Gemini extracts details → Automated Verification.\n\n'
                    'If validation fails (e.g. timeout, reference mismatch, fake proof), admin can manually override by marking as Verified or Failed.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // System Information Alert
                    Card(
                      color: colorScheme.surfaceContainerHighest.withOpacity(0.4),
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Real-time Payment Pipeline Logs. In case of auto-verification failure, please verify proof and use override commands.',
                                style: textTheme.bodySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 1. Statistics Summary Grid
                    _buildResponsiveStatsGrid(),
                    const SizedBox(height: 24),

                    // 2. Search & Dynamic Filtering Panel
                    Card(
                      elevation: 0,
                      color: colorScheme.surfaceContainerHigh.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                hintText: 'Search by customer name, mobile, mess, or TXN ref...',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value;
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                            // Filter chips wrapping automatically to support any screen size beautifully
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                'All',
                                'Pending',
                                'Verified',
                                'Failed',
                                'Manual Override',
                                'Retry Required',
                              ].map((filter) {
                                final isSelected = _selectedFilter == filter;
                                return FilterChip(
                                  label: Text(filter),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Payments Record Cards List
                    if (filteredList.isEmpty)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.3)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                size: 48,
                                color: colorScheme.onSurfaceVariant.withOpacity(0.4),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Payment Logs Match',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try matching alternate criteria, clearing the search query, or selecting different filter badges.',
                                textAlign: TextAlign.center,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return PaymentRecordCard(
                            record: item,
                            onViewDetails: () => _viewDetails(item),
                            onRetryVerification: () => _retryVerification(item),
                            onMarkAsVerified: () => _markAsVerified(item),
                            onMarkAsFailed: () => _markAsFailed(item),
                          );
                        },
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
