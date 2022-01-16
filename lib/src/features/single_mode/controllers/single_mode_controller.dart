import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/audio/background_audio_controller.dart';
import 'package:slideparty/src/features/audio/button_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/widgets/widgets.dart';

final singleModeControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
  (ref) {
    final color = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));
    return SingleModePlayboardController(ref.read, color: color, boardSize: 3);
  },
);

final counterProvider =
    StateProvider.autoDispose<Duration>((ref) => const Duration(seconds: 0));

final singleModeSettingProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class SingleModePlayboardController
    extends PlayboardController<SinglePlayboardState>
    with
        PlayboardGestureControlHelper,
        PlayboardKeyboardControlHelper,
        AutoSolveHelper {
  SingleModePlayboardController(
    this._read, {
    required this.color,
    required int boardSize,
  }) : super(
          SinglePlayboardState(
            playboard: Playboard.random(boardSize),
            config: NumberPlayboardConfig(color),
            bestStep: -1,
          ),
        ) {
    final playboard = state.playboard;
    state = SinglePlayboardState(
      playboard: playboard,
      config: state.config,
      bestStep: solve(playboard)?.length ?? -1,
    );
  }

  final Reader _read;
  final ButtonColors color;

  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  bool get isSolved => state.playboard.isSolved;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void changeDimension(int size) {
    if (size == state.playboard.size) return;
    final playboard = Playboard.random(size);

    Future(() => solve(playboard)?.length).then((bestStep) {
      state = SinglePlayboardState(
        playboard: playboard,
        config: state.config,
        bestStep: -1,
      );
    });

    stopwatch
      ..stop()
      ..reset();
    timer?.cancel();
    timer = null;
    _read(counterProvider.notifier).state = const Duration(seconds: 0);
  }

  void pause() {
    stopwatch.stop();
    timer?.cancel();
    timer = null;
  }

  void reset() {
    if (_read(singleModeSettingProvider)) return;
    stopwatch
      ..stop()
      ..reset();
    timer?.cancel();
    timer = null;
    final playboard = Playboard.random(state.playboard.size);
    state = SinglePlayboardState(
      playboard: playboard,
      config: state.config,
      bestStep: solve(playboard)?.length ?? -1,
    );
    _read(counterProvider.notifier).state = const Duration(seconds: 0);
  }

  void updatePlayboardState(Playboard playboard) {
    if (timer == null) {
      stopwatch.start();
      timer = Timer.periodic(
        const Duration(milliseconds: 30),
        (timer) => _read(counterProvider.notifier).state = stopwatch.elapsed,
      );
    }
    if (playboard.isSolved) {
      timer?.cancel();
      timer = null;
      stopwatch.stop();
      _read(counterProvider.notifier).state = stopwatch.elapsed;
      Future.delayed(
        const Duration(milliseconds: 500),
        () => _read(backgroundAudioControllerProvider.notifier).playWinSound(),
      );
    }
    state = state.editPlayboard(playboard);
  }

  void move(int index) {
    if (state.playboard.isSolved) return;
    final playboard = state.playboard.move(index);
    if (playboard != null) updatePlayboardState(playboard);
  }

  // *Gesture control helper*

  @override
  Playboard? moveByGesture(PlayboardDirection direction) {
    if (_read(singleModeSettingProvider)) return null;
    if (state.playboard.isSolved) return null;
    final newBoard = defaultMoveByGesture(this, direction, state.playboard);
    if (newBoard != null) {
      _read(buttonAudioControllerProvider).clickSound();
      updatePlayboardState(newBoard);
    }

    return newBoard;
  }

  // *Keyboard control helper*

  @override
  PlayboardKeyboardControl get playboardKeyboardControl => defaultArrowControl;

  @override
  Playboard? moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (_read(singleModeSettingProvider)) return null;
    if (state.playboard.isSolved) return null;
    final newBoard = defaultMoveByKeyboard(
      this,
      pressedKey,
      state.playboard,
    );

    if (newBoard != null) {
      _read(buttonAudioControllerProvider).clickSound();
      updatePlayboardState(newBoard);
    }

    return newBoard;
  }

  // *Auto solve helper*
  void autoSolve(BuildContext context) async {
    if (_read(singleModeSettingProvider)) return;
    if (state.playboard.isSolved) return;
    if (isSolving) return;
    final steps = solve(state.playboard);
    if (steps == null || steps.isEmpty) return;
    final buttonAudioController = _read(buttonAudioControllerProvider);

    for (final direction in steps) {
      try {
        buttonAudioController.clickSound();
      } catch (_) {}
      final newBoard = state.playboard.moveHoleExact(direction);
      if (newBoard == null) {
        break;
      }
      updatePlayboardState(newBoard);
      await Future.delayed(const Duration(milliseconds: 600));
    }
  }
}

class SinglePlayboardState extends PlayboardState {
  SinglePlayboardState({
    required this.playboard,
    required this.bestStep,
    this.step = 0,
    required PlayboardConfig config,
  }) : super(config: config);

  final Playboard playboard;
  final int step;
  final int bestStep;

  SinglePlayboardState editPlayboard(Playboard playboard,
          [bool increment = true]) =>
      SinglePlayboardState(
        playboard: playboard,
        config: config,
        step: increment ? step + 1 : step,
        bestStep: bestStep,
      );

  SinglePlayboardState editConfig(PlayboardConfig config) =>
      SinglePlayboardState(
        playboard: playboard,
        config: config,
        step: step,
        bestStep: bestStep,
      );
}
