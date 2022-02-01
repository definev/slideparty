import 'package:flutter/services.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';

mixin PlayboardKeyboardControlHelper {
  PlayboardKeyboardControl get playboardKeyboardControl => throw UnimplementedError(
      'PlayboardKeyboardControlHelper must override playboardKeyboardControl getter');

  void moveByKeyboard(LogicalKeyboardKey pressedKey);
}

Playboard? defaultMoveByKeyboard(
  PlayboardKeyboardControl playboardKeyboardControl,
  LogicalKeyboardKey pressedKey,
  Playboard board,
) {
  if (pressedKey == playboardKeyboardControl.up) {
    return board.moveHole(PlayboardDirection.up);
  }
  if (pressedKey == playboardKeyboardControl.down) {
    return board.moveHole(PlayboardDirection.down);
  }
  if (pressedKey == playboardKeyboardControl.left) {
    return board.moveHole(PlayboardDirection.left);
  }
  if (pressedKey == playboardKeyboardControl.right) {
    return board.moveHole(PlayboardDirection.right);
  }
}
