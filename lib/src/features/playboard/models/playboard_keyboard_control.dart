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

  T? onKeyDown<T>(
    LogicalKeyboardKey key, {
    T Function()? onUp,
    T Function()? onDown,
    T Function()? onLeft,
    T Function()? onRight,
    T Function()? orElse,
  }) {
    if (key == up) {
      return (onUp ?? orElse)?.call();
    } else if (key == down) {
      return (onDown ?? orElse)?.call();
    } else if (key == left) {
      return (onLeft ?? orElse)?.call();
    } else if (key == right) {
      return (onRight ?? orElse)?.call();
    }
    return null;
  }
}

final wasdControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.keyW,
  left: LogicalKeyboardKey.keyA,
  down: LogicalKeyboardKey.keyS,
  right: LogicalKeyboardKey.keyD,
);

final tfghControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.keyT,
  left: LogicalKeyboardKey.keyF,
  down: LogicalKeyboardKey.keyG,
  right: LogicalKeyboardKey.keyH,
);

final ijklControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.keyI,
  left: LogicalKeyboardKey.keyJ,
  down: LogicalKeyboardKey.keyK,
  right: LogicalKeyboardKey.keyL,
);

final arrowControl = PlayboardKeyboardControl(
  up: LogicalKeyboardKey.arrowUp,
  left: LogicalKeyboardKey.arrowLeft,
  down: LogicalKeyboardKey.arrowDown,
  right: LogicalKeyboardKey.arrowRight,
);
