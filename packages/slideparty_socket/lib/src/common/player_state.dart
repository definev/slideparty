import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty_socket/src/common/player_colors.dart';
import 'package:slideparty_socket/src/common/slideparty_actions.dart';

part 'player_state.freezed.dart';
part 'player_state.g.dart';

@freezed
class PlayerState with _$PlayerState {
  factory PlayerState({
    required String currentBoard,
    required PlayerColors color,
    required String name,
    required Map<String, SlidepartyActions> affectedActions,
    required List<SlidepartyActions> usedActions,
  }) = PlayerStateData;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);
}

class MapPlayerStateConverter
    implements JsonConverter<Map<String, PlayerState>, Map<String, dynamic>> {
  const MapPlayerStateConverter();

  @override
  Map<String, PlayerState> fromJson(Map<String, dynamic> json) {
    return json
        .map((key, value) => MapEntry(key, PlayerStateData.fromJson(value)));
  }

  @override
  Map<String, dynamic> toJson(Map<String, PlayerState> object) {
    return Map.fromEntries(
      object.entries.map(
        (entry) => MapEntry(
          entry.key,
          entry.value.toJson(),
        ),
      ),
    );
  }
}
