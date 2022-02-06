import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:dartx/dartx.dart';
import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

final multipleModeControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
        (ref) => MultipleModeController(ref.read));

class MultipleModeController extends PlayboardController<MultiplePlayboardState>
    with PlayboardKeyboardControlHelper {
  MultipleModeController(this._read)
      : super(
          MultiplePlayboardState(
            playerCount: 0,
            playerStates: const {},
            boardSize: 3,
          ),
        );

  final Reader _read;

  List<PlayboardSkillKeyboardControl> _keyboardControls = [];

  PlayboardSkillKeyboardControl playerControl(int index) =>
      _keyboardControls[index];

  void restart() {
    state = MultiplePlayboardState(
      boardSize: state.boardSize,
      playerCount: state.playerCount,
    );
  }

  void startGame(int player, int boardSize) {
    switch (player) {
      case 2:
        _keyboardControls = [
          PlayboardSkillKeyboardControl(
            control: wasdControl,
            activeSkillKey: LogicalKeyboardKey.keyX,
          ),
          PlayboardSkillKeyboardControl(
            control: arrowControl,
            activeSkillKey: LogicalKeyboardKey.space,
          ),
        ];
        break;
      case 3:
        _keyboardControls = [
          PlayboardSkillKeyboardControl(
            control: wasdControl,
            activeSkillKey: LogicalKeyboardKey.keyX,
          ),
          PlayboardSkillKeyboardControl(
            control: ijklControl,
            activeSkillKey: LogicalKeyboardKey.keyM,
          ),
          PlayboardSkillKeyboardControl(
            control: arrowControl,
            activeSkillKey: LogicalKeyboardKey.space,
          ),
        ];
        break;
      case 4:
        _keyboardControls = [
          PlayboardSkillKeyboardControl(
            control: wasdControl,
            activeSkillKey: LogicalKeyboardKey.keyX,
          ),
          PlayboardSkillKeyboardControl(
            control: tfghControl,
            activeSkillKey: LogicalKeyboardKey.keyB,
          ),
          PlayboardSkillKeyboardControl(
            control: ijklControl,
            activeSkillKey: LogicalKeyboardKey.keyM,
          ),
          PlayboardSkillKeyboardControl(
            control: arrowControl,
            activeSkillKey: LogicalKeyboardKey.space,
          ),
        ];
        break;
      default:
    }

    state = MultiplePlayboardState(
      playerCount: player,
      boardSize: boardSize,
    );
  }

  void pickAction(int index, SlidepartyActions action) {
    final openSkillState = _read(skillStateProvider(index));
    final openSkillNotifier = _read(skillStateProvider(index).notifier);
    if (openSkillState.usedActions[action] == true) return;

    switch (action) {
      case SlidepartyActions.clear:
        if (state.currentAction(index).isNotEmpty) {
          final configs = state.config as MultiplePlayboardConfig;
          state = state.setActions(
            index,
            [],
            configs.changeConfig(
              index.toString(),
              NumberPlayboardConfig(ButtonColors.values[index]),
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
        break;
      default:
        openSkillNotifier.state = openSkillState.copyWith(queuedAction: action);
    }
  }

  void doAction(int index, int target) {
    _flushAction(index, target);
    _removeQueuedAction(index, target);
  }

  void _removeQueuedAction(int index, int target) {
    final openSkillState = _read(skillStateProvider(index));
    final openSkillNotifier = _read(skillStateProvider(index).notifier);
    final queuedAction = openSkillState.queuedAction!;

    state = state.setActions(
      target,
      [...state.currentAction(target), queuedAction],
    );
    if (queuedAction == SlidepartyActions.blind) {
      state = state.setConfig(
        target,
        BlindPlayboardConfig(
          (state.config as MultiplePlayboardConfig)
              .configs[target.toString()]!
              .mapOrNull(
                blind: (c) => c.color,
                number: (c) => c.color,
              )!,
        ),
      );
      Future.delayed(
        const Duration(seconds: 10),
        () => state = state.setConfig(
          target,
          NumberPlayboardConfig(
            (state.config as MultiplePlayboardConfig)
                .configs[target.toString()]!
                .mapOrNull(
                  blind: (c) => c.color,
                  number: (c) => c.color,
                )!,
          ),
        ),
      );
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

  void _flushAction(int index, int target) {
    final openSkillState = _read(skillStateProvider(index));
    final queuedAction = openSkillState.queuedAction!;

    Future.delayed(const Duration(seconds: 10), () {
      state = state.setActions(
        target,
        [...state.currentAction(target)]..remove(queuedAction),
      );
    });
  }

  bool handleSkillKey(
    PlayboardSkillKeyboardControl control,
    int index,
    LogicalKeyboardKey pressedKey,
  ) {
    final openSkillState = _read(skillStateProvider(index));
    final openSkillNotifier = _read(skillStateProvider(index).notifier);
    final otherPlayersIndex = [
      for (int i = 0; i < state.playerCount; i++)
        if (i != index) i
    ];

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
            if (state.currentAction(index).isNotEmpty) {
              final configs = state.config as MultiplePlayboardConfig;
              state = state.setActions(
                index,
                [],
                configs.changeConfig(
                  index.toString(),
                  NumberPlayboardConfig(ButtonColors.values[index]),
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
        control.control.onKeyDown(
          pressedKey,
          onLeft: () {
            _flushAction(index, otherPlayersIndex[0]);
            _removeQueuedAction(index, otherPlayersIndex[0]);
          },
          onDown: () {
            if (otherPlayersIndex.length < 2) return;
            _flushAction(index, otherPlayersIndex[1]);
            _removeQueuedAction(index, otherPlayersIndex[1]);
          },
          onRight: () {
            if (otherPlayersIndex.length < 3) return;
            _flushAction(index, otherPlayersIndex[2]);
            _removeQueuedAction(index, otherPlayersIndex[2]);
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

  bool handleKeyboardControl(
    PlayboardSkillKeyboardControl control,
    int index,
    LogicalKeyboardKey pressedKey,
  ) {
    final singleState = state.currentState(index);
    final newBoard = defaultMoveByKeyboard(
      control.control,
      pressedKey,
      singleState.playboard,
    );

    if (newBoard != null) {
      state = state.setState(
        index,
        singleState.editPlayboard(newBoard),
      );
      return true;
    }
    return false;
  }

  bool willBlockControl(int index) {
    final singleState = state.currentAction(index);
    return singleState.contains(SlidepartyActions.pause);
  }

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (state.whoWin != null) return;
    _keyboardControls.forEachIndexed(
      (control, index) {
        final handled = handleSkillKey(control, index, pressedKey);
        if (willBlockControl(index)) return;
        if (!handled) handleKeyboardControl(control, index, pressedKey);
      },
    );
  }

  void move(int index, int number) {
    if (state.whoWin != null) return;
    if (willBlockControl(index)) return;
    final singleState = state.currentState(index);
    final newBoard = singleState.playboard.move(number);
    if (newBoard != null) {
      state = state.setState(index, singleState.editPlayboard(newBoard));
    }
  }

  void moveByGesture(int index, PlayboardDirection direction) {
    if (state.whoWin != null) return;
    if (willBlockControl(index)) return;
    final singleState = state.currentState(index);
    final newBoard = singleState.playboard.moveHole(direction);
    if (newBoard != null) {
      state = state.setState(index, singleState.editPlayboard(newBoard));
    }
  }
}
