import 'package:flutter/material.dart';
import '../screens/customer_management_screen.dart';

class CustomerCard extends StatelessWidget {
  final MockCustomer customer;
  final VoidCallback onViewProfile;
  final VoidCallback onRenewSubscription;
  final VoidCallback onMarkPayment;
  final VoidCallback onRemoveCustomer;

  const CustomerCard({
    super.key,
    required this.customer,
    required this.onViewProfile,
    required this.onRenewSubscription,
    required this.onMarkPayment,
    required this.onRemoveCustomer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // Attendance label styling
    Color attendanceBgColor = colorScheme.surfaceContainerHighest;
    Color attendanceTextColor = colorScheme.onSurfaceVariant;
    if (customer.todayAttendance.startsWith('Marked')) {
      attendanceBgColor = Colors.green.withAlpha(20);
      attendanceTextColor = Colors.green[800]!;
    } else if (customer.todayAttendance == 'On Leave') {
      attendanceBgColor = Colors.amber.withAlpha(20);
      attendanceTextColor = Colors.amber[800]!;
    }

    // Status label styling
    Color statusColor;
    if (customer.status == 'Active') {
      statusColor = Colors.green;
    } else if (customer.status == 'On Leave') {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.red;
    }

    // Payment badge styling
    Color paymentColor;
    Color paymentBgColor;
    if (customer.paymentStatus == 'Paid') {
      paymentColor = Colors.green[800]!;
      paymentBgColor = Colors.green.withAlpha(20);
    } else if (customer.paymentStatus == 'Pending') {
      paymentColor = Colors.orange[800]!;
      paymentBgColor = Colors.orange.withAlpha(20);
    } else if (customer.paymentStatus == 'Overdue') {
      paymentColor = Colors.red[800]!;
      paymentBgColor = Colors.red.withAlpha(20);
    } else {
      paymentColor = Colors.grey[800]!;
      paymentBgColor = Colors.grey.withAlpha(20);
    }

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row with status indicator & payment status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Attendance block
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: attendanceBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        customer.todayAttendance == 'On Leave'
                            ? Icons.time_to_leave_outlined
                            : Icons.check_circle_outline,
                        size: 14,
                        color: attendanceTextColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Today: ${customer.todayAttendance}',
                        style: textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: attendanceTextColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Subscription status dot & tag
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      customer.status,
                      style: textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Customer Photo
                CircleAvatar(
                  radius: 26,
                  backgroundImage: customer.avatarUrl.isNotEmpty
                      ? NetworkImage(customer.avatarUrl)
                      : null,
                  backgroundColor: colorScheme.primaryContainer,
                  child: customer.avatarUrl.isEmpty
                      ? Text(
                          customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C',
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 14),

                // Main basic details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            customer.mobileNumber,
                            style: textTheme.bodyMedium?.copyWith(
                              letterSpacing: 0.5,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Payment Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: paymentBgColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    customer.paymentStatus,
                    style: textTheme.labelSmall?.copyWith(
                      color: paymentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // Plan Info Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Plan',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      customer.currentPlan,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Subscription Expiry',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${customer.subscriptionExpiry.day} ${_getMonthName(customer.subscriptionExpiry.month)} ${customer.subscriptionExpiry.year}',
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: customer.status == 'Expired' ? colorScheme.error : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 24),

            // Inline actions bar (Scrollable to comfortably fit 4 actions on smaller screens)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Action 1: View Profile
                  _buildActionButton(
                    context,
                    label: 'Profile',
                    icon: Icons.person_outline,
                    onTap: onViewProfile,
                  ),
                  _buildDivider(colorScheme),

                  // Action 2: Renew Subscription
                  _buildActionButton(
                    context,
                    label: 'Renew',
                    icon: Icons.autorenew,
                    onTap: onRenewSubscription,
                  ),
                  _buildDivider(colorScheme),

                  // Action 3: Mark Paid
                  _buildActionButton(
                    context,
                    label: 'Payment',
                    icon: Icons.currency_rupee,
                    onTap: onMarkPayment,
                  ),
                  _buildDivider(colorScheme),

                  // Action 4: Remove Customer
                  _buildActionButton(
                    context,
                    label: 'Remove',
                    icon: Icons.person_remove_outlined,
                    iconColor: colorScheme.error,
                    onTap: onRemoveCustomer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(ColorScheme colorScheme) {
    return Container(
      height: 20,
      width: 1,
      color: colorScheme.outlineVariant,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return TextButton.icon(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      icon: Icon(
        icon,
        size: 16,
        color: iconColor ?? colorScheme.primary,
      ),
      label: Text(
        label,
        style: textTheme.labelMedium?.copyWith(
          color: iconColor ?? colorScheme.primary,
          fontWeight: FontWeight.bold,
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
