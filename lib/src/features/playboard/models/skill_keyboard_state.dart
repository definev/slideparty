import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

part 'skill_keyboard_state.freezed.dart';
part 'skill_keyboard_state.g.dart';

@freezed
class SkillKeyboardState with _$SkillKeyboardState {
  const factory SkillKeyboardState.inGame({
    required String playerId,
    @Default(false) bool show,
    @Default(<SlidepartyActions, bool>{})
        Map<SlidepartyActions, bool> usedActions,
    SlidepartyActions? queuedAction,
  }) = SkillInGameState;
  const factory SkillKeyboardState.online({
    @Default(false) bool show,
    @Default(<SlidepartyActions, bool>{})
        Map<SlidepartyActions, bool> usedActions,
    SlidepartyActions? queuedAction,
  }) = SkillOnlineState;

  factory SkillKeyboardState.fromJson(Map<String, dynamic> json) =>
      _$SkillKeyboardStateFromJson(json);
}
