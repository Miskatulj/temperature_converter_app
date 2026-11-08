import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:module20/main.dart';

void main() {
  testWidgets('converts Celsius to Fahrenheit', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.enterText(find.byType(EditableText), '100');
    await tester.tap(find.text('Convert'));
    await tester.pump();

    expect(find.text('212.00 °F'), findsOneWidget);
  });

  testWidgets('shows an error for an empty temperature', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.text('Convert'));
    await tester.pump();

    expect(find.text('Please enter a temperature.'), findsOneWidget);
  });

  testWidgets('converts Fahrenheit to Celsius', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.byType(DropdownButtonFormField<ConversionType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fahrenheit to Celsius (°F → °C)').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(EditableText), '72');
    await tester.tap(find.text('Convert'));
    await tester.pump();

    expect(find.text('22.22 °C'), findsOneWidget);
  });

  testWidgets('shows an error for non-numeric input', (tester) async {
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.enterText(find.byType(EditableText), 'warm');
    await tester.tap(find.text('Convert'));
    await tester.pump();

    expect(find.text('Please enter a valid number.'), findsOneWidget);
  });

  testWidgets('dropdown does not overflow on a narrow mobile screen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const TemperatureConverterApp());

    await tester.tap(find.byType(DropdownButtonFormField<ConversionType>));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
