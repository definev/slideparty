import 'package:slideparty/src/features/playboard/models/playboard.dart';

mixin PlayboardGestureControlHelper {
  Playboard? moveByGesture(PlayboardDirection direction);
}

Playboard? defaultMoveByGesture(
  PlayboardGestureControlHelper helper,
  PlayboardDirection direction,
  Playboard board,
) {
  switch (direction) {
    case PlayboardDirection.up:
      return board.moveHole(PlayboardDirection.up);
    case PlayboardDirection.down:
      return board.moveHole(PlayboardDirection.down);
    case PlayboardDirection.left:
      return board.moveHole(PlayboardDirection.left);
    case PlayboardDirection.right:
      return board.moveHole(PlayboardDirection.right);
  }
}
