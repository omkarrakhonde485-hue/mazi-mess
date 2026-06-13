import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/providers/subscription_repository_provider.dart';
import '../../../models/subscription_model.dart';
import '../widgets/leave_calendar_widget.dart';

class LeaveManagementScreen extends ConsumerStatefulWidget {
  const LeaveManagementScreen({super.key});

  @override
  ConsumerState<LeaveManagementScreen> createState() =>
      _LeaveManagementScreenState();
}

class _LeaveManagementScreenState extends ConsumerState<LeaveManagementScreen> {
  late final Future<List<Subscription>> _subscriptionsFuture;
  late DateTime _displayedMonth;
  late final Map<String, Set<DateTime>> _leaveDatesBySubscription;
  late final Map<String, Set<DateTime>> _mockLockedDatesBySubscription;

  String? _selectedSubscriptionId;

  @override
  void initState() {
    super.initState();
    _subscriptionsFuture = ref
        .read(subscriptionRepositoryProvider)
        .getSubscriptions();
    final today = DateUtils.dateOnly(DateTime.now());
    _displayedMonth = DateTime(today.year, today.month);
    _leaveDatesBySubscription = {
      'sub_001': {
        today.add(const Duration(days: 4)),
        today.add(const Duration(days: 8)),
      },
      'sub_002': {
        today.add(const Duration(days: 5)),
        today.add(const Duration(days: 12)),
      },
    };
    _mockLockedDatesBySubscription = {
      'sub_001': {today.add(const Duration(days: 6))},
      'sub_002': {today.add(const Duration(days: 9))},
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Leave Management')),
      body: FutureBuilder<List<Subscription>>(
        future: _subscriptionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Unable to load subscriptions',
                style: textTheme.bodyLarge,
              ),
            );
          }

          final activeSubscriptions = (snapshot.data ?? [])
              .where((subscription) => subscription.status.isActive)
              .toList();

          if (activeSubscriptions.isEmpty) {
            return Center(
              child: Text(
                'No active subscriptions',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            );
          }

          final selectedSubscription = _selectedSubscription(
            activeSubscriptions,
          );
          final leaveDates =
              _leaveDatesBySubscription[selectedSubscription.subscriptionId] ??
              <DateTime>{};
          final lockedDates = _calendarLockedDatesFor(
            selectedSubscription.subscriptionId,
            leaveDates,
          );

          return SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _SubscriptionSelector(
                  subscriptions: activeSubscriptions,
                  selectedSubscriptionId: selectedSubscription.subscriptionId,
                  onChanged: (subscriptionId) {
                    if (subscriptionId == null) {
                      return;
                    }
                    setState(() => _selectedSubscriptionId = subscriptionId);
                  },
                ),
                const SizedBox(height: 16),
                LeaveCalendarWidget(
                  displayedMonth: _displayedMonth,
                  leaveDates: leaveDates,
                  lockedDates: lockedDates,
                  onMonthChanged: (month) {
                    setState(() => _displayedMonth = month);
                  },
                  onDatePressed: (date) {
                    _toggleLeaveDate(selectedSubscription.subscriptionId, date);
                  },
                  onLockedDatePressed: (date) => _handleLockedDatePressed(
                    selectedSubscription.subscriptionId,
                    date,
                  ),
                ),
                const SizedBox(height: 16),
                _LegendCard(),
                const SizedBox(height: 16),
                _DateSection(
                  title: 'Selected Leave Dates',
                  emptyMessage: 'No leave dates selected',
                  dates: leaveDates,
                  icon: Icons.event_available_outlined,
                ),
                const SizedBox(height: 16),
                _DateSection(
                  title: 'Locked Dates',
                  emptyMessage: 'No locked dates this month',
                  dates: lockedDates,
                  icon: Icons.lock_outline,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Subscription _selectedSubscription(List<Subscription> subscriptions) {
    final selectedId = _selectedSubscriptionId;
    if (selectedId != null) {
      for (final subscription in subscriptions) {
        if (subscription.subscriptionId == selectedId) {
          return subscription;
        }
      }
    }

    _selectedSubscriptionId = subscriptions.first.subscriptionId;
    return subscriptions.first;
  }

  Set<DateTime> _calendarLockedDatesFor(
    String subscriptionId,
    Set<DateTime> leaveDates,
  ) {
    final today = DateUtils.dateOnly(DateTime.now());
    return {
      today,
      ...leaveDates.where(_isInsideRemovalLockWindow),
      ...?_mockLockedDatesBySubscription[subscriptionId],
    };
  }

  void _toggleLeaveDate(String subscriptionId, DateTime date) {
    final normalizedDate = DateUtils.dateOnly(date);
    final mockLockedDates =
        _mockLockedDatesBySubscription[subscriptionId] ?? const <DateTime>{};

    if (mockLockedDates.contains(normalizedDate)) {
      _showLockedDateMessage();
      return;
    }

    if (!_isFutureDate(normalizedDate)) {
      _showFutureDateMessage();
      return;
    }

    final currentDates =
        _leaveDatesBySubscription[subscriptionId] ?? const <DateTime>{};
    if (currentDates.contains(normalizedDate) &&
        _isInsideRemovalLockWindow(normalizedDate)) {
      _showRemovalLockedMessage();
      return;
    }

    setState(() {
      final dates = _leaveDatesBySubscription.putIfAbsent(
        subscriptionId,
        () => <DateTime>{},
      );
      if (!dates.remove(normalizedDate)) {
        dates.add(normalizedDate);
      }
    });
  }

  void _handleLockedDatePressed(String subscriptionId, DateTime date) {
    final normalizedDate = DateUtils.dateOnly(date);
    final leaveDates =
        _leaveDatesBySubscription[subscriptionId] ?? const <DateTime>{};

    if (leaveDates.contains(normalizedDate) &&
        _isInsideRemovalLockWindow(normalizedDate)) {
      _showRemovalLockedMessage();
      return;
    }

    if (!_isFutureDate(normalizedDate)) {
      _showFutureDateMessage();
      return;
    }

    _showLockedDateMessage();
  }

  bool _isFutureDate(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    return date.isAfter(today);
  }

  bool _isInsideRemovalLockWindow(DateTime date) {
    final today = DateUtils.dateOnly(DateTime.now());
    final lockWindowEnd = today.add(const Duration(days: 2));
    return date.isAfter(today) && !date.isAfter(lockWindowEnd);
  }

  void _showLockedDateMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Locked dates cannot be modified')),
    );
  }

