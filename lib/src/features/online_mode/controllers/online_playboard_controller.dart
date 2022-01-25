import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/utils/display_party_types.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

final onlinePlayboardControlllerProvider = StateNotifierProvider.autoDispose
    .family<PlayboardController, PlayboardState, RoomInfo>((ref, info) {
  return OnlinePlayboardController(info);
});

class OnlinePlayboardController
    extends PlayboardController<OnlinePlayboardState>
    with PlayboardGestureControlHelper, PlayboardKeyboardControlHelper {
  OnlinePlayboardController(this.info)
      : _ssk = SlidepartySocket(info),
        super(
          OnlinePlayboardState(
            playerId: '',
            state: ServerState.waiting(),
          ),
        ) {
    state = state.initPlayerId(_ssk.userId);
    _sub = _ssk.state.listen((event) {
      state = state.copyWith(state: event);
    });
  }

  final RoomInfo info;
  final SlidepartySocket _ssk;
  late final StreamSubscription _sub;

  void initController() {
    final board = Playboard.random(info.boardSize);
    _ssk.send(ClientEvent.sendBoard(board.currentBoard));
  }

  @override
  void dispose() {
    debugPrint('Online playboard controller disposed');
    _sub.cancel();
    _ssk.close();
    super.dispose();
  }

  void changeDisplayMode(DisplayModes displayMode) {
    if (state.displayMode != displayMode) {
      state = state.copyWith(displayMode: displayMode);
    }
  }

  void move(int index) {
    final player = (state.state as RoomData).players[state.playerId]!;
    if (player.currentBoard.isSolved) return;
    final playboard = player.currentBoard.move(index);
    if (playboard != null) updatePlayboardState(playboard);
  }

  void updatePlayboardState(List<int> playboard) {
    _ssk.send(ClientEvent.sendBoard(playboard));
  }

  @override
  Playboard? moveByGesture(PlayboardDirection direction) {
    final player = (state.state as RoomData).players[state.playerId]!;
    if (player.currentBoard.isSolved) return null;
    final playboard = player.currentBoard.moveDirection(direction);
    if (playboard != null) updatePlayboardState(playboard);
  }

  @override
  PlayboardKeyboardControl get playboardKeyboardControl => defaultArrowControl;

  @override
  Playboard? moveByKeyboard(LogicalKeyboardKey pressedKey) {
    final newBoard = defaultMoveByKeyboard(
        this,
        pressedKey,
        Playboard(
          size: state.boardSize,
          currentBoard:
              (state.state as RoomData).players[state.playerId]!.currentBoard,
        ));
    if (newBoard != null) updatePlayboardState(newBoard.currentBoard);
  }
}
