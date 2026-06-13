import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mazi_mess/main.dart';

void main() {
  testWidgets('App renders customer home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaziMessApp()));
    await tester.pump();

    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.text('Current Subscription'), findsOneWidget);
    expect(find.text('Sai Mess'), findsOneWidget);
  });
}
