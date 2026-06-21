import 'package:flutter/material.dart';

class AttendanceRecordCard extends StatelessWidget {
  final String customerName;
  final String phoneNumber;
  final String mealType; // 'Breakfast', 'Lunch', 'Dinner'
  final String time; // e.g. '08:32 AM'
  final String status; // 'Present', 'Absent', 'Pending Approval'
  final String method; // 'QR', 'Manual'
  final String? reason; // For manual logs

  const AttendanceRecordCard({
    super.key,
    required this.customerName,
    required this.phoneNumber,
    required this.mealType,
    required this.time,
    required this.status,
    required this.method,
    this.reason,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Status styling
    Color statusColor;
    Color statusBgColor;
    IconData statusIcon;

    if (status == 'Present') {
      statusColor = Colors.green;
      statusBgColor = Colors.green.withAlpha(20);
      statusIcon = Icons.check_circle_outline;
    } else if (status == 'Absent') {
      statusColor = Colors.red;
      statusBgColor = Colors.red.withAlpha(20);
      statusIcon = Icons.cancel_outlined;
    } else {
      statusColor = Colors.orange;
      statusBgColor = Colors.orange.withAlpha(20);
      statusIcon = Icons.pending_actions;
    }

    // Meal indicator icon & color
    IconData mealIcon;
    Color mealColor;
    if (mealType == 'Breakfast') {
      mealIcon = Icons.wb_twilight_outlined;
      mealColor = Colors.orange;
    } else if (mealType == 'Lunch') {
      mealIcon = Icons.wb_sunny_outlined;
      mealColor = Colors.blue;
    } else {
      mealIcon = Icons.nights_stay_outlined;
      mealColor = Colors.indigo;
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withAlpha(80),
          width: 0.8,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Circular initials avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: colorScheme.primaryContainer.withAlpha(120),
                  child: Text(
                    customerName.isNotEmpty ? customerName[0].toUpperCase() : 'U',
                    style: TextStyle(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Customer details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customerName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            phoneNumber,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // Dynamic Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: statusColor.withAlpha(40),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(statusIcon, size: 12, color: statusColor),
                      const SizedBox(width: 4),
                      Text(
                        status,
                        style: textTheme.labelSmall?.copyWith(
                          color: statusColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24, thickness: 0.6),
            // Bottom details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Configured meal
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: mealColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Icon(mealIcon, size: 14, color: mealColor),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mealType,
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                // Logging method
                Row(
                  children: [
                    Icon(
                      method == 'QR' ? Icons.qr_code_2 : Icons.edit_note_outlined,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$method Mode',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                // Timestamp
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      time,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (reason != null && reason!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withAlpha(80),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Reason: $reason',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
