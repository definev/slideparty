import 'package:equatable/equatable.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/utils/display_party_types.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

import 'playboard_config.dart';
import 'playboard.dart';

abstract class PlayboardState extends Equatable {
  final PlayboardConfig config;

  const PlayboardState({required this.config});
}

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

  bool get canSolve => playboard.canSolve;

  SinglePlayboardState editPlayboard(Playboard playboard,
          [bool increment = true]) =>
      SinglePlayboardState(
        playboard: playboard,
        config: config,
        step: increment ? step + 1 : step,
        bestStep: bestStep,
      );

  SinglePlayboardState editConfig(PlayboardConfig config) =>
      SinglePlayboardState(
        playboard: playboard,
        config: config,
        step: step,
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

class MultiplePlayboardState extends PlayboardState {
  MultiplePlayboardState({
    required int playerCount,
    List<SinglePlayboardState>? playerStates,
  }) : super(
          config: MultiplePlayboardConfig(
            List.generate(
              ButtonColors.values.length,
              (index) => NumberPlayboardConfig(ButtonColors.values[index]),
            ),
          ),
        ) {
    assert(playerCount > 0 && playerCount <= 4);
    assert(playerStates == null || playerStates.length == playerCount);
    _playerStates = playerStates ??
        List.generate(
          playerCount,
          (index) {
            final singleConfig =
                (config as MultiplePlayboardConfig).configs[index];
            final playboard = Playboard.random(3);

            return SinglePlayboardState(
              playboard: playboard,
              bestStep: playboard.autoSolve()?.length ?? 0,
              config: singleConfig,
            );
          },
        );
  }

  int get playerCount => _playerStates.length;
  late final List<SinglePlayboardState> _playerStates;

  SinglePlayboardState currentState(int index) => _playerStates[index];

  MultiplePlayboardState setState(int index, SinglePlayboardState state) {
    return MultiplePlayboardState(
      playerCount: playerCount,
      playerStates: List.from(_playerStates)..[index] = state,
    );
  }

  @override
  List<Object?> get props => [_playerStates];
}

class OnlinePlayboardState extends PlayboardState {
  const OnlinePlayboardState({
    required this.playerId,
    required this.state,
    this.displayMode = DisplayModes.bubbles,
  }) : super(config: const OnlinePlayboardConfig());

  final String playerId;
  final ServerState state;
  final DisplayModes displayMode;

  OnlinePlayboardState initPlayerId(String playerId) => OnlinePlayboardState(
        playerId: playerId,
        state: state,
        displayMode: displayMode,
      );

  OnlinePlayboardState copyWith({
    ServerState? state,
    DisplayModes? displayMode,
  }) =>
      OnlinePlayboardState(
        playerId: playerId,
        state: state ?? this.state,
        displayMode: displayMode ?? this.displayMode,
      );

  @override
  List<Object?> get props => [playerId, state, displayMode];
}

extension OnlinePlayboardExt on OnlinePlayboardState {
  int get boardSize =>
      (state as RoomData).players.values.first.currentBoard.size;

}
