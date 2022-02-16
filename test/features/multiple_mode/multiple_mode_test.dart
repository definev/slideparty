import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:slideparty/src/features/multiple_mode/multiple_mode.dart';
import 'package:slideparty/src/features/multiple_mode/screens/multiple_playground.dart';

import '../../mocks/test_app.dart';

Future<void> _multipleModeSetUp(WidgetTester tester) async {
  await testRouterApp(tester, initialRoute: '/m_mode');
  expect(find.byType(MultipleModePage), findsOneWidget);
}

Future<void> _selectBoardSizeAndPlayer(
  WidgetTester tester,
  int boardSize,
  int player,
) async {
  await tester.tap(find.text('$boardSize x $boardSize'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('$player'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Start'));
  await tester.pumpAndSettle();

  expect(find.byType(MultiplePlayground), findsOneWidget);
}

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

  group('3x3 board', () {
    testWidgets('3 x 3 and 2 players (Big screen, horizontal prefer)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1440, 1080);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 3, 2);

      expect(find.text('P.0'), findsOneWidget);
      expect(find.text('P.1'), findsOneWidget);
      expect(find.text('Skills'), findsWidgets);
    });

    testWidgets('3 x 3 and 2 players (Big screen, vertical prefer)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1440);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 3, 2);

      expect(find.text('P.0'), findsOneWidget);
      expect(find.text('P.1'), findsOneWidget);
      expect(find.text('Skills'), findsWidgets);
    });

    testWidgets('3 x 3 and 2 players (Small screen)', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(500, 500);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 3, 2);

      expect(find.byType(HoleMenu), findsWidgets);
    });

    testWidgets('Pause action', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1440, 1080);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 3, 2);

      fakeAsync((async) {
        simulateKeyDownEvent(LogicalKeyboardKey.keyX);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(milliseconds: 500));
        async.elapse(const Duration(milliseconds: 300));
        simulateKeyDownEvent(LogicalKeyboardKey.keyS);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(milliseconds: 500));
        async.elapse(const Duration(milliseconds: 300));
        simulateKeyDownEvent(LogicalKeyboardKey.keyA);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(seconds: 1));
        async.elapse(const Duration(seconds: 1));

        expect(find.byType(PauseAction), findsOneWidget);
        async.elapse(const Duration(seconds: 10));
        tester.pump();
        async.elapse(const Duration(milliseconds: 500));
        expect(find.byType(PauseAction), findsNothing);
      });
    });

    testWidgets('Blind action', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1440, 1080);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 4, 2);

      fakeAsync((async) async {
        simulateKeyDownEvent(LogicalKeyboardKey.keyX);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(milliseconds: 500));
        async.elapse(const Duration(seconds: 1));
        simulateKeyDownEvent(LogicalKeyboardKey.keyA);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(milliseconds: 500));
        async.elapse(const Duration(seconds: 1));
        simulateKeyDownEvent(LogicalKeyboardKey.keyA);
        async.elapse(const Duration(milliseconds: 300));
        tester.pumpAndSettle(const Duration(seconds: 1));
        async.elapse(const Duration(seconds: 1));
        expect(
            find.byKey(const ValueKey('blind-number-tile-0')), findsOneWidget);
        async.elapse(const Duration(seconds: 10));
        tester.pump();
        async.elapse(const Duration(milliseconds: 300));
        expect(find.byKey(const ValueKey('blind-number-tile-0')), findsNothing);
      });
    });
  });

  group('4x4 board', () {
    testWidgets('4 x 4 and 2 players (Big screen, horizontal prefer)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1440, 1080);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 4, 2);

      expect(find.text('P.0'), findsOneWidget);
      expect(find.text('P.1'), findsOneWidget);
      expect(find.text('Skills'), findsWidgets);
    });

    testWidgets('4 x 4 and 3 players (Big screen, vertical prefer)',
        (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(1080, 1440);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 4, 3);

      expect(find.text('P.0'), findsOneWidget);
      expect(find.text('P.1'), findsOneWidget);
      expect(find.text('P.2'), findsOneWidget);
      expect(find.text('Skills'), findsWidgets);
    });

    testWidgets('4 x 4 and 4 players (Small screen)', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 700);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 4, 4);

      expect(find.byType(HoleMenu), findsWidgets);
    });

    testWidgets('Show pickup skill screen and pause action', (tester) async {
      tester.binding.window.physicalSizeTestValue = const Size(700, 700);
      tester.binding.window.devicePixelRatioTestValue = 1.0;
      addTearDown(tester.binding.window.clearPhysicalSizeTestValue);

      await _multipleModeSetUp(tester);
      await _selectBoardSizeAndPlayer(tester, 4, 2);

      expect(find.byType(HoleMenu), findsWidgets);

      await tester.tap(find.byKey(const ValueKey('HoleMenu: 0')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('Owner 0 - Action pause')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('Owner 0 - Target 1')));
      await tester.pumpAndSettle();

      await tester.runAsync(() async {
        await tester.tap(find.byKey(const ValueKey('Owner 0 - Apply skill')));
        await tester.pump(const Duration(milliseconds: 100));
        expect(find.byType(PauseAction), findsOneWidget);

        await tester.tap(find.byKey(const ValueKey('HoleMenu: 1')));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const ValueKey('Owner 1 - Action clear')));
        await tester.pumpAndSettle();

        expect(find.byType(PauseAction), findsNothing);
      });
    });
  });
}
