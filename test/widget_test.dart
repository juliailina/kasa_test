import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kasa/main.dart';

void main() {
  testWidgets('shows the expense list with a running total', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KasaApp());
    await tester.pumpAndSettle();

    expect(find.text('Kasa'), findsOneWidget);
    expect(find.textContaining('Total:'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets('toggling the theme switches the app bar icon', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const KasaApp());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.dark_mode), findsOneWidget);

    await tester.tap(find.byIcon(Icons.dark_mode));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.light_mode), findsOneWidget);
  });
}
