import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slideparty/src/features/home/home.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';

import '../../mocks/test_app.dart';

void main() {
  group('Home', () {
    testWidgets('Change dark-theme', (tester) async {
      final t = await testApp(const HomePage());

      await tester.pumpWidget(t.$1);
      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.byType(HomePage));

      expect(find.byIcon(Icons.light_mode), findsOneWidget);
      expect(find.byIcon(Icons.dark_mode), findsNothing);
      expect(Theme.of(context).colorScheme.brightness, Brightness.dark);
      await tester.tap(find.byIcon(Icons.light_mode));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
      expect(find.byIcon(Icons.light_mode), findsNothing);
      expect(Theme.of(context).colorScheme.brightness, Brightness.light);
    });

    testWidgets('Change app color', (tester) async {
      final t = await testApp(const HomePage());

      await tester.pumpWidget(t.$1);
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('color-picker')), findsNothing);
      expect(find.byIcon(Icons.arrow_circle_up_outlined), findsOneWidget);
      expect(find.byIcon(Icons.arrow_circle_down_outlined), findsNothing);
      await tester.tap(find.byIcon(Icons.arrow_circle_up_outlined));
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('color-picker')), findsOneWidget);
      expect(find.byIcon(Icons.arrow_circle_up_outlined), findsNothing);
      expect(find.byIcon(Icons.arrow_circle_down_outlined), findsOneWidget);

      expect(
        Theme.of(tester.element(find.byType(HomePage))).colorScheme.primary,
        ButtonColors.yellow.primaryColor,
      );

      await tester.tap(find.text('B'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(HomePage))).colorScheme.primary,
        equals(ButtonColors.blue.primaryColor),
      );

      await tester.tap(find.text('G'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(HomePage))).colorScheme.primary,
        equals(ButtonColors.green.primaryColor),
      );

      await tester.tap(find.text('R'));
      await tester.pumpAndSettle();
      expect(
        Theme.of(tester.element(find.byType(HomePage))).colorScheme.primary,
        equals(ButtonColors.red.primaryColor),
      );
    });
  });
}
