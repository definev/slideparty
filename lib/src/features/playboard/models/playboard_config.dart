import 'package:equatable/equatable.dart';
import 'package:slideparty/src/widgets/widgets.dart';

abstract class PlayboardConfig extends Equatable {}

class NumberPlayboardConfig extends PlayboardConfig {
  final ButtonColor color;

  NumberPlayboardConfig(this.color);

  @override
  List<Object?> get props => [color];
}
