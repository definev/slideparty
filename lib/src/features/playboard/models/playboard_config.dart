import 'package:equatable/equatable.dart';
import 'package:slideparty/src/widgets/widgets.dart';

abstract class PlayboardConfig extends Equatable {
  const PlayboardConfig();
  ButtonColors get bgColor;
}

class NumberPlayboardConfig extends PlayboardConfig {
  const NumberPlayboardConfig(this.color);

  final ButtonColors color;

  @override
  ButtonColors get bgColor => color;

  @override
  List<Object?> get props => [color];
}
