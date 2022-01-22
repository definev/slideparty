// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoomStateData _$$RoomStateDataFromJson(Map<String, dynamic> json) =>
    _$RoomStateData(
      code: json['code'] as String,
      players: const MapPlayerStateConverter()
          .fromJson(json['players'] as Map<String, dynamic>),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RoomStateDataToJson(_$RoomStateData instance) =>
    <String, dynamic>{
      'code': instance.code,
      'players': const MapPlayerStateConverter().toJson(instance.players),
      'runtimeType': instance.$type,
    };

_$RoomStateLoading _$$RoomStateLoadingFromJson(Map<String, dynamic> json) =>
    _$RoomStateLoading(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$RoomStateLoadingToJson(_$RoomStateLoading instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };
