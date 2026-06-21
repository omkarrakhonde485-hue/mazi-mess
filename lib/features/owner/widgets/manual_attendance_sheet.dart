import 'package:flutter/material.dart';

// Inline simple model representing custom customers and their plans
class MockCustomer {
  final String id;
  final String name;
  final String phoneNumber;
  final bool hasBreakfast;
  final bool hasLunch;
  final bool hasDinner;

  const MockCustomer({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.hasBreakfast,
    required this.hasLunch,
    required this.hasDinner,
  });

  String get planDescription {
    final list = <String>[];
    if (hasBreakfast) list.add('Breakfast');
    if (hasLunch) list.add('Lunch');
    if (hasDinner) list.add('Dinner');
    return list.isNotEmpty ? list.join(' + ') : 'No subscribed meals';
  }
}

class ManualAttendanceSheet extends StatefulWidget {
  const ManualAttendanceSheet({super.key});

  @override
  State<ManualAttendanceSheet> createState() => _ManualAttendanceSheetState();
}

class _ManualAttendanceSheetState extends State<ManualAttendanceSheet> {
  // Mock customers representing different plan configurations
  final List<MockCustomer> _customers = const [
    MockCustomer(
      id: 'cust_1',
      name: 'Omkar Rakhonde',
      phoneNumber: '+91 98765 43210',
      hasBreakfast: true,
      hasLunch: true,
      hasDinner: true,
    ),
    MockCustomer(
      id: 'cust_2',
      name: 'Priya Sharma',
      phoneNumber: '+91 87654 32109',
      hasBreakfast: false,
      hasLunch: true,
      hasDinner: true,
    ),
    MockCustomer(
      id: 'cust_3',
      name: 'Rohan Mehta',
      phoneNumber: '+91 76543 21098',
      hasBreakfast: true,
      hasLunch: false,
      hasDinner: false,
    ),
    MockCustomer(
      id: 'cust_4',
      name: 'Sneha Kulkarni',
      phoneNumber: '+91 65432 10987',
      hasBreakfast: false,
      hasLunch: true,
      hasDinner: false,
    ),
  ];

  late MockCustomer _selectedCustomer;
  late String _selectedMeal; // 'Breakfast', 'Lunch', 'Dinner'
  String _selectedReason = 'QR Failed';
  final TextEditingController _notesController = TextEditingController();

  final List<String> _reasons = const [
    'QR Failed',
    'Phone Camera Issue',
    'Network Issue',
    'Owner Verified In Person',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCustomer = _customers.first;
    _selectedMeal = _determineAutoMeal();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // Auto Selection based on Hour
  String _determineAutoMeal() {
    final now = DateTime.now();
    final hour = now.hour;

    // Breakfast: 07:00 - 10:59
    // Lunch: 11:00 - 15:59
    // Dinner: 16:00 - 22:59
    if (hour >= 7 && hour < 11) {
      return 'Breakfast';
    } else if (hour >= 11 && hour < 16) {
      return 'Lunch';
    } else if (hour >= 16 && hour < 23) {
      return 'Dinner';
    } else {
      return 'Breakfast'; // default fallback
    }
  }

  bool _isMealInPlan() {
    if (_selectedMeal == 'Breakfast') return _selectedCustomer.hasBreakfast;
    if (_selectedMeal == 'Lunch') return _selectedCustomer.hasLunch;
    if (_selectedMeal == 'Dinner') return _selectedCustomer.hasDinner;
    return false;
  }

  void _submit() {
    if (!_isMealInPlan()) {
      return;
    }

    final now = DateTime.now();
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    // Return the created manual log with Status = Pending Approval
    final attendanceResult = {
      'customerName': _selectedCustomer.name,
      'phoneNumber': _selectedCustomer.phoneNumber,
      'mealType': _selectedMeal,
      'time': formattedTime,
      'status': 'Pending Approval',
      'method': 'Manual',
      'reason': _selectedReason,
      'notes': _notesController.text.trim(),
    };

    Navigator.pop(context, attendanceResult);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isSubscribed = _isMealInPlan();
    final autoMeal = _determineAutoMeal();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'New Manual Attendance Check-in',
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),

            // Step 1: Customer Selector
            Text(
              'Select Customer',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MockCustomer>(
                  value: _selectedCustomer,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (MockCustomer? value) {
                    if (value != null) {
                      setState(() {
                        _selectedCustomer = value;
                      });
                    }
                  },
                  items: _customers.map((customer) {
                    return DropdownMenuItem<MockCustomer>(
                      value: customer,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            customer.name,
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Active Plan: ${customer.planDescription} (${customer.phoneNumber})',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 2: Auto Meal Selection display & manual override
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Meal Configuration',
                  style: textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
                if (_selectedMeal == autoMeal)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green.withAlpha(20),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Auto Selected',
                      style: textTheme.labelSmall?.copyWith(
                        color: Colors.green[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 0,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Based on current system time, the auto selected meal is $_selectedMeal.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Manual Override Row
                    Text(
                      'Override Selection:',
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: ['Breakfast', 'Lunch', 'Dinner'].map((meal) {
                        final isSelected = _selectedMeal == meal;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ChoiceChip(
                              label: Text(
                                meal,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    _selectedMeal = meal;
                                  });
                                }
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 3: Meal Validation Alert
            if (!isSubscribed)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withAlpha(120),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: colorScheme.error.withOpacity(0.3)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Validation Error',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onErrorContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Customer is not subscribed to this meal.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // Step 4: Reason Selector
            Text(
              'Select Reason',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: colorScheme.outlineVariant),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedReason,
                  isExpanded: true,
                  borderRadius: BorderRadius.circular(12),
                  onChanged: (String? value) {
                    if (value != null) {
                      setState(() {
                        _selectedReason = value;
                      });
                    }
                  },
                  items: _reasons.map((reason) {
                    return DropdownMenuItem<String>(
                      value: reason,
                      child: Text(reason, style: textTheme.bodyLarge),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Step 5: Optional Notes
            Text(
              'Optional Notes & Remarks',
              style: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                hintText: 'Add remarks for manually marking...',
                hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant.withAlpha(150)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Step 6: Attendance Approval Flow Notice & Display Approval Preview Information
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer.withAlpha(40),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.secondaryContainer),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lock_clock, size: 16, color: colorScheme.onSecondaryContainer),
                      const SizedBox(width: 8),
                      Text(
                        'Approval Process',
                        style: textTheme.titleSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Manual recording requires customer approval to ensure double confirmation side-by-side.',
                    style: textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer.withAlpha(200),
                    ),
                  ),
                  const Divider(height: 16, thickness: 0.5),
                  // Display a preview section
                  Text(
                    'Request Preview:',
                    style: textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer.withAlpha(220),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Member Name: ',
                        style: textTheme.bodySmall,
                      ),
                      Text(
                        _selectedCustomer.name,
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Requested Meal: ',
                        style: textTheme.bodySmall,
                      ),
                      Text(
                        _selectedMeal,
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Reason: ',
                        style: textTheme.bodySmall,
                      ),
                      Text(
                        _selectedReason,
                        style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Actions Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: isSubscribed ? _submit : null,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Send Request'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
