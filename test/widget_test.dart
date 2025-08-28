// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:galleria_app/main.dart';
import 'package:galleria_app/screen/home_screen.dart';
import 'package:galleria_app/screen/onboarding_screen.dart';

void main() {
  testWidgets('App should show onboarding screen on first launch', (WidgetTester tester) async {
    // Set up SharedPreferences for first launch
    SharedPreferences.setMockInitialValues({});

    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp(showOnboarding: true));
    await tester.pumpAndSettle(); // Wait for animations

    // Verify that onboarding screen is shown
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.byType(HomeScreen), findsNothing);

    // Verify onboarding content
    expect(find.text('Welcome to Your Fitness Journey'), findsOneWidget);
    expect(find.text('Track Your Progress'), findsOneWidget);
    expect(find.text('Stay Motivated'), findsOneWidget);
  });

  testWidgets('App should show home screen after onboarding is complete', (WidgetTester tester) async {
    // Set up SharedPreferences with onboarding completed
    SharedPreferences.setMockInitialValues({'ON_BOARDING': false});

    // Build our app and trigger a frame
    await tester.pumpWidget(const MyApp(showOnboarding: false));
    await tester.pumpAndSettle(); // Wait for animations

    // Verify that home screen is shown
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(OnboardingScreen), findsNothing);
  });
}
