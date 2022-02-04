import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

part 'playboard_config.freezed.dart';

@freezed
class PlayboardConfig with _$PlayboardConfig {
  const factory PlayboardConfig.blind(ButtonColors color) =
      BlindPlayboardConfig;
  const factory PlayboardConfig.number(ButtonColors color) =
      NumberPlayboardConfig;
  const factory PlayboardConfig.multiple(List<PlayboardConfig> configs) =
      MultiplePlayboardConfig;
  const factory PlayboardConfig.online(
      [@Default({
        PlayerColors.blue: NumberPlayboardConfig(ButtonColors.blue),
        PlayerColors.red: NumberPlayboardConfig(ButtonColors.red),
        PlayerColors.yellow: NumberPlayboardConfig(ButtonColors.yellow),
        PlayerColors.green: NumberPlayboardConfig(ButtonColors.green),
      })
          Map<PlayerColors, PlayboardConfig> configs]) = OnlinePlayboardConfig;
}

extension EditMultipleConfig on MultiplePlayboardConfig {
  MultiplePlayboardConfig changeConfig(int index, PlayboardConfig config) =>
      MultiplePlayboardConfig(
        [...configs]..[index] = config,
      );
}
