import 'package:equatable/equatable.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
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
    required this.boardSize,
    required int playerCount,
    Map<String, SinglePlayboardState>? playerStates,
    Map<String, List<SlidepartyActions>>? actions,
    MultiplePlayboardConfig stateConfig = defaultConfig,
  }) : super(config: stateConfig) {
    assert(playerCount >= 0 && playerCount <= 4);
    assert(playerStates == null || playerStates.length == playerCount);
    _playerStates = playerStates ??
        {
          for (var index = 0; index < playerCount; index++)
            '$index': SinglePlayboardState(
              playboard: Playboard.random(boardSize),
              config: stateConfig.configs[index.toString()]!,
              bestStep: -1,
            ),
        };
    _actions = actions ??
        {
          for (var index = 0; index < playerCount; index++) '$index': [],
        };
  }

  static const defaultConfig = MultiplePlayboardConfig(
    {
      '0': NumberPlayboardConfig(ButtonColors.blue),
      '1': NumberPlayboardConfig(ButtonColors.green),
      '2': NumberPlayboardConfig(ButtonColors.red),
      '3': NumberPlayboardConfig(ButtonColors.yellow),
    },
  );

  final int boardSize;
  late final Map<String, SinglePlayboardState> _playerStates;
  int get playerCount => _playerStates.length;

  late final Map<String, List<SlidepartyActions>> _actions;

  List<SlidepartyActions> currentAction(int index) =>
      _actions[index.toString()]!;
  MultiplePlayboardState setActions(
    int index,
    List<SlidepartyActions> actions, [
    MultiplePlayboardConfig? stateConfig,
  ]) =>
      MultiplePlayboardState(
        boardSize: boardSize,
        playerCount: playerCount,
        playerStates: _playerStates,
        actions: {..._actions}..[index.toString()] = actions,
        stateConfig: stateConfig ?? config as MultiplePlayboardConfig,
      );

  String? get whoWin {
    String? res;
    _playerStates.forEach((key, state) {
      if (state.playboard.isSolved) res = key;
    });
    return res;
  }

  SinglePlayboardState currentState(int index) =>
      _playerStates[index.toString()]!;
  MultiplePlayboardState setState(int index, SinglePlayboardState state) {
    return MultiplePlayboardState(
      playerCount: playerCount,
      boardSize: boardSize,
      playerStates: {..._playerStates}..[index.toString()] = state,
      actions: _actions,
      stateConfig: config as MultiplePlayboardConfig,
    );
  }

  MultiplePlayboardState setConfig(int index, PlayboardConfig _config) =>
      MultiplePlayboardState(
        boardSize: boardSize,
        playerCount: playerCount,
        actions: _actions,
        playerStates: _playerStates,
        stateConfig: (config as MultiplePlayboardConfig).changeConfig(
          index.toString(),
          _config,
        ),
      );

  @override
  List<Object?> get props => [_playerStates, _actions, config];
}

class OnlinePlayboardState extends PlayboardState {
  const OnlinePlayboardState({
    required this.playerId,
    required this.state,
  }) : super(config: const NonePlayboardConfig());

  final String playerId;
  final ServerState state;
  MultiplePlayboardState? get multiplePlayboardState {
    return state.mapOrNull(
      roomData: (roomData) {
        final playerCount = roomData.players.length;

        return MultiplePlayboardState(
          boardSize: boardSize,
          playerCount: playerCount,
        );
      },
    );
  }

  OnlinePlayboardState initPlayerId(String playerId) => OnlinePlayboardState(
        playerId: playerId,
        state: state,
      );

  OnlinePlayboardState copyWith({ServerState? state}) => OnlinePlayboardState(
        playerId: playerId,
        state: state ?? this.state,
      );

  @override
  List<Object?> get props => [playerId, state];
}

extension OnlinePlayboardExt on OnlinePlayboardState {
  int get boardSize =>
      (state as RoomData).players.values.first.currentBoard.size;
}
