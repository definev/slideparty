import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/models/skill_keyboard_state.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

final onlinePlayboardControlllerProvider = StateNotifierProvider //
    .autoDispose
    .family<PlayboardController, PlayboardState, RoomInfo>(
  (ref, info) => OnlineModeController(ref.read, info),
);

final isDisconnectWebSocketProvider = StateProvider<bool>((ref) => false);

class OnlineModeController extends PlayboardController<OnlinePlayboardState>
    with PlayboardGestureControlHelper, PlayboardKeyboardControlHelper {
  OnlineModeController(this._read, this.info)
      : _ssk = SlidepartySocket(info),
        super(
          OnlinePlayboardState(
            info,
            playerId: '',
            serverState: const ServerState.waiting(),
            currentUsedAction: const [],
          ),
        ) {
    state = state.initPlayerId(_ssk.userId);
    _ssk;
    _sub = _ssk.state.listen(
      (serverState) => state = state.copyWith(serverState: serverState),
      onError: (e, stack) => debugPrint('$e\n$stack'),
      onDone: () {
        _read(isDisconnectWebSocketProvider.notifier).state = true;
        debugPrint('socket done');
      },
    );
  }

  final RoomInfo info;
  final Reader _read;
  final SlidepartySocket _ssk;
  late final StreamSubscription _sub;

  final PlayboardSkillKeyboardControl defaultControl =
      PlayboardSkillKeyboardControl(
    control: arrowControl,
    activeSkillKey: LogicalKeyboardKey.space,
  );

  void disconnect() async {
    _sub.cancel();
    await _ssk.close();
  }

  void restart() => _ssk.send(const ClientEvent.restart());

  void initController() {
    Future(() {
      final currentState = SinglePlayboardState(
        playboard: Playboard.random(info.boardSize),
        bestStep: -1,
        config: state.currentState!.config,
      );
      state = state.copyWith(currentState: currentState);
      _ssk.send(ClientEvent.sendBoard(currentState.playboard.currentBoard));
    });
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
      currentState: state.currentState!.editPlayboard(playboard),
    );
    _ssk.send(ClientEvent.sendBoard(playboard.currentBoard));
    if (state.currentState!.playboard.isSolved) {
      _ssk.send(ClientEvent.solved(state.playerId));
    }
  }

  void _updateUsedAction(SlidepartyActions usedAction) {
    state = state
        .copyWith(currentUsedAction: [...state.currentUsedAction, usedAction]);
  }

  void _sendActionToServer(SlidepartyActions queuedAction, String targetId) {
    if (queuedAction == SlidepartyActions.clear) {
      _ssk.send(ClientEvent.sendAction(state.playerId, queuedAction));
    } else {
      _ssk.send(ClientEvent.sendAction(targetId, queuedAction));
    }
  }

  void pickAction(SlidepartyActions queueAction) {
    final openSkillState = _read(multipleSkillStateProvider(state.playerId));
    final openSkillNotifier =
        _read(multipleSkillStateProvider(state.playerId).notifier);
    if (state.currentUsedAction.contains(queueAction) == true) return;

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

  void _clearQueuedAction() {
    final openSkillState = _read(multipleSkillStateProvider(state.playerId));
    final openSkillNotifier =
        _read(multipleSkillStateProvider(state.playerId).notifier);
    if (openSkillState.queuedAction == null) return;
    openSkillNotifier.state = openSkillState.copyWith(
      queuedAction: null,
      show: false,
      usedActions: {
        ...openSkillState.usedActions,
        openSkillState.queuedAction!: true,
      },
    );
  }

  void doAction(ButtonColors otherColor) {
    final openSkillState = _read(multipleSkillStateProvider(state.playerId));
    final queuedAction = openSkillState.queuedAction;
    final targetId = state.getIdByColor(otherColor);
    if (queuedAction == null || targetId == null) return;

    _updateUsedAction(queuedAction);
    _sendActionToServer(queuedAction, targetId);
    _clearQueuedAction();
  }

  bool handleSkillKey(LogicalKeyboardKey pressedKey) {
    final control = defaultControl;
    final openSkillState = _read(multipleSkillStateProvider(state.playerId));
    final openSkillNotifier =
        _read(multipleSkillStateProvider(state.playerId).notifier);
    final otherPlayerColors =
        state.multiplePlayboardState!.getPlayerColors(state.playerId);

    if (openSkillState.show) {
      if (control.activeSkillKey == pressedKey) {
        openSkillNotifier.state = openSkillState.copyWith(
          show: false,
          queuedAction: null,
        );
        return true;
      }
      if (openSkillState.queuedAction == null) {
        final pickedAction =
            openSkillState.pickQueuedAction(control, pressedKey);

        switch (pickedAction) {
          case SlidepartyActions.clear:
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
            }
            break;
          default:
            openSkillNotifier.state = openSkillState.copyWith(
              queuedAction: pickedAction,
            );
        }
      } else {
        control.control.onKeyDown<void>(
          pressedKey,
          onLeft: () {
            doAction(otherPlayerColors[0]);
          },
          onDown: () {
            if (otherPlayerColors.length < 2) return;
            doAction(otherPlayerColors[1]);
          },
          onRight: () {
            if (otherPlayerColors.length < 3) return;
            doAction(otherPlayerColors[2]);
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
      if (state.currentState!.playboard.isSolved) {
        Future(() => _ssk.send(ClientEvent.solved(state.playerId)));
      }
      return true;
    }
    return false;
  }

  bool get willBlockControl {
    final singleState = state.affectedAction![state.playerId]!.values
        .toList()
        .expand((element) => [...element]);
    return singleState.contains(SlidepartyActions.pause);
  }

  @override
  Playboard? moveByGesture(PlayboardDirection direction) {
    if (willBlockControl) return null;
    final player = state.currentState!;
    if (player.playboard.isSolved) return null;
    final playboard = player.playboard.moveHole(direction);
    if (playboard != null) updatePlayboardState(playboard);
    return null;
  }

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (willBlockControl) return;
    final handled = handleSkillKey(pressedKey);
    if (handled) return;
    handleKeyboardControl(pressedKey);
  }
}
