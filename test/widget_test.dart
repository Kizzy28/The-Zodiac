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
    // Use a tall viewport so every item in the list renders without
    // needing to scroll (ListView.builder only builds visible items).
    tester.view.physicalSize = const Size(1080, 3600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const ZodiacApp());
    await tester.pumpAndSettle();

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

    await tester.tap(find.text('Pick your birthday'));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    final okButton = find.text('OK');
    expect(okButton, findsOneWidget);
    await tester.tap(okButton);
    await tester.pumpAndSettle();

    final expectedSign = signForDate(DateTime.now().month, DateTime.now().day);
    expect(find.text(expectedSign.symbol), findsWidgets);
    expect(find.textContaining(expectedSign.element), findsWidgets);
  });
}
