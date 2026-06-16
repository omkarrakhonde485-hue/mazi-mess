import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LeaveCalendarWidget extends StatelessWidget {
  const LeaveCalendarWidget({
    super.key,
    required this.displayedMonth,
    required this.leaveDates,
    required this.lockedDates,
    required this.onMonthChanged,
    required this.onDatePressed,
    required this.onLockedDatePressed,
  });

  final DateTime displayedMonth;
  final Set<DateTime> leaveDates;
  final Set<DateTime> lockedDates;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDatePressed;
  final ValueChanged<DateTime> onLockedDatePressed;

  static const _weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

  @override
  Widget build(BuildContext context) {
    final month = DateTime(displayedMonth.year, displayedMonth.month);
    final days = _buildMonthDays(month);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  tooltip: 'Previous month',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () =>
                      onMonthChanged(DateTime(month.year, month.month - 1)),
                ),
                Expanded(
                  child: Text(
                    DateFormat('MMMM yyyy').format(month),
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Next month',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () =>
                      onMonthChanged(DateTime(month.year, month.month + 1)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.builder(
              itemCount: _weekdays.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.2,
              ),
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    _weekdays[index],
                    style: textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
            GridView.builder(
              itemCount: days.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                final day = days[index];
                if (day == null) {
                  return const SizedBox.shrink();
                }

                final normalizedDay = DateUtils.dateOnly(day);
                final isLeaveDate = leaveDates.contains(normalizedDay);
                final isLocked = lockedDates.contains(normalizedDay);
                final isToday = DateUtils.isSameDay(
                  normalizedDay,
                  DateUtils.dateOnly(DateTime.now()),
                );

                return _CalendarDay(
                  day: normalizedDay,
                  isLeaveDate: isLeaveDate,
                  isLocked: isLocked,
                  isToday: isToday,
                  onPressed: isLocked
                      ? () => onLockedDatePressed(normalizedDay)
                      : () => onDatePressed(normalizedDay),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static List<DateTime?> _buildMonthDays(DateTime month) {
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingBlankDays = firstDay.weekday % 7;
    final itemCount =
        ((leadingBlankDays + daysInMonth) / DateTime.daysPerWeek).ceil() *
        DateTime.daysPerWeek;

    return List<DateTime?>.generate(itemCount, (index) {
      final dayNumber = index - leadingBlankDays + 1;
      if (dayNumber < 1 || dayNumber > daysInMonth) {
        return null;
      }
      return DateTime(month.year, month.month, dayNumber);
    });
  }
}

class _CalendarDay extends StatelessWidget {
  const _CalendarDay({
    required this.day,
    required this.isLeaveDate,
    required this.isLocked,
    required this.isToday,
    required this.onPressed,
  });

  final DateTime day;
  final bool isLeaveDate;
  final bool isLocked;
  final bool isToday;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final backgroundColor = switch ((isLeaveDate, isLocked)) {
      (true, true) => colorScheme.secondaryContainer,
      (true, false) => colorScheme.primaryContainer,
      (false, true) => colorScheme.surfaceContainerHighest,
      (false, false) => colorScheme.surface,
    };
    final foregroundColor = switch ((isLeaveDate, isLocked)) {
      (true, true) => colorScheme.onSecondaryContainer,
      (true, false) => colorScheme.onPrimaryContainer,
      (false, true) => colorScheme.onSurfaceVariant,
      (false, false) => colorScheme.onSurface,
    };
    final borderColor = isToday
        ? colorScheme.primary
        : isLocked
        ? colorScheme.outlineVariant
        : Colors.transparent;

    return Material(
      key: ValueKey<DateTime>(day),
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: isToday ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              '${day.day}',
              style: textTheme.labelLarge?.copyWith(
                color: foregroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isLocked)
              Positioned(
                right: 4,
                top: 4,
                child: Icon(
                  Icons.lock_outline,
                  size: 12,
                  color: foregroundColor,
                ),
              ),
            if (isToday)
              Positioned(
                bottom: 4,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
