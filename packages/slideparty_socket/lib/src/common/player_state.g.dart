// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlayerStateData _$$PlayerStateDataFromJson(Map<String, dynamic> json) =>
    _$PlayerStateData(
      currentBoard: json['currentBoard'] as String,
      color: $enumDecode(_$PlayerColorsEnumMap, json['color']),
      name: json['name'] as String,
      affectedActions: (json['affectedActions'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$SlidepartyActionsEnumMap, e)),
      ),
      usedActions: (json['usedActions'] as List<dynamic>)
          .map((e) => $enumDecode(_$SlidepartyActionsEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$PlayerStateDataToJson(_$PlayerStateData instance) =>
    <String, dynamic>{
      'currentBoard': instance.currentBoard,
      'color': _$PlayerColorsEnumMap[instance.color],
      'name': instance.name,
      'affectedActions': instance.affectedActions
          .map((k, e) => MapEntry(k, _$SlidepartyActionsEnumMap[e])),
      'usedActions': instance.usedActions
          .map((e) => _$SlidepartyActionsEnumMap[e])
          .toList(),
    };

const _$PlayerColorsEnumMap = {
  PlayerColors.blue: 'blue',
  PlayerColors.green: 'green',
  PlayerColors.red: 'red',
  PlayerColors.yellow: 'yellow',
};

const _$SlidepartyActionsEnumMap = {
  SlidepartyActions.blind: 'blind',
  SlidepartyActions.pause: 'pause',
  SlidepartyActions.clear: 'clear',
};
