import 'package:equatable/equatable.dart';
import 'package:slideparty/src/widgets/widgets.dart';

abstract class PlayboardConfig extends Equatable {
  const PlayboardConfig();
  ButtonColor get bgColor;
}

class NumberPlayboardConfig extends PlayboardConfig {
  const NumberPlayboardConfig(this.color);

  final ButtonColor color;

  @override
  ButtonColor get bgColor => color;

  @override
  List<Object?> get props => [color];
}
