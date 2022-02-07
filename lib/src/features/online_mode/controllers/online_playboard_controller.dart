import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

final onlinePlayboardControlllerProvider = StateNotifierProvider //
    .autoDispose
    .family<PlayboardController, PlayboardState, RoomInfo>(
  (ref, info) => OnlineModeController(ref.read, info),
);

class OnlineModeController extends PlayboardController<OnlinePlayboardState>
    with PlayboardGestureControlHelper, PlayboardKeyboardControlHelper {
  OnlineModeController(this._read, this.info)
      : _ssk = SlidepartySocket(info),
        super(
          OnlinePlayboardState(
            info,
            playerId: '',
            serverState: ServerState.waiting(),
          ),
        ) {
    state = state.initPlayerId(_ssk.userId);
    _sub = _ssk.state.listen((event) {
      state = state.copyWith(serverState: event);
    });
  }

  final RoomInfo info;
  final Reader _read;
  final SlidepartySocket _ssk;
  late final StreamSubscription _sub;

  void initController() {
    _ssk.send(ClientEvent.sendBoard(
      state.currentState!.playboard.currentBoard,
    ));
  }

  @override
  void dispose() {
    _sub.cancel();
    _ssk.close();
    super.dispose();
  }

  bool isMyPlayerId(String id) => state.playerId == id;

  void move(int index) {
    if (willBlockControl) return;
    final player = state.currentState!;
    if (player.playboard.isSolved) return;
    final playboard = player.playboard.move(index);
    if (playboard != null) updatePlayboardState(playboard);
  }

  void updatePlayboardState(Playboard playboard) {
    state = state.copyWith(
      currentState: SinglePlayboardState(
        playboard: playboard,
        bestStep: -1,
        config: const NonePlayboardConfig(),
      ),
    );
    _ssk.send(ClientEvent.sendBoard(playboard.currentBoard));
  }

  void updateUsedAction(List<SlidepartyActions> usedAction) {
    state = state.copyWith(currentUsedAction: usedAction);
  }

  void pickAction(SlidepartyActions queueAction) {
    final openSkillState = _read(onlineSkillStateProvider);
    final openSkillNotifier = _read(onlineSkillStateProvider.notifier);
    if (openSkillState.usedActions[queueAction] == true) return;

    switch (queueAction) {
      case SlidepartyActions.clear:
        if (state.affectedAction!.isNotEmpty) {
          _ssk.send(ClientEvent.sendAction(state.playerId, queueAction));
          openSkillNotifier.state = openSkillState.copyWith(
            show: false,
            usedActions: {
              ...openSkillState.usedActions,
              SlidepartyActions.clear: true,
            },
          );
          return;
        }
        break;
      default:
        openSkillNotifier.state =
            openSkillState.copyWith(queuedAction: queueAction);
    }
  }

  void doAction(String targetId, SlidepartyActions action) {
    _doAction(targetId, action);
  }

  void _doAction(String targetId, SlidepartyActions queuedAction) {
    final openSkillState = _read(onlineSkillStateProvider);
    final openSkillNotifier = _read(onlineSkillStateProvider.notifier);

    updateUsedAction([...state.currentUsedAction!, queuedAction]);

    if (queuedAction == SlidepartyActions.clear) {
      _ssk.send(ClientEvent.sendAction(state.playerId, queuedAction));
    } else {
      _ssk.send(ClientEvent.sendAction(targetId, queuedAction));
    }

    openSkillNotifier.state = openSkillState.copyWith(
      queuedAction: null,
      show: false,
      usedActions: {
        ...openSkillState.usedActions,
        queuedAction: true,
      },
    );
  }

  bool handleSkillKey(LogicalKeyboardKey pressedKey) {
    final control = defaultControl;
    final openSkillState = _read(onlineSkillStateProvider);
    final openSkillNotifier = _read(onlineSkillStateProvider.notifier);
    final otherPlayersIndex =
        state.multiplePlayboardState!.getPlayerIds(state.playerId);

    if (openSkillState.show) {
      if (control.activeSkillKey == pressedKey) {
        openSkillNotifier.state = openSkillState.copyWith(
          show: false,
          queuedAction: null,
        );
        return true;
      }
      if (openSkillState.queuedAction == null) {
        control.control.onKeyDown(
          pressedKey,
          onLeft: () {
            if (openSkillState.usedActions[SlidepartyActions.blind] == true) {
              return;
            }
            openSkillNotifier.state = openSkillState.copyWith(
              queuedAction: SlidepartyActions.blind,
            );
          },
          onDown: () {
            if (openSkillState.usedActions[SlidepartyActions.pause] == true) {
              return;
            }
            openSkillNotifier.state = openSkillState.copyWith(
              queuedAction: SlidepartyActions.pause,
            );
          },
          onRight: () {
            if (openSkillState.usedActions[SlidepartyActions.clear] == true) {
              return;
            }
            if (state.affectedAction!.isNotEmpty) {
              _ssk.send(
                ClientEvent.sendAction(
                  state.playerId,
                  SlidepartyActions.clear,
                ),
              );
              openSkillNotifier.state = openSkillState.copyWith(
                show: false,
                usedActions: {
                  ...openSkillState.usedActions,
                  SlidepartyActions.clear: true,
                },
              );
              return;
            }
          },
        );
      } else {
        control.control.onKeyDown<void>(
          pressedKey,
          onLeft: () {
            _doAction(otherPlayersIndex[0], openSkillState.queuedAction!);
          },
          onDown: () {
            if (otherPlayersIndex.length < 2) return;
            _doAction(otherPlayersIndex[1], openSkillState.queuedAction!);
          },
          onRight: () {
            if (otherPlayersIndex.length < 3) return;
            _doAction(otherPlayersIndex[2], openSkillState.queuedAction!);
          },
        );
      }
      return true;
    }

    if (pressedKey == control.activeSkillKey) {
      openSkillNotifier.state =
          openSkillState.copyWith(show: !openSkillState.show);
      return true;
    }
    return false;
  }

  bool handleKeyboardControl(LogicalKeyboardKey pressedKey) {
    final singleState = state.currentState!;
    final newBoard = defaultMoveByKeyboard(
      defaultControl.control,
      pressedKey,
      singleState.playboard,
    );

    if (newBoard != null) {
      state = state.copyWith(currentState: singleState.editPlayboard(newBoard));
      _ssk.send(ClientEvent.sendBoard(newBoard.currentBoard));
      return true;
    }
    return false;
  }

  bool get willBlockControl {
    final singleState = state.affectedAction!;
    return singleState.values.contains(SlidepartyActions.pause);
  }

  @override
  Playboard? moveByGesture(PlayboardDirection direction) {
    if (willBlockControl) return null;
    final player = state.currentState!;
    if (player.playboard.isSolved) return null;
    final playboard = player.playboard.moveHoleExact(direction);
    if (playboard != null) updatePlayboardState(playboard);
    return null;
  }

  final PlayboardSkillKeyboardControl defaultControl =
      PlayboardSkillKeyboardControl(
    control: arrowControl,
    activeSkillKey: LogicalKeyboardKey.space,
  );

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (willBlockControl) return;
    final handled = handleSkillKey(pressedKey);
    if (handled) return;
    handleKeyboardControl(pressedKey);
  }
}
