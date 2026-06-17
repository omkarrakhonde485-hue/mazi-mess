import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/mock_data/fake_payments.dart';
import '../../../models/payment_item.dart';
import '../widgets/payment_history_card.dart';
import '../widgets/payment_summary_card.dart';

class PaymentHistoryScreen extends ConsumerStatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  ConsumerState<PaymentHistoryScreen> createState() => _PaymentHistoryScreenState();
}

class _PaymentHistoryScreenState extends ConsumerState<PaymentHistoryScreen> {
  String _searchQuery = '';
  PaymentStatus? _selectedStatusFilter;

  List<PaymentItem> get _filteredPayments {
    return fakePayments.where((payment) {
      final matchesSearch = payment.messName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          payment.planName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          payment.transactionId.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesStatus = _selectedStatusFilter == null || payment.status == _selectedStatusFilter;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  void _showPaymentDetails(BuildContext context, PaymentItem payment) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final currencyFormat = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    final statusColor = switch (payment.status) {
      PaymentStatus.success => Colors.green,
      PaymentStatus.pending => Colors.orange,
      PaymentStatus.failed => Colors.red,
    };

    final statusBgColor = switch (payment.status) {
      PaymentStatus.success => Colors.green.withOpacity(0.1),
      PaymentStatus.pending => Colors.orange.withOpacity(0.1),
      PaymentStatus.failed => Colors.red.withOpacity(0.1),
    };

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Transaction Receipt',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          payment.status.label,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    currencyFormat.format(payment.amount),
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: payment.status == PaymentStatus.failed
                          ? colorScheme.error
                          : colorScheme.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Divider(color: colorScheme.outlineVariant.withOpacity(0.5)),
                const SizedBox(height: 16),
                _ReceiptRow(
                  label: 'Mess',
                  value: payment.messName,
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Meal Plan',
                  value: payment.planName,
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Transaction ID',
                  value: payment.transactionId,
                  isPromo: true,
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Payment Method',
                  value: payment.paymentMethod,
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Date & Time',
                  value: dateFormat.format(payment.paymentDate),
                ),
                const SizedBox(height: 12),
                _ReceiptRow(
                  label: 'Payment Status',
                  value: payment.status.label,
                  valueColor: statusColor,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final filtered = _filteredPayments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: PaymentSummaryCard(payments: fakePayments),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Search by Mess name or Plan...',
                  prefixIcon: Icon(Icons.search_outlined, color: colorScheme.onSurfaceVariant),
                  filled: true,
                  fillColor: colorScheme.surfaceVariant.withOpacity(0.3),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All',
                    isSelected: _selectedStatusFilter == null,
                    onSelected: () => setState(() => _selectedStatusFilter = null),
                  ),
                  _FilterChip(
                    label: 'Success',
                    isSelected: _selectedStatusFilter == PaymentStatus.success,
                    onSelected: () => setState(() => _selectedStatusFilter = PaymentStatus.success),
                  ),
                  _FilterChip(
                    label: 'Pending',
                    isSelected: _selectedStatusFilter == PaymentStatus.pending,
                    onSelected: () => setState(() => _selectedStatusFilter = PaymentStatus.pending),
                  ),
                  _FilterChip(
                    label: 'Failed',
                    isSelected: _selectedStatusFilter == PaymentStatus.failed,
                    onSelected: () => setState(() => _selectedStatusFilter = PaymentStatus.failed),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 48,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No payments found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          if (_searchQuery.isNotEmpty || _selectedStatusFilter != null) ...[
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _searchQuery = '';
                                  _selectedStatusFilter = null;
                                });
                              },
                              child: const Text('Clear Filters'),
                            ),
                          ],
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final payment = filtered[index];
                        return PaymentHistoryCard(
                          payment: payment,
                          onTap: () => _showPaymentDetails(context, payment),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        selectedColor: colorScheme.primaryContainer,
        labelStyle: TextStyle(
          color: isSelected ? colorScheme.onPrimaryContainer : colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({
    required this.label,
    required this.value,
    this.isPromo = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool isPromo;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: isPromo ? 'monospace' : null,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}
