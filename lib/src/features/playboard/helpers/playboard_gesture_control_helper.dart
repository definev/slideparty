import 'package:slideparty_playboard_utils/slideparty_playboard_utils.dart';

mixin PlayboardGestureControlHelper {
  Playboard? moveByGesture(PlayboardDirection direction);
}

Playboard? defaultMoveByGesture(
  PlayboardGestureControlHelper helper,
  PlayboardDirection direction,
  Playboard board,
) =>
    board.moveHole(direction);
