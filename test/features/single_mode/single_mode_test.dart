// ignore_for_file: invalid_use_of_protected_member

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';
import 'package:slideparty/src/features/single_mode/single_mode.dart';
import 'package:slideparty/src/features/single_mode/widgets/single_mode_setting.dart';

import '../../mocks/test_app.dart';

void main() {
  group('Single mode', () {
    testWidgets('Move hole tile around', (tester) async {
      SinglePlayboardState? state;

      final t = await testApp(
        ProviderScope(
          overrides: [
            playboardControllerProvider
                .overrideWithProvider(singleModeControllerProvider),
          ],
          child: HookConsumer(
            builder: (context, ref, child) {
              final _state = ref.watch(playboardControllerProvider);
              final _memo = useMemoized(() {
                state = _state as SinglePlayboardState;
                return null;
              }, [_state]);
              _memo;
              return child!;
            },
            child: const SingleModePage(),
          ),
        ),
      );
      final widget = t.first;
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
      expect(find.byType(PlayboardView), findsOneWidget);
      final preState = state!.clone();
      final boardSize = preState.playboard.size;
      final holeLoc = preState.playboard.currentBoard.holeLoc;
      final direction = () {
        if (holeLoc.dx == 0) {
          return PlayboardDirection.right;
        } else if (holeLoc.dx == preState.playboard.size - 1) {
          return PlayboardDirection.left;
        } else if (holeLoc.dy == 0) {
          return PlayboardDirection.down;
        } else if (holeLoc.dy == preState.playboard.size - 1) {
          return PlayboardDirection.up;
        }
        return PlayboardDirection.values[Random().nextInt(4)];
      }();

      final newHoleLoc = holeLoc.move(boardSize, direction);
      expect(newHoleLoc, isNotNull);

      final holeIndex = newHoleLoc!.index(boardSize);
      await tester.tap(
        find.byKey(ValueKey('number-tile-$holeIndex')),
        warnIfMissed: true,
      );
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final actualHoleLoc =
          state!.playboard.currentLoc(boardSize * boardSize - 1);
      expect(actualHoleLoc, newHoleLoc);
    });
    testWidgets('Open setting menu', (tester) async {
      final t = await testApp(
        ProviderScope(
          overrides: [
            playboardControllerProvider
                .overrideWithProvider(singleModeControllerProvider),
          ],
          child: const SingleModePage(),
        ),
      );
      final widget = t.first;
      await tester.pumpWidget(widget);
      await tester.pump(const Duration(milliseconds: 500));

      // Check PlayboardView exists
      expect(find.byType(PlayboardView), findsOneWidget);

      // Open setting menu
      await tester.tap(find.byIcon(LineIcons.cog));
      await tester.pump();

      // Check SingleModeSetting exists
      expect(find.byType(SingleModeSetting), findsOneWidget);
      expect(find.text('Un-mute'), findsOneWidget);

      await tester.tap(find.text('Un-mute'));
      await tester.pump();
      expect(find.text('Un-mute'), findsNothing);
      expect(find.text('Mute'), findsOneWidget);

      await tester.tap(find.byIcon(LineIcons.times));
      await tester.pump();
      expect(find.byType(SingleModeSetting), findsNothing);
    });
    testWidgets('Auto solving and win', (tester) async {
      final t = await testApp(
        ProviderScope(
          overrides: [
            playboardControllerProvider
                .overrideWithProvider(singleModeControllerProvider),
          ],
          child: const SingleModePage(),
        ),
      );
      final widget = t.first;
      await tester.pumpWidget(widget);
      await tester.pump(const Duration(milliseconds: 500));

      // Check PlayboardView exists
      expect(find.byType(PlayboardView), findsOneWidget);

      await tester.tap(find.text('SOLVE'));
      await tester.pumpAndSettle();

      expect(find.text('You win!'), findsOneWidget);
    });
  });
}
