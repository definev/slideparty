import 'package:equatable/equatable.dart';
import 'package:slideparty/src/widgets/widgets.dart';

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
