import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

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

  void startGame(int player, int boardSize) {
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
  Playboard? moveByKeyboard(LogicalKeyboardKey pressedKey) {}
}
