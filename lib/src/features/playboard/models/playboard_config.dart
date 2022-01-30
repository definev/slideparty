import 'package:equatable/equatable.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

abstract class PlayboardConfig extends Equatable {
  const PlayboardConfig();
}

class NumberPlayboardConfig extends PlayboardConfig {
  const NumberPlayboardConfig(this.color);

  final ButtonColors color;

  @override
  List<Object?> get props => [color];
}

class MultiplePlayboardConfig extends PlayboardConfig {
  final List<PlayboardConfig> configs;
  const MultiplePlayboardConfig(this.configs);

  @override
  List<Object?> get props => [configs];
}

class OnlinePlayboardConfig extends PlayboardConfig {
  const OnlinePlayboardConfig();

  final Map<PlayerColors, ButtonColors> configs = const {
    PlayerColors.red: ButtonColors.red,
    PlayerColors.blue: ButtonColors.blue,
    PlayerColors.green: ButtonColors.green,
    PlayerColors.yellow: ButtonColors.yellow,
  };

  @override
  List<Object?> get props => [configs];
}
