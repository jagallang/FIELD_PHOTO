import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:pol_photo/main.dart';
import 'package:pol_photo/core/di/injection_container.dart' as di;

void main() {
  setUp(() async {
    // Initialize dependency injection before each test
    await di.init();
  });

  testWidgets('POL PHOTO App smoke test', (WidgetTester tester) async {
    // Setup EasyLocalization for testing
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [
          Locale('ko'),
          Locale('en'),
        ],
        path: 'assets/translations',
        fallbackLocale: const Locale('ko'),
        startLocale: const Locale('ko'),
        child: const PhotoLayoutApp(),
      ),
    );

    // Wait for localization to load
    await tester.pumpAndSettle();

    // Verify that the app loads correctly
    // Check for key UI elements
    expect(find.byType(MaterialApp), findsOneWidget);
    
    // Check that the photo editor screen is displayed
    expect(find.byKey(const Key('photo_editor_screen')), findsOneWidget);
    
    // Verify basic UI structure
    expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
  });
}