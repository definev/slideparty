import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty_socket/src/common/player_state.dart';

part 'room_state.freezed.dart';
part 'room_state.g.dart';

@freezed
class RoomState with _$RoomState {
  factory RoomState({
    required String code,
    @MapPlayerStateConverter() //
        required Map<String, PlayerState> players,
  }) = RoomStateData;
  factory RoomState.fromJson(Map<String, dynamic> json) =>
      _$RoomStateFromJson(json);
  factory RoomState.loading() = RoomStateLoading;
}
