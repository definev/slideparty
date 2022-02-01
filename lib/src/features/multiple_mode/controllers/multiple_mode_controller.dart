import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:dartx/dartx.dart';

final multipleModeControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
        (ref) => MultipleModeController());

class MultipleModeController extends PlayboardController<MultiplePlayboardState>
    with PlayboardKeyboardControlHelper {
  MultipleModeController()
      : super(
          MultiplePlayboardState(
            playerCount: 0,
            playerStates: const [],
            boardSize: 3,
          ),
        );

  List<PlayboardKeyboardControl> _keyboardControls = [];

  PlayboardKeyboardControl playerControl(int index) => _keyboardControls[index];

  void startGame(int player, int boardSize) {
    switch (player) {
      case 2:
        _keyboardControls = [
          wasdControl,
          arrowControl,
        ];
        break;
      case 3:
        _keyboardControls = [
          wasdControl,
          ijklControl,
          arrowControl,
        ];
        break;
      case 4:
        _keyboardControls = [
          wasdControl,
          tfghControl,
          ijklControl,
          arrowControl,
        ];
        break;
      default:
    }

    state = MultiplePlayboardState(
      playerCount: player,
      boardSize: boardSize,
      playerStates: List.generate(
        player,
        (i) => SinglePlayboardState(
          playboard: Playboard.random(boardSize),
          bestStep: -1,
          config: state.config,
        ),
      ),
    );
  }

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (state.whoWin != null) return;
    _keyboardControls.forEachIndexed((control, index) {
      final singleState = state.currentState(index);
      final newBoard =
          defaultMoveByKeyboard(control, pressedKey, singleState.playboard);
      if (newBoard != null) {
        state = state.setState(
          index,
          singleState.editPlayboard(newBoard),
        );
      }
    });
  }

  void move(int index, int number) {
    if (state.whoWin != null) return;
    final singleState = state.currentState(index);
    final newBoard = singleState.playboard.move(number);
    if (newBoard != null) {
      state = state.setState(index, singleState.editPlayboard(newBoard));
    }
  }

  void moveByGesture(int index, PlayboardDirection direction) {
    if (state.whoWin != null) return;
    final singleState = state.currentState(index);
    final newBoard = singleState.playboard.moveHole(direction);
    if (newBoard != null) {
      state = state.setState(index, singleState.editPlayboard(newBoard));
    }
  }
}
