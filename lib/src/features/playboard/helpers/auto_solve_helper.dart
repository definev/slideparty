import 'package:slideparty_playboard_utils/slideparty_playboard_utils.dart';

mixin AutoSolveHelper {
  bool isSolving = false;

  List<PlayboardDirection>? solve(
    Playboard initialBoard, [
    List<int>? finalBoard,
  ]) {
    try {
      if (isSolving) return null;
      isSolving = true;
      return initialBoard.autoSolve(finalBoard);
    } finally {
      isSolving = false;
    }
  }

  int? solveStep(
    Playboard initialBoard, [
    List<int>? finalBoard,
  ]) {
    try {
      if (isSolving) return null;
      isSolving = true;
      final steps = initialBoard.autoSolve(finalBoard);
      if (steps == null) return null;
      int res = 1;
      if (steps.isEmpty) return 0;
      var lastStep = steps[0];
      for (final step in steps.skip(1)) {
        if (step != lastStep) {
          res++;
          lastStep = step;
        }
      }

      return res;
    } finally {
      isSolving = false;
    }
  }
}
