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

SingleModePlayboardController singleModeControllerProvider(Ref ref) {
  final color = ref.watch(playboardInfoControllerProvider.select((value) => value.color));
  final boardSize = ref.watch(playboardInfoControllerProvider.select((value) => value.boardSize));

  return SingleModePlayboardController(
    ref,
    color: color,
    boardSize: boardSize,
  );
}

final counterProvider = StateProvider.autoDispose<Duration>((ref) => const Duration(seconds: 0));

final singleModeSettingProvider = StateProvider.autoDispose<bool>((ref) => false);

class SingleModePlayboardController extends PlayboardController<SinglePlayboardState>
    with PlayboardGestureControlHelper, PlayboardKeyboardControlHelper, AutoSolveHelper {
  SingleModePlayboardController(
    this.ref, {
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
        bestStep: solveStep(state.playboard) ?? 1,
        config: state.config,
      ),
    );
  }

  final Ref ref;
  final ButtonColors color;

  Stopwatch stopwatch = Stopwatch();
  Timer? timer;

  bool get isSolved => state.playboard.isSolved;

  List<PlayboardDirection>? _directions;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
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
    ref.read(counterProvider.notifier).state = const Duration(seconds: 0);
  }

  void pause() {
    stopwatch.stop();
    timer?.cancel();
    timer = null;
  }

  void reset() {
    if (ref.read(singleModeSettingProvider)) return;

    _directions = null;
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
    Future.delayed(
      const Duration(milliseconds: 500),
      () {
        if (mounted) {
          state = SinglePlayboardState(
            playboard: state.playboard,
            bestStep: solveStep(state.playboard) ?? -1,
            config: state.config,
          );
        }
      },
    );
    ref.read(counterProvider.notifier).state = const Duration(seconds: 0);
  }

  void updatePlayboardState(Playboard playboard) {
    if (timer == null) {
      stopwatch.start();
      timer = Timer.periodic(
        const Duration(milliseconds: 30),
        (timer) => ref.read(counterProvider.notifier).state = stopwatch.elapsed,
      );
    }
    if (playboard.isSolved) {
      timer?.cancel();
      timer = null;
      ref.read(counterProvider.notifier).state = stopwatch.elapsed;
      stopwatch.reset();
      Future.delayed(
        const Duration(seconds: 2, milliseconds: 500),
        () => ref.read(backgroundAudioControllerProvider.notifier).playWinSound(),
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
    if (ref.read(singleModeSettingProvider)) return null;
    if (state.playboard.isSolved) return null;
    final newBoard = defaultMoveByGesture(this, direction, state.playboard);
    if (newBoard != null) {
      ref.read(buttonAudioControllerProvider).clickSound();
      updatePlayboardState(newBoard);
    }

    return newBoard;
  }

  // *Keyboard control helper*

  @override
  PlayboardKeyboardControl get playboardKeyboardControl => arrowControl;

  @override
  void moveByKeyboard(LogicalKeyboardKey pressedKey) {
    if (ref.read(singleModeSettingProvider)) return;
    if (state.playboard.isSolved) return;
    final newBoard = defaultMoveByKeyboard(
      playboardKeyboardControl,
      pressedKey,
      state.playboard,
    );

    if (newBoard != null) {
      ref.read(buttonAudioControllerProvider).clickSound();
      updatePlayboardState(newBoard);
    }
  }

  // *Auto solve helper*
  void autoSolve(BuildContext context) async {
    if (ref.read(singleModeSettingProvider)) return;
    if (state.playboard.isSolved) return;
    if (isSolving) return;
    _directions = solve(state.playboard);
    if (_directions == null || _directions!.isEmpty) return;
    isSolving = true;
    final buttonAudioController = ref.read(buttonAudioControllerProvider);

    for (int index = 0; index < _directions!.length; index++) {
      final direction = _directions![index];
      Playboard? newBoard = state.playboard.moveHoleExact(direction);
      if (newBoard == null) {
        isSolving = false;
        break;
      }

      while (index + 1 < _directions!.length && _directions![index + 1] == direction) {
        index = index + 1;
        newBoard = newBoard!.moveHoleExact(direction);
        if (newBoard == null) {
          isSolving = false;
          break;
        }
      }
      try {
        buttonAudioController.clickSound();
      } catch (_) {}
      if (newBoard == null) {
        isSolving = false;
        break;
      }
      updatePlayboardState(newBoard);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted == false) return;
      if (_directions == null) {
        isSolving = false;
        break;
      }
    }
  }
}
