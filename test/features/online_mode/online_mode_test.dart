import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:slideparty/src/features/online_mode/screens/online_playboard_page.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

import '../../mocks/test_app.dart';

Future<StreamController<ServerState>> _setupSocketApp(
  WidgetTester tester, {
  required String initialRoute,
}) async {
  var stateStreamController = StreamController<ServerState>.broadcast();

  await testOnlineModeApp(
    tester,
    initialRoute: initialRoute,
    send: (event) async => event.map(
      joinRoom: (_) => stateStreamController.add(const Connected()),
      sendBoard: (sendBoard) async {
        final last = await stateStreamController.stream.last;
        if (last is Connected) {
          var roomData = RoomData(
            code: '/3/123456',
            players: {
              '0': PlayerData(
                id: '0',
                affectedActions: {},
                color: PlayerColors.values[0],
                currentBoard: Playboard.random(3).currentBoard,
                usedActions: [],
              ),
              '1': PlayerState.data(
                id: '1',
                currentBoard: Playboard.random(3).currentBoard,
                color: PlayerColors.values[1],
                affectedActions: {},
                usedActions: [],
              ),
            },
          );
          stateStreamController.add(roomData);
          return;
        }
        expect(last.runtimeType, RoomData);
        var roomData = (last as RoomData)
          ..copyWith(
            players: {
              ...last.players,
              '0': last.players['0']!.copyWith(currentBoard: sendBoard.board),
            },
          );
        stateStreamController.add(roomData);
        return null;
      },
      sendAction: (sendAction) async {
        final last = await stateStreamController.stream.last;
        expect(last.runtimeType, RoomData);
        var roomData = (last as RoomData)
          ..copyWith(
            players: {
              ...last.players,
              '0': last.players['0']!.copyWith(
                affectedActions: {
                  ...last.players['0']!.affectedActions,
                  sendAction.affectedPlayerId: [
                    ...(last.players['0']!
                            .affectedActions[sendAction.affectedPlayerId] ??
                        []),
                    sendAction.action,
                  ],
                },
              ),
              sendAction.affectedPlayerId:
                  last.players[sendAction.affectedPlayerId]!.copyWith(
                usedActions: [
                  ...last.players[sendAction.affectedPlayerId]!.usedActions,
                  sendAction.action,
                ],
              ),
            },
          );
        stateStreamController.add(roomData);
        return null;
      },
      restart: (restart) => stateStreamController.add(const Restarting()),
    ),
    stateStream: stateStreamController.stream,
  );

  return stateStreamController;
}

void main() {
  group('Online mode', () {
    group('Online select page', () {
      testWidgets('Enter online room picker', (tester) async {
        await _setupSocketApp(tester, initialRoute: '/o_mode');
        await tester.pumpAndSettle();

        expect(find.text('ONLINE MODE'), findsOneWidget);
      });

      testWidgets('Select room and board size', (tester) async {
        await _setupSocketApp(tester, initialRoute: '/o_mode');
        await tester.pumpAndSettle();

        expect(find.text('ONLINE MODE'), findsOneWidget);
        await tester.enterText(
          find.byKey(const ValueKey('room-code-text-field')),
          '123456',
        );
        await tester.tap(find.text('JOIN ROOM'));

        BuildContext context = tester.allElements.last;
        expect(GoRouter.of(context).location, equals('/o_mode/3/123456'));
      });
    });

    // group('Online play screen', () {
    //   testWidgets('Select room and board size', (tester) async {
    //     final stateStreamController =
    //         await _setupSocketApp(tester, initialRoute: '/o_mode/3/123456');
    //     fakeAsync((async) {
    //       tester.pump();
    //       async.elapse(const Duration(milliseconds: 250));
    //       stateStreamController.add(const Connected());
    //       tester.pump();
    //       async.elapse(const Duration(milliseconds: 250));

    //       BuildContext context = tester.allElements.last;
    //       expect(GoRouter.of(context).location, equals('/o_mode/3/123456'));

    //       expect(find.byType(OnlinePlayboardPage), findsOneWidget);

    //       async.elapse(const Duration(seconds: 10));
    //       tester.pump();
    //       async.elapse(const Duration(milliseconds: 250));

    //       expect(find.byType(CircularProgressIndicator), findsNothing);
    //     });
    //   });
    // });
  });
}
