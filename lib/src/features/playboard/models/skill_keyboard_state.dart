import 'package:flutter/services.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
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

extension ExistCheckExt on Map<SlidepartyActions, bool> {
  bool isExist(SlidepartyActions? action) =>
      action == null ? false : (this[action] ?? false);
}

extension SkillKeyboardStateExt on SkillKeyboardState {
  bool get isInGame => this is SkillInGameState;
  bool get isOnline => this is SkillOnlineState;

  SlidepartyActions? pickQueuedAction(
    PlayboardSkillKeyboardControl control,
    LogicalKeyboardKey pressedKey,
  ) {
    return control.control.onKeyDown<SlidepartyActions?>(
      pressedKey,
      onLeft: () {
        if (usedActions.isExist(SlidepartyActions.blind)) {
          return null;
        }
        return SlidepartyActions.blind;
      },
      onDown: () {
        if (usedActions.isExist(SlidepartyActions.pause)) {
          return null;
        }
        return SlidepartyActions.pause;
      },
      onRight: () {
        if (usedActions.isExist(SlidepartyActions.clear)) {
          return null;
        }
        return SlidepartyActions.clear;
      },
    );
  }
}
