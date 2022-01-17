import 'package:slideparty/src/features/playboard/models/playboard.dart';

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
}
