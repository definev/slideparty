import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

class OnlinePlayboardState extends PlayboardState {
  const OnlinePlayboardState(
    this.info, {
    required this.playerId,
    required this.serverState,
  }) : super(config: const NonePlayboardConfig());

  final String playerId;
  final ServerState serverState;
  final RoomInfo info;
  SinglePlayboardState? get currentState =>
      multiplePlayboardState?.currentState(playerId);
  List<SlidepartyActions>? get currentUsedAction =>
      multiplePlayboardState?.currentAction(playerId);

  Map<String, Map<String, List<SlidepartyActions>>>? get affectedAction =>
      serverState.mapOrNull(
        roomData: (roomData) => Map.fromIterables(
            roomData.players.values.map<String>((value) => value.id),
            roomData.players.values.map<Map<String, List<SlidepartyActions>>>(
                (value) => value.affectedActions)),
      );

  int get boardSize => info.boardSize;

  MultiplePlayboardState? get multiplePlayboardState {
    Map<String, SinglePlayboardState>? playerStates;
    Map<String, List<SlidepartyActions>>? usedActions;
    MultiplePlayboardConfig? stateConfig;
    int? playerCount;

    serverState.mapOrNull(
      roomData: (roomData) {
        playerCount = roomData.players.length;
        usedActions = roomData.players.map(
          (key, value) => MapEntry(key, value.usedActions),
        );
        playerStates = roomData.players.map(
          (key, value) => MapEntry(
            key,
            SinglePlayboardState(
              playboard: Playboard.fromList(value.currentBoard),
              config: const NonePlayboardConfig(),
              bestStep: -1,
            ),
          ),
        );
        stateConfig = MultiplePlayboardConfig(
          roomData.players.map(
            (key, value) => MapEntry(
              key,
              value.affectedActions.entries.fold<List<SlidepartyActions>>(
                      [],
                      (previousValue, element) => [
                            ...previousValue,
                            ...element.value
                          ]).contains(SlidepartyActions.blind)
                  ? PlayboardConfig.blind(value.color.buttonColor)
                  : PlayboardConfig.number(value.color.buttonColor),
            ),
          ),
        );
      },
    );

    if (playerStates == null ||
        usedActions == null ||
        playerCount == null ||
        stateConfig == null) return null;

    return MultiplePlayboardState(
      boardSize: boardSize,
      playerCount: playerCount!,
      playerStates: {
        if (playerStates != null) ...playerStates!,
      },
      usedActions: {
        if (usedActions != null) ...usedActions!,
      },
      stateConfig: stateConfig!,
    );
  }

  OnlinePlayboardState initPlayerId(String playerId) => OnlinePlayboardState(
        info,
        playerId: playerId,
        serverState: serverState,
      );

  OnlinePlayboardState copyWith({
    ServerState? serverState,
    List<SlidepartyActions>? currentUsedAction,
  }) =>
      OnlinePlayboardState(
        info,
        playerId: playerId,
        serverState: serverState ?? this.serverState,
      );

  @override
  List<Object?> get props => [playerId, serverState];
}

extension PlayerIdExt on OnlinePlayboardState {
  String? getIdByColor(ButtonColors color) => multiplePlayboardState == null
      ? null
      : (multiplePlayboardState!.config as MultiplePlayboardConfig)
          .configs
          .entries
          .where(
            (entry) =>
                entry.value.mapOrNull(
                  blind: (c) => c.color,
                  number: (c) => c.color,
                ) ==
                color,
          )
          .first
          .key;
}

extension PlayerColorsExt on PlayerColors {
  ButtonColors get buttonColor => ButtonColors.values[index];
}