  void _showRemovalLockedMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Leave inside the lock window cannot be removed'),
      ),
    );
  }

  void _showFutureDateMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Only future dates can be marked as leave')),
    );
  }
}

class _SubscriptionSelector extends StatelessWidget {
  const _SubscriptionSelector({
    required this.subscriptions,
    required this.selectedSubscriptionId,
    required this.onChanged,
  });

  final List<Subscription> subscriptions;
  final String selectedSubscriptionId;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    if (subscriptions.length == 1) {
      final subscription = subscriptions.first;
      return _SelectedSubscriptionCard(subscription: subscription);
    }

    return DropdownButtonFormField<String>(
      initialValue: selectedSubscriptionId,
      decoration: const InputDecoration(
        labelText: 'Subscription',
        prefixIcon: Icon(Icons.card_membership_outlined),
      ),
      items: subscriptions.map((subscription) {
        return DropdownMenuItem<String>(
          value: subscription.subscriptionId,
          child: Text('${subscription.messName} - ${subscription.planName}'),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}

class _SelectedSubscriptionCard extends StatelessWidget {
  const _SelectedSubscriptionCard({required this.subscription});

  final Subscription subscription;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.card_membership_outlined,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subscription.messName,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subscription.planName,
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 12,
          children: const [
            _LegendItem(
              label: 'Leave',
              icon: Icons.event_available_outlined,
              colorRole: _LegendColorRole.primary,
            ),
            _LegendItem(
              label: 'Locked',
              icon: Icons.lock_outline,
              colorRole: _LegendColorRole.surfaceVariant,
            ),
            _LegendItem(
              label: 'Today',
              icon: Icons.today_outlined,
              colorRole: _LegendColorRole.outline,
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.label,
    required this.icon,
    required this.colorRole,
  });

  final String label;
  final IconData icon;
  final _LegendColorRole colorRole;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor) = switch (colorRole) {
      _LegendColorRole.primary => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      _LegendColorRole.surfaceVariant => (
        colorScheme.surfaceContainerHighest,
        colorScheme.onSurfaceVariant,
      ),
      _LegendColorRole.outline => (colorScheme.surface, colorScheme.primary),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: foregroundColor),
          ),
          child: Icon(icon, size: 16, color: foregroundColor),
        ),
        const SizedBox(width: 8),
        Text(label, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}

enum _LegendColorRole { primary, surfaceVariant, outline }

class _DateSection extends StatelessWidget {
  const _DateSection({
    required this.title,
    required this.emptyMessage,
    required this.dates,
    required this.icon,
  });

  final String title;
  final String emptyMessage;
  final Set<DateTime> dates;
  final IconData icon;

  static final _dateFormat = DateFormat('EEE, d MMM yyyy');

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sortedDates = dates.toList()..sort();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            if (sortedDates.isEmpty)
              Text(
                emptyMessage,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              )
            else
              ...sortedDates.map(
                (date) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(icon, size: 18, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _dateFormat.format(date),
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
