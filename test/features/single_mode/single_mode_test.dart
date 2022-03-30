import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

List<PlayboardDirection> _getDirections(Loc holeLoc, int boardSize) {
  getDirection() {
    if (holeLoc.dx == 0) {
      return PlayboardDirection.right;
    } else if (holeLoc.dx == boardSize) {
      return PlayboardDirection.left;
    } else if (holeLoc.dy == 0) {
      return PlayboardDirection.down;
    } else if (holeLoc.dy == boardSize) {
      return PlayboardDirection.up;
    }
    return PlayboardDirection.values[Random().nextInt(4)];
  }

  final dir = getDirection();
  final directions = {
    PlayboardDirection.down: {
      PlayboardDirection.left: [
        PlayboardDirection.down,
        PlayboardDirection.left,
        PlayboardDirection.up,
        PlayboardDirection.right,
      ],
      PlayboardDirection.right: [
        PlayboardDirection.down,
        PlayboardDirection.right,
        PlayboardDirection.up,
        PlayboardDirection.left,
      ],
    },
    PlayboardDirection.up: {
      PlayboardDirection.left: [
        PlayboardDirection.up,
        PlayboardDirection.left,
        PlayboardDirection.down,
        PlayboardDirection.right,
      ],
      PlayboardDirection.right: [
        PlayboardDirection.up,
        PlayboardDirection.right,
        PlayboardDirection.down,
        PlayboardDirection.left,
      ],
    },
    PlayboardDirection.left: {
      PlayboardDirection.down: [
        PlayboardDirection.left,
        PlayboardDirection.down,
        PlayboardDirection.right,
        PlayboardDirection.up,
      ],
      PlayboardDirection.up: [
        PlayboardDirection.left,
        PlayboardDirection.up,
        PlayboardDirection.down,
        PlayboardDirection.right,
      ],
    },
    PlayboardDirection.right: {
      PlayboardDirection.down: [
        PlayboardDirection.right,
        PlayboardDirection.down,
        PlayboardDirection.left,
        PlayboardDirection.up,
      ],
      PlayboardDirection.up: [
        PlayboardDirection.right,
        PlayboardDirection.up,
        PlayboardDirection.left,
        PlayboardDirection.down,
      ],
    },
  };

  final canGoDirection = () {
    switch (dir) {
      case PlayboardDirection.left:
        if (holeLoc.dy == 0) {
          return PlayboardDirection.down;
        } else {
          return PlayboardDirection.up;
        }
      case PlayboardDirection.right:
        if (holeLoc.dy == 0) {
          return PlayboardDirection.down;
        } else {
          return PlayboardDirection.up;
        }
      case PlayboardDirection.up:
        if (holeLoc.dx == 0) {
          return PlayboardDirection.right;
        } else {
          return PlayboardDirection.left;
        }
      case PlayboardDirection.down:
        if (holeLoc.dx == 0) {
          return PlayboardDirection.right;
        } else {
          return PlayboardDirection.left;
        }
    }
  }();

  return directions[dir]![canGoDirection]!;
}

Offset _getOffset(PlayboardDirection direction) {
  switch (direction) {
    case PlayboardDirection.up:
      return const Offset(0, 50);
    case PlayboardDirection.down:
      return const Offset(0, -50);
    case PlayboardDirection.left:
      return const Offset(50, 0);
    case PlayboardDirection.right:
      return const Offset(-50, 0);
  }
}

void main() {
  group('Single mode', () {
    group('Control board', () {
      testWidgets('Press tile', (tester) async {
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
      testWidgets('Keyboard control', (tester) async {
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

        final directions = _getDirections(holeLoc, boardSize);

        for (final direction in directions) {
          final holeLoc = state!.playboard.currentBoard.holeLoc;

          switch (direction) {
            case PlayboardDirection.up:
              await simulateKeyDownEvent(LogicalKeyboardKey.arrowDown);
              break;
            case PlayboardDirection.down:
              await simulateKeyDownEvent(LogicalKeyboardKey.arrowUp);
              break;
            case PlayboardDirection.left:
              await simulateKeyDownEvent(LogicalKeyboardKey.arrowRight);
              break;
            case PlayboardDirection.right:
              await simulateKeyDownEvent(LogicalKeyboardKey.arrowLeft);
              break;
          }
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          final newHoleLoc = holeLoc.move(boardSize, direction);
          expect(newHoleLoc, isNotNull);

          final actualHoleLoc =
              state!.playboard.currentLoc(boardSize * boardSize - 1);
          expect(actualHoleLoc, newHoleLoc);
        }
      });
      testWidgets('Swipe control', (tester) async {
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
        await tester.pumpAndSettle(const Duration(milliseconds: 700));
        expect(find.byType(PlayboardView), findsOneWidget);
        final preState = state!.clone();
        final boardSize = preState.playboard.size;
        final holeLoc = preState.playboard.currentBoard.holeLoc;

        final directions = _getDirections(holeLoc, boardSize);

        for (final direction in directions) {
          final holeLoc = state!.playboard.currentBoard.holeLoc;
          await tester.timedDrag(
            find.byKey(const ValueKey('hole-tile')),
            _getOffset(direction),
            const Duration(milliseconds: 150),
            buttons: kTouchContact,
            warnIfMissed: false,
          );
          await tester.pumpAndSettle(const Duration(milliseconds: 700));

          final newHoleLoc = holeLoc.move(boardSize, direction);

          final actualHoleLoc =
              state!.playboard.currentLoc(boardSize * boardSize - 1);
          expect(actualHoleLoc, newHoleLoc);
        }
      });
    });
    group('Setting screen', () {
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
      testWidgets('Change board size', (tester) async {
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
        await tester.pump();

        // Check PlayboardView exists
        expect(find.byType(PlayboardView), findsOneWidget);

        // Open setting menu
        await tester.tap(find.byIcon(LineIcons.cog));
        await tester.pump();

        await tester.tap(find.text('4 x 4'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(LineIcons.times));
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('number-tile-15')), findsOneWidget);
        expect(find.byKey(const ValueKey('number-tile-24')), findsNothing);

        await tester.tap(find.byIcon(LineIcons.cog));
        await tester.pump();
        await tester.tap(find.text('5 x 5'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(LineIcons.times));
        await tester.pumpAndSettle();
        expect(find.byType(PlayboardView), findsOneWidget);
        expect(find.byKey(const ValueKey('number-tile-15')), findsOneWidget);
        expect(find.byKey(const ValueKey('number-tile-24')), findsOneWidget);
      });
    });

    testWidgets('Shuffle 3x3 puzzle', (tester) async {
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

      await tester.tap(find.byIcon(LineIcons.syncIcon));
      await tester.pumpAndSettle();
      expect(
        preState.playboard.currentBoard,
        isNot(state!.playboard.currentBoard),
      );
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

      for (int i = 0; i < 10; i++) {
        await tester.tap(find.byKey(const Key('play-again-button')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('SOLVE'));
        await tester.pumpAndSettle();

        expect(find.text('You win!'), findsOneWidget);
      }
    });
    testWidgets('Win and refresh', (tester) async {
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
      await tester.tap(find.byKey(const Key('play-again-button')));
      await tester.pumpAndSettle();

      expect(find.text('You win!'), findsNothing);
      expect(find.byType(PlayboardView), findsOneWidget);
    });
  });
}
