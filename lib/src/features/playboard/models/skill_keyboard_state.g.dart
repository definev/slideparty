// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_keyboard_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SkillInGameState _$$SkillInGameStateFromJson(Map<String, dynamic> json) =>
    _$SkillInGameState(
      playerId: json['playerId'] as String,
      show: json['show'] as bool? ?? false,
      usedActions: (json['usedActions'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry($enumDecode(_$SlidepartyActionsEnumMap, k), e as bool),
          ) ??
          const <SlidepartyActions, bool>{},
      queuedAction:
          $enumDecodeNullable(_$SlidepartyActionsEnumMap, json['queuedAction']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SkillInGameStateToJson(_$SkillInGameState instance) =>
    <String, dynamic>{
      'playerId': instance.playerId,
      'show': instance.show,
      'usedActions': instance.usedActions
          .map((k, e) => MapEntry(_$SlidepartyActionsEnumMap[k], e)),
      'queuedAction': _$SlidepartyActionsEnumMap[instance.queuedAction],
      'runtimeType': instance.$type,
    };

const _$SlidepartyActionsEnumMap = {
  SlidepartyActions.blind: 'blind',
  SlidepartyActions.pause: 'pause',
  SlidepartyActions.clear: 'clear',
};

_$SkillOnlineState _$$SkillOnlineStateFromJson(Map<String, dynamic> json) =>
    _$SkillOnlineState(
      show: json['show'] as bool? ?? false,
      usedActions: (json['usedActions'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry($enumDecode(_$SlidepartyActionsEnumMap, k), e as bool),
          ) ??
          const <SlidepartyActions, bool>{},
      queuedAction:
          $enumDecodeNullable(_$SlidepartyActionsEnumMap, json['queuedAction']),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SkillOnlineStateToJson(_$SkillOnlineState instance) =>
    <String, dynamic>{
      'show': instance.show,
      'usedActions': instance.usedActions
          .map((k, e) => MapEntry(_$SlidepartyActionsEnumMap[k], e)),
      'queuedAction': _$SlidepartyActionsEnumMap[instance.queuedAction],
      'runtimeType': instance.$type,
    };
