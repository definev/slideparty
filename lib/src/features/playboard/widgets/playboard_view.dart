import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:slideparty/src/features/playboard/models/playboard_animation_types.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty_socket/slideparty_socket_be.dart';

import '../playboard.dart';

class PlayboardView extends HookConsumerWidget {
  const PlayboardView({
    Key? key,
    this.playerId,
    this.playerIndex,
    required this.boardSize,
    required this.size,
    required this.onPressed,
    required this.clipBehavior,
    this.holeWidget,
    this.reduceMotion = false,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final String? playerId;
  final int? playerIndex;
  final int boardSize;
  final double size;
  final Function(int index) onPressed;
  final Clip clipBehavior;
  final Duration duration;
  final Widget? holeWidget;
  final bool reduceMotion;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationTypes =
        ref.watch(playboardControllerProvider.select((value) {
      if (value is SinglePlayboardState) {
        if (value.playboard.isSolved) {
          return PlayboardAnimationTypes.values[0];
        }
        return null;
      }
      return null;
    }));

    return IgnorePointer(
      ignoring: animationTypes != null,
      child: _heartScaleFade(
          animationTypes == PlayboardAnimationTypes.heartScaleFade),
    );
  }

  TweenAnimationBuilder<double> _heartScaleFade(bool isAnimated) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      curve: Curves.decelerate,
      tween: Tween<double>(begin: 0, end: isAnimated ? 1 : 0),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: -(pi * 3 / 4) * value,
          origin: const Offset(0.5, 0.5),
          child: Transform.scale(
            scale:
                value == 0 ? 1 : 1 + (size / sqrt(size * size * 2) - 1) * value,
            child: SizedBox(
              height: size,
              width: size,
              child: Stack(
                clipBehavior: clipBehavior,
                children: List.generate(
                  boardSize * boardSize,
                  (index) => _puzzleTile(
                    index: index,
                    size: size,
                    animationType: PlayboardAnimationTypes.heartScaleFade,
                    animateValue: value,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _puzzleTile({
    required int index,
    required double size,
    required PlayboardAnimationTypes animationType,
    required double animateValue,
  }) {
    return Consumer(
      builder: (context, ref, child) {
        final loc = ref.watch(
          playboardControllerProvider.select((state) {
            if (state is SinglePlayboardState) {
              return state.playboard.currentLoc(index);
            }
            if (state is OnlinePlayboardState) {
              return (state.state as RoomData)
                  .players[playerId]!
                  .currentBoard
                  .loc(index);
            }
            if (state is MultiplePlayboardState) {
              return state
                  .currentState(playerIndex!)
                  .playboard
                  .currentLoc(index);
            }

            throw UnimplementedError(
                'This kind of playboard is not implemented yet.');
          }),
        );

        final config = ref.watch(
          playboardControllerProvider.select((value) => value.config),
        );
        final tile = _getTileWithConfig(
          loc: loc,
          size: size,
          index: index,
          config: config,
          animationType: animationType,
          animateValue: animateValue,
        );

        if (reduceMotion) {
          return Positioned(
            top: loc.dy * size / boardSize,
            left: loc.dx * size / boardSize,
            child: tile,
          );
        }

        return TweenAnimationBuilder<Size?>(
          duration: duration,
          curve: Curves.easeOutBack,
          tween: SizeTween(
            begin: Size(
              (boardSize / 2).floorToDouble(),
              (boardSize / 2).floorToDouble(),
            ),
            end: loc.toSize,
          ),
          builder: (context, pos, child) => Positioned(
            top: (pos?.height ?? loc.dy) * size / boardSize,
            left: (pos?.width ?? loc.dx) * size / boardSize,
            child: tile,
          ),
        );
      },
    );
  }

  Widget _getTileWithConfig({
    required Loc loc,
    required double size,
    required int index,
    required PlayboardConfig config,
    required PlayboardAnimationTypes animationType,
    required double animateValue,
  }) {
    if (index == boardSize * boardSize - 1) {
      return SizedBox(
        key: const ValueKey('hole-tile'),
        height: size / boardSize,
        width: size / boardSize,
        child: holeWidget,
      );
    }

    if (config is NumberPlayboardConfig) {
      return Transform.scale(
        scale: animateValue < 0.8 ? 1 : 1 + (animateValue - 0.8) / 0.6,
        child: Opacity(
          opacity: animateValue < 0.8 ? 1 : (1 - animateValue) / 0.2,
          child: NumberTile(
            key: ValueKey('number-tile-${loc.index(boardSize)}'),
            index: index,
            boardSize: boardSize,
            playboardSize: size,
            color: config.color,
            onPressed: onPressed,
            child: Transform.rotate(
              angle: (pi + pi / 4 - pi / 2) * animateValue,
              origin: const Offset(0.5, 0.5),
              child: Text('${index + 1}'),
            ),
          ),
        ),
      );
    }

    if (config is MultiplePlayboardConfig) {
      final tileConfig = config.configs[playerIndex!.toString()]!;

      return NumberTile(
        key: ValueKey('number-tile-${loc.index(boardSize)}'),
        index: index,
        boardSize: boardSize,
        playboardSize: size,
        color: tileConfig.mapOrNull(
          number: (c) => c.color,
          blind: (c) => c.color,
        )!,
        onPressed: onPressed,
        child: tileConfig.mapOrNull<Widget?>(
          number: (c) => Text('${index + 1}'),
          blind: (c) => const SizedBox(),
        )!,
      );
    }

    throw UnimplementedError('Unimplemented kind of $config');
  }
}
