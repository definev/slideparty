import 'package:dartx/dartx.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/buttons/models/slideparty_button_params.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

class MultiplePlayboardState extends PlayboardState {
  MultiplePlayboardState({
    required this.boardSize,
    required int playerCount,
    Map<String, SinglePlayboardState>? playerStates,
    Map<String, List<SlidepartyActions>>? usedActions,
    MultiplePlayboardConfig stateConfig = defaultConfig,
  }) : super(config: stateConfig) {
    assert(playerCount >= 0 && playerCount <= 4);
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

  List<ButtonColors> getPlayerColors(String playerId) {
    final config = this.config as MultiplePlayboardConfig;
    return config.configs.values
        .whereIndexed(
          (value, index) {
            if (config.configs.keys.elementAt(index) == playerId) return false;
            return true;
          },
        )
        .map(
          (value) => value.mapOrNull(
            blind: (v) => v.color,
            number: (v) => v.color,
          )!,
        )
        .toList();
  }

  List<SlidepartyActions> currentAction(String id) => _usedActions[id]!;
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

  SinglePlayboardState currentState(String id) => _playerStates[id]!;
  MultiplePlayboardState setState(String id, SinglePlayboardState state) {
    return MultiplePlayboardState(
      playerCount: playerCount,
      boardSize: boardSize,
      playerStates: {..._playerStates}..[id] = state,
      usedActions: _usedActions,
      stateConfig: config as MultiplePlayboardConfig,
    );
  }

  MultiplePlayboardState setConfig(String index, PlayboardConfig config) =>
      MultiplePlayboardState(
        boardSize: boardSize,
        playerCount: playerCount,
        usedActions: _usedActions,
        playerStates: _playerStates,
        stateConfig:
            (config as MultiplePlayboardConfig).changeConfig(index, config),
      );

  @override
  List<Object?> get props => [_playerStates, _usedActions, config];
}
