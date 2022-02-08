import 'package:flutter_test/flutter_test.dart';
import 'package:slideparty/src/features/multiple_mode/multiple_mode.dart';
import 'package:slideparty/src/features/multiple_mode/screens/multiple_playground.dart';

import '../../mocks/test_app.dart';

void main() {
  testWidgets('Multiple mode page', (tester) async {
    await testRouterApp(tester, initialRoute: '/m_mode');

    expect(find.byType(MultipleModePage), findsOneWidget);

    expect(find.text('2'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);

    expect(find.text('3 x 3'), findsOneWidget);
    expect(find.text('4 x 4'), findsOneWidget);
    expect(find.text('5 x 5'), findsOneWidget);
  });
  testWidgets('3 x 3 and 2 players', (tester) async {
    await testRouterApp(tester, initialRoute: '/m_mode');

    expect(find.byType(MultipleModePage), findsOneWidget);

    await tester.tap(find.text('3 x 3'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('2'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.byType(MultiplePlayground), findsOneWidget);
  });
}
