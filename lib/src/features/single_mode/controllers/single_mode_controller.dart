import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/audio/background_audio_controller.dart';
import 'package:slideparty/src/features/audio/button_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_playboard_utils/slideparty_playboard_utils.dart';

final singleModeControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
  (ref) {
    final color = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));
    final boardSize = ref.watch(
        playboardInfoControllerProvider.select((value) => value.boardSize));

    return SingleModePlayboardController(
      ref.read,
      color: color,
      boardSize: boardSize,
    );
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
      bestStep: -1,
    );
    Future.delayed(
      const Duration(milliseconds: 500),
      () => state = SinglePlayboardState(
        playboard: state.playboard,
        step: state.step,
        bestStep: solve(state.playboard)?.length ?? 1,
        config: state.config,
      ),
    );
  }

  final Reader _read;
  final ButtonColors color;

  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  bool get isSolved => state.playboard.isSolved;

  List<PlayboardDirection>? _steps;

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  void changeDimension(int size) {
    if (size == state.playboard.size) return;
    final playboard = Playboard.random(size);

    state = SinglePlayboardState(
      playboard: playboard,
      bestStep: -1,
      config: state.config,
    );

    Future.delayed(
      const Duration(milliseconds: 500),
      () => state = SinglePlayboardState(
        playboard: state.playboard,
        config: state.config,
        step: state.step,
        bestStep: solve(state.playboard)?.length ?? -1,
      ),
    );

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

    _steps = null;
    stopwatch
      ..stop()
      ..reset();
    timer?.cancel();
    timer = null;
    final playboard = Playboard.random(state.playboard.size);
    state = SinglePlayboardState(
      playboard: playboard,
      config: state.config,
      bestStep: -1,
    );
    Future.delayed(const Duration(milliseconds: 500), () {
      state = SinglePlayboardState(
        playboard: state.playboard,
        bestStep: solve(state.playboard)?.length ?? -1,
        config: state.config,
      );
    });
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
      _read(counterProvider.notifier).state = stopwatch.elapsed;
      stopwatch.reset();
      Future.delayed(
        const Duration(seconds: 2, milliseconds: 500),
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
  PlayboardKeyboardControl get playboardKeyboardControl => arrowControl;

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (_read(singleModeSettingProvider)) return;
    if (state.playboard.isSolved) return;
    final newBoard = defaultMoveByKeyboard(
      playboardKeyboardControl,
      pressedKey,
      state.playboard,
    );

    if (newBoard != null) {
      _read(buttonAudioControllerProvider).clickSound();
      updatePlayboardState(newBoard);
    }
  }

  // *Auto solve helper*
  void autoSolve(BuildContext context) async {
    if (_read(singleModeSettingProvider)) return;
    if (state.playboard.isSolved) return;
    if (isSolving) return;
    _steps = solve(state.playboard);
    if (_steps == null || _steps!.isEmpty) return;
    isSolving = true;
    final buttonAudioController = _read(buttonAudioControllerProvider);

    for (final direction in _steps!) {
      try {
        buttonAudioController.clickSound();
      } catch (_) {}
      final newBoard = state.playboard.moveHoleExact(direction);
      if (newBoard == null) {
        isSolving = false;
        break;
      }
      updatePlayboardState(newBoard);
      await Future.delayed(const Duration(milliseconds: 600));
      if (_steps == null) {
        isSolving = false;
        break;
      }
    }
  }
}
