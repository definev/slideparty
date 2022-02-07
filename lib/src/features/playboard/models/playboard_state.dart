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
    Map<String, List<SlidepartyActions>>? usedActions,
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
    _usedActions = usedActions ??
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

  late final Map<String, List<SlidepartyActions>> _usedActions;

  List<String> getPlayerIds(String playerId) =>
      _playerStates.keys.toList()..remove(playerId);

  List<SlidepartyActions> currentAction(String index) => _usedActions[index]!;
  MultiplePlayboardState setActions(
    String index,
    List<SlidepartyActions> actions, [
    MultiplePlayboardConfig? stateConfig,
  ]) =>
      MultiplePlayboardState(
        boardSize: boardSize,
        playerCount: playerCount,
        playerStates: _playerStates,
        usedActions: {..._usedActions}..[index.toString()] = actions,
        stateConfig: stateConfig ?? config as MultiplePlayboardConfig,
      );

  String? get whoWin {
    String? res;
    _playerStates.forEach((key, state) {
      if (state.playboard.isSolved) res = key;
    });
    return res;
  }

  SinglePlayboardState currentState(String index) => _playerStates[index]!;
  MultiplePlayboardState setState(String index, SinglePlayboardState state) {
    return MultiplePlayboardState(
      playerCount: playerCount,
      boardSize: boardSize,
      playerStates: {..._playerStates}..[index] = state,
      usedActions: _usedActions,
      stateConfig: config as MultiplePlayboardConfig,
    );
  }

  MultiplePlayboardState setConfig(String index, PlayboardConfig _config) =>
      MultiplePlayboardState(
        boardSize: boardSize,
        playerCount: playerCount,
        usedActions: _usedActions,
        playerStates: _playerStates,
        stateConfig:
            (config as MultiplePlayboardConfig).changeConfig(index, _config),
      );

  @override
  List<Object?> get props => [_playerStates, _usedActions, config];
}

class OnlinePlayboardState extends PlayboardState {
  const OnlinePlayboardState(
    this.info, {
    required this.playerId,
    required this.serverState,
    this.currentState,
    this.currentUsedAction,
  }) : super(config: const NonePlayboardConfig());

  final String playerId;
  final ServerState serverState;
  final RoomInfo info;
  final SinglePlayboardState? currentState;
  final List<SlidepartyActions>? currentUsedAction;
  Map<String, SlidepartyActions>? get affectedAction => serverState.mapOrNull(
        roomData: (roomData) => roomData.players[playerId]!.affectedActions,
      );

  int get boardSize => info.boardSize;

  MultiplePlayboardState? get multiplePlayboardState {
    return serverState.mapOrNull(
      roomData: (roomData) {
        final playerCount = roomData.players.length;
        roomData.players[0]!.affectedActions;

        return MultiplePlayboardState(
          boardSize: boardSize,
          playerCount: playerCount,
          playerStates: roomData.players.map(
            (key, value) {
              if (key == playerId) {
                return MapEntry(key, currentState!);
              }
              return MapEntry(
                key,
                SinglePlayboardState(
                  playboard: Playboard.fromList(value.currentBoard),
                  config: const NonePlayboardConfig(),
                  bestStep: -1,
                ),
              );
            },
          ),
          usedActions: roomData.players.map(
            (key, value) {
              if (key == playerId) {
                return MapEntry(key, currentUsedAction!);
              }
              return MapEntry(key, value.usedActions);
            },
          ),
          stateConfig: MultiplePlayboardConfig(
            roomData.players.map(
              (key, value) => MapEntry(
                key,
                value.affectedActions.containsValue(SlidepartyActions.blind)
                    ? PlayboardConfig.blind(value.color.buttonColor)
                    : PlayboardConfig.number(value.color.buttonColor),
              ),
            ),
          ),
        );
      },
    );
  }

  OnlinePlayboardState initPlayerId(String playerId) => OnlinePlayboardState(
        info,
        playerId: playerId,
        serverState: serverState,
        currentState: SinglePlayboardState(
          playboard: Playboard.random(boardSize),
          bestStep: -1,
          config: const NonePlayboardConfig(),
        ),
        currentUsedAction: const [],
      );

  OnlinePlayboardState copyWith({
    ServerState? serverState,
    SinglePlayboardState? currentState,
    List<SlidepartyActions>? currentUsedAction,
  }) =>
      OnlinePlayboardState(
        info,
        playerId: playerId,
        serverState: serverState ?? this.serverState,
        currentState: currentState ?? this.currentState,
        currentUsedAction: currentUsedAction ?? this.currentUsedAction,
      );

  @override
  List<Object?> get props => [playerId, serverState];
}

extension PlayerColorsExt on PlayerColors {
  ButtonColors get buttonColor => ButtonColors.values[index];
}
