// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';

void main() {
  testWidgets('Galaxy app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const GalaxyApp());

    // Verify that our app title is present.
    expect(find.text('GALAXY EXPLORER'), findsOneWidget);

    // Verify that we can find our planets (first one should be Mars).
    // Note: Since it's uppercase in the UI.
    expect(find.text('MARS'), findsOneWidget);
    
    // Verify that the floating action button exists.
    expect(find.byIcon(Icons.radar), findsOneWidget);
  });
}
