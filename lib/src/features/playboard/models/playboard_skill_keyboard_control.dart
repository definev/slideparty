import 'package:flutter/services.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';

class PlayboardSkillKeyboardControl {
  final PlayboardKeyboardControl control;
  final LogicalKeyboardKey activeSkillKey;

  const PlayboardSkillKeyboardControl({
    required this.control,
    required this.activeSkillKey,
  });
}
