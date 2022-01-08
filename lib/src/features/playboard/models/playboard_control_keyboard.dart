import 'package:flutter/services.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

class PlayboardControlKeyboard {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;

  const PlayboardControlKeyboard({
    required this.up,
    required this.left,
    required this.down,
    required this.right,
  }) : assert(
          up != down &&
              up != left &&
              up != right &&
              down != left &&
              down != right &&
              left != right,
        );

  Playboard? moveHole(LogicalKeyboardKey pressedKey, Playboard board) {
    if (pressedKey == up) return board.moveHole(PlayboardDirection.up);
    if (pressedKey == down) return board.moveHole(PlayboardDirection.down);
    if (pressedKey == left) return board.moveHole(PlayboardDirection.left);
    if (pressedKey == right) return board.moveHole(PlayboardDirection.right);
  }
}

final defaultWASDControl = PlayboardControlKeyboard(
  up: LogicalKeyboardKey.keyW,
  left: LogicalKeyboardKey.keyA,
  down: LogicalKeyboardKey.keyS,
  right: LogicalKeyboardKey.keyD,
);

final defaultArrowControl = PlayboardControlKeyboard(
  up: LogicalKeyboardKey.arrowUp,
  left: LogicalKeyboardKey.arrowLeft,
  down: LogicalKeyboardKey.arrowDown,
  right: LogicalKeyboardKey.arrowRight,
);
