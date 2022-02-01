import 'package:slideparty/src/features/playboard/models/playboard.dart';

mixin PlayboardGestureControlHelper {
  Playboard? moveByGesture(PlayboardDirection direction);
}

Playboard? defaultMoveByGesture(
  PlayboardGestureControlHelper helper,
  PlayboardDirection direction,
  Playboard board,
) =>
    board.moveHole(direction);
