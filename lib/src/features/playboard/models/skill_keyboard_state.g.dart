// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_keyboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillInGameState _$$SkillInGameStateFromJson(Map<String, dynamic> json) =>
    _$SkillInGameState(
      playerIndex: json['playerIndex'] as int,
      show: json['show'] as bool? ?? false,
      usedActions: (json['usedActions'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry($enumDecode(_$SlidepartyActionsEnumMap, k), e as bool),
          ) ??
          const <SlidepartyActions, bool>{},
      queuedAction:
          $enumDecodeNullable(_$SlidepartyActionsEnumMap, json['queuedAction']),
    );

Map<String, dynamic> _$$SkillInGameStateToJson(_$SkillInGameState instance) =>
    <String, dynamic>{
      'playerIndex': instance.playerIndex,
      'show': instance.show,
      'usedActions': instance.usedActions
          .map((k, e) => MapEntry(_$SlidepartyActionsEnumMap[k], e)),
      'queuedAction': _$SlidepartyActionsEnumMap[instance.queuedAction],
    };

const _$SlidepartyActionsEnumMap = {
  SlidepartyActions.blind: 'blind',
  SlidepartyActions.pause: 'pause',
  SlidepartyActions.clear: 'clear',
};
