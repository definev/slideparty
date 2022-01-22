import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty_socket/src/common/slideparty_actions.dart';

part 'player_event.freezed.dart';

@freezed
class PlayerEvent with _$PlayerEvent {
  const factory PlayerEvent.sendName(String name) = SendName;
  const factory PlayerEvent.sendBoard(List<int> board) = SendBoard;
  const factory PlayerEvent.sendAction(
    String affectedPlayerId,
    SlidepartyActions action,
  ) = SendAction;
}
