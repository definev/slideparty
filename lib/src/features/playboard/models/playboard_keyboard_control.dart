import 'package:flutter/services.dart';

class PlayboardKeyboardControl {
  final LogicalKeyboardKey up;
  final LogicalKeyboardKey down;
  final LogicalKeyboardKey left;
  final LogicalKeyboardKey right;

  const PlayboardKeyboardControl({
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
}

final defaultWASDControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.keyW,
  left: LogicalKeyboardKey.keyA,
  down: LogicalKeyboardKey.keyS,
  right: LogicalKeyboardKey.keyD,
);

final defaultArrowControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.arrowUp,
  left: LogicalKeyboardKey.arrowLeft,
  down: LogicalKeyboardKey.arrowDown,
  right: LogicalKeyboardKey.arrowRight,
);
