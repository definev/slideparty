import 'package:flutter/services.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';

mixin PlayboardKeyboardControlHelper {
  PlayboardKeyboardControl get playboardKeyboardControl => throw UnimplementedError(
      'PlayboardKeyboardControlHelper must override playboardKeyboardControl getter');

  Playboard? moveByKeyboard(LogicalKeyboardKey pressedKey);
}

Playboard? defaultMoveByKeyboard(
  PlayboardKeyboardControlHelper helper,
  LogicalKeyboardKey pressedKey,
  Playboard board,
) {
  if (pressedKey == helper.playboardKeyboardControl.up) {
    return board.moveHole(PlayboardDirection.up);
  }
  if (pressedKey == helper.playboardKeyboardControl.down) {
    return board.moveHole(PlayboardDirection.down);
  }
  if (pressedKey == helper.playboardKeyboardControl.left) {
    return board.moveHole(PlayboardDirection.left);
  }
  if (pressedKey == helper.playboardKeyboardControl.right) {
    return board.moveHole(PlayboardDirection.right);
  }
}
