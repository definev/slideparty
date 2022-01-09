import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/audio/button_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/widgets/widgets.dart';

final singleModeControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
  (ref) => SingleModePlayboardController(ref.read, ButtonColor.red),
);

class SingleModePlayboardController
    extends PlayboardController<SinglePlayboardState>
    with PlayboardGestureControlHelper, PlayboardKeyboardControlHelper {
  SingleModePlayboardController(this._read, this.color)
      : super(
          SinglePlayboardState(
            playboard: Playboard.random(4),
            config: NumberPlayboardConfig(color),
          ),
        );

  final Reader _read;
  final ButtonColor color;

  void move(int index) {
    final playboard = state.playboard.move(index);
    if (playboard != null) state = state.editPlayboard(playboard);
  }

  // *Gesture control helper*

  @override
  Playboard? moveByGesture(PlayboardDirection direction) {
    log('moveByGesture: $direction');
    final newBoard = defaultMoveByGesture(this, direction, state.playboard);
    if (newBoard != null) {
      _read(buttonAudioControllerProvider).clickSound();
      state = state.editPlayboard(newBoard);
    }

    return newBoard;
  }

  // *Keyboard control helper*

  @override
  PlayboardKeyboardControl get playboardKeyboardControl => defaultArrowControl;

  @override
  Playboard? moveByKeyboard(LogicalKeyboardKey pressedKey) {
    final newBoard = defaultMoveByKeyboard(
      this,
      pressedKey,
      state.playboard,
    );

    if (newBoard != null) {
      _read(buttonAudioControllerProvider).clickSound();
      state = state.editPlayboard(newBoard);
    }

    return newBoard;
  }
}

class SinglePlayboardState extends PlayboardState {
  SinglePlayboardState({
    required this.playboard,
    required PlayboardConfig config,
  }) : super(config: config);

  final Playboard playboard;

  SinglePlayboardState editPlayboard(Playboard playboard) =>
      SinglePlayboardState(playboard: playboard, config: config);

  SinglePlayboardState editConfig(PlayboardConfig config) =>
      SinglePlayboardState(playboard: playboard, config: config);
}
