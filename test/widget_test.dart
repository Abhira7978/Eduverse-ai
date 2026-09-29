import 'package:eduverse_responsive/main.dart';
import 'package:eduverse_responsive/state/locale_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('EduVerse welcome screen renders', (WidgetTester tester) async {
    final localeController = LocaleController();

    await tester.pumpWidget(EduVerseApp(localeController: localeController));

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
