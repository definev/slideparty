import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:slideparty/src/widgets/widgets.dart';

part 'playboard_config.freezed.dart';

@freezed
class PlayboardConfig with _$PlayboardConfig {
  const factory PlayboardConfig.none() = NonePlayboardConfig;
  const factory PlayboardConfig.blind(ButtonColors color) =
      BlindPlayboardConfig;
  const factory PlayboardConfig.number(ButtonColors color) =
      NumberPlayboardConfig;
  const factory PlayboardConfig.multiple(List<PlayboardConfig> configs) =
      MultiplePlayboardConfig;
}

extension EditMultipleConfig on MultiplePlayboardConfig {
  MultiplePlayboardConfig changeConfig(int index, PlayboardConfig config) =>
      MultiplePlayboardConfig(
        [...configs]..[index] = config,
      );
}
