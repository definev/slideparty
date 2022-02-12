import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';

class SinglePlayboardState extends PlayboardState {
  const SinglePlayboardState({
    required this.playboard,
    required this.bestStep,
    this.step = 0,
    required PlayboardConfig config,
  }) : super(config: config);

  final Playboard playboard;
  final int step;
  final int bestStep;

  SinglePlayboardState editPlayboard(Playboard playboard,
          [bool increment = true]) =>
      SinglePlayboardState(
        playboard: playboard,
        config: config,
        step: increment ? step + 1 : step,
        bestStep: bestStep,
      );

  SinglePlayboardState clone() => SinglePlayboardState(
        playboard: playboard.clone(),
        config: config,
        step: step,
        bestStep: bestStep,
      );

  @override
  List<Object?> get props => [playboard];
}
