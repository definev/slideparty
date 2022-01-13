import 'package:slideparty/src/features/playboard/models/loc.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

mixin AutoSolveHelper {
  bool _isSolving = false;
  bool get isSolving => _isSolving;

  List<Loc>? solve(Playboard initialBoard, [List<int>? finalBoard]) {
    try {
      if (_isSolving) return null;
      _isSolving = true;
      return initialBoard.autoSolve(finalBoard);
    } finally {
      _isSolving = false;
    }
  }
}
