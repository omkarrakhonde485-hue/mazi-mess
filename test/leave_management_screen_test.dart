import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

import 'package:mazi_mess/features/leave_management/screens/leave_management_screen.dart';

void main() {
  testWidgets('near leave can be added but not removed inside lock window', (
    tester,
  ) async {
    await _pumpLeaveManagementScreen(tester);

    final tomorrow = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(days: 1));
    final dateText = _dateFormat.format(tomorrow);

    await tester.tap(find.byKey(ValueKey<DateTime>(tomorrow)));
    await tester.pumpAndSettle();

    expect(find.text(dateText), findsWidgets);

    await tester.tap(find.byKey(ValueKey<DateTime>(tomorrow)));
    await tester.pump();

    expect(
      find.text('Leave inside the lock window cannot be removed'),
      findsOneWidget,
    );

    await tester.pumpAndSettle();

    expect(find.text(dateText), findsWidgets);
  });

  testWidgets('later leave can be added and removed', (tester) async {
    await _pumpLeaveManagementScreen(tester);

    final laterDate = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(days: 3));
    final dateText = _dateFormat.format(laterDate);

    await tester.tap(find.byKey(ValueKey<DateTime>(laterDate)));
    await tester.pumpAndSettle();

    expect(find.text(dateText), findsOneWidget);

    await tester.tap(find.byKey(ValueKey<DateTime>(laterDate)));
    await tester.pumpAndSettle();

    expect(find.text(dateText), findsNothing);
  });

  testWidgets('mock locked date cannot be modified', (tester) async {
    await _pumpLeaveManagementScreen(tester);

    final lockedDate = DateUtils.dateOnly(
      DateTime.now(),
    ).add(const Duration(days: 6));

    await tester.tap(find.byKey(ValueKey<DateTime>(lockedDate)));
    await tester.pump();

    expect(find.text('Locked dates cannot be modified'), findsOneWidget);
  });
}

final _dateFormat = DateFormat('EEE, d MMM yyyy');

Future<void> _pumpLeaveManagementScreen(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1080, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    const ProviderScope(child: MaterialApp(home: LeaveManagementScreen())),
  );
  await tester.pumpAndSettle();
}
