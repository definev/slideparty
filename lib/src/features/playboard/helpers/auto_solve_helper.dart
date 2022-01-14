import 'package:slideparty/src/features/playboard/models/playboard.dart';

mixin AutoSolveHelper {
  bool _isSolving = false;
  bool get isSolving => _isSolving;

  Future<List<PlayboardDirection>?> solve(
    Playboard initialBoard, [
    List<int>? finalBoard,
  ]) async {
    try {
      if (_isSolving) return null;
      _isSolving = true;
      return initialBoard.autoSolve(finalBoard);
    } finally {
      _isSolving = false;
    }
  }
}
