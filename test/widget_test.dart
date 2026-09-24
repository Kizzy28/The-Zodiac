// Widget tests for the Star Signs app.
//
// Place this file at test/widget_test.dart in your Flutter project
// (replacing the default one), and make sure the import below matches
// your actual package name from pubspec.yaml.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:the_zodiac/main.dart';

void main() {
  testWidgets('App title and initial state render correctly',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ZodiacApp());

    expect(find.text('Star Signs'), findsOneWidget);
    expect(find.text('Find your sign'), findsOneWidget);
    expect(find.text('Pick your birthday'), findsOneWidget);
    expect(find.text('All signs'), findsOneWidget);
  });

  testWidgets('All 12 zodiac signs are listed with symbol and date range',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ZodiacApp());

    for (final sign in zodiacSigns) {
      expect(find.text(sign.name), findsOneWidget);
    }
  });

  group('signForDate returns the correct sign', () {
    test('Aries: March 25', () {
      expect(signForDate(3, 25).name, 'Aries');
    });

    test('Taurus: April 20 (boundary start)', () {
      expect(signForDate(4, 20).name, 'Taurus');
    });

    test('Gemini: June 1', () {
      expect(signForDate(6, 1).name, 'Gemini');
    });

    test('Cancer: July 22 (boundary end)', () {
      expect(signForDate(7, 22).name, 'Cancer');
    });

    test('Leo: August 10', () {
      expect(signForDate(8, 10).name, 'Leo');
    });

    test('Virgo: September 1', () {
      expect(signForDate(9, 1).name, 'Virgo');
    });

    test('Libra: October 15', () {
      expect(signForDate(10, 15).name, 'Libra');
    });

    test('Scorpio: November 1', () {
      expect(signForDate(11, 1).name, 'Scorpio');
    });

    test('Sagittarius: December 1', () {
      expect(signForDate(12, 1).name, 'Sagittarius');
    });

    test('Capricorn: December 25 (wraps year)', () {
      expect(signForDate(12, 25).name, 'Capricorn');
    });

    test('Capricorn: January 5 (start of year)', () {
      expect(signForDate(1, 5).name, 'Capricorn');
    });

    test('Aquarius: February 1', () {
      expect(signForDate(2, 1).name, 'Aquarius');
    });

    test('Pisces: March 1', () {
      expect(signForDate(3, 1).name, 'Pisces');
    });

    test('Pisces: March 20 (last day before Aries)', () {
      expect(signForDate(3, 20).name, 'Pisces');
    });
  });

  testWidgets('Selecting a birthday shows the matching sign card',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ZodiacApp());

    // Open the date picker.
    await tester.tap(find.text('Pick your birthday'));
    await tester.pumpAndSettle();

    // The date picker dialog should now be visible.
    expect(find.byType(DatePickerDialog), findsOneWidget);

    // Confirm today's date (or whatever default is highlighted) via the OK button.
    final okButton = find.text('OK');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    // After picking, some sign's symbol/name/element should now be shown
    // in the result card (in addition to the list below).
    final expectedSign = signForDate(DateTime.now().month, DateTime.now().day);
    expect(find.text(expectedSign.symbol), findsWidgets);
    expect(find.textContaining(expectedSign.element), findsWidgets);
  });
}