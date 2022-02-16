import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';

import 'package:slideparty/src/features/playboard/models/playboard_animation_types.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty_socket/slideparty_socket_be.dart';

import '../playboard.dart';

extension on Loc {
  Size get toSize => Size(dx.toDouble(), dy.toDouble());
}

class PlayboardView extends HookConsumerWidget {
  const PlayboardView({
    Key? key,
    this.playerId,
    required this.boardSize,
    required this.size,
    required this.onPressed,
    required this.clipBehavior,
    this.holeWidget,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);

  final String? playerId;
  final int boardSize;
  final double size;
  final Function(int index) onPressed;
  final Clip clipBehavior;
  final Duration duration;
  final Widget? holeWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationTypes =
        ref.watch(playboardControllerProvider.select((value) {
      if (value is SinglePlayboardState) {
        if (value.playboard.isSolved) {
          return PlayboardAnimationTypes
              .values[Random().nextInt(PlayboardAnimationTypes.values.length)];
        }
      }
      return null;
    }));

    return IgnorePointer(
      ignoring: animationTypes != null,
      child: RepaintBoundary(child: _animatedPlayboard(animationTypes)),
    );
  }

  Widget _animatedPlayboard(PlayboardAnimationTypes? animationType) {
    switch (animationType) {
      case PlayboardAnimationTypes.heartScaleFade:
        return _heartScaleFade();
      case PlayboardAnimationTypes.spinTile:
        return _spinTile();
      case PlayboardAnimationTypes.spinTileWithFade:
        return _spinTileWithFade();
      default:
        return _basePlayboard(null, 1);
    }
  }

  Widget _heartScaleFade() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      curve: Curves.decelerate,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.rotate(
          angle: -(pi * 3 / 4) * value,
          origin: const Offset(0.5, 0.5),
          child: Transform.scale(
            scale:
                value == 0 ? 1 : 1 + (size / sqrt(size * size * 2) - 1) * value,
            child:
                _basePlayboard(PlayboardAnimationTypes.heartScaleFade, value),
          ),
        );
      },
    );
  }

  Widget _spinTile() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      curve: Curves.bounceInOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return _basePlayboard(PlayboardAnimationTypes.spinTile, value);
      },
    );
  }

  Widget _spinTileWithFade() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      curve: Curves.bounceInOut,
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, value, child) {
        return _basePlayboard(PlayboardAnimationTypes.spinTileWithFade, value);
      },
    );
  }

  SizedBox _basePlayboard(
    PlayboardAnimationTypes? animationType,
    double animateValue,
  ) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        clipBehavior: clipBehavior,
        children: List.generate(
          boardSize * boardSize,
          (index) => _puzzleTile(
            index: index,
            size: size,
            animationType: animationType,
            animateValue: animateValue,
          ),
        ),
      ),
    );
  }

  Widget _puzzleTile({
    required int index,
    required double size,
    required PlayboardAnimationTypes? animationType,
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
              if (state.serverState is! RoomData) {
                return const Loc(0, 0);
              }
              return (state.serverState as RoomData)
                  .players[playerId]!
                  .currentBoard
                  .loc(index);
            }
            if (state is MultiplePlayboardState) {
              return state.currentState(playerId!).playboard.currentLoc(index);
            }

            throw UnimplementedError(
                'This kind of playboard is not implemented yet.');
          }),
        );

        final config = ref.watch(
          playboardControllerProvider.select((value) {
            if (value is OnlinePlayboardState) {
              if (value.serverState is! RoomData) {
                return MultiplePlayboardState.defaultConfig;
              }
              return value.multiplePlayboardState!.config;
            }
            return value.config;
          }),
        );
        final tile = _getTileWithConfig(
          loc: loc,
          size: size,
          index: index,
          config: config,
          animationType: animationType,
          animateValue: animateValue,
        );
        final reduceMotion = ref.watch(
            appSettingControllerProvider.select((value) => value.reduceMotion));

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
    required PlayboardAnimationTypes? animationType,
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
      final numberTile = NumberTile(
        key: ValueKey('number-tile-${loc.index(boardSize)}'),
        index: index,
        boardSize: boardSize,
        playboardSize: size,
        color: config.color,
        onPressed: onPressed,
        child: Text('${index + 1}'),
      );

      switch (animationType) {
        case PlayboardAnimationTypes.heartScaleFade:
          return Transform.scale(
            scale: animateValue < 0.8 ? 1 : 1 + (animateValue - 0.8) / 0.6,
            child: Opacity(
              opacity: animateValue < 0.8 ? 1 : (1 - animateValue) / 0.2,
              child: numberTile,
            ),
          );
        case PlayboardAnimationTypes.spinTile:
          return Transform.rotate(
            angle: 2 * pi * animateValue,
            origin: const Offset(0.5, 0.5),
            child: Transform.scale(
              scale: animateValue <= 0.4
                  ? 1 - animateValue / 2
                  : 0.8 + (animateValue) / 5,
              child: numberTile,
            ),
          );
        case PlayboardAnimationTypes.spinTileWithFade:
          return Transform.rotate(
            angle: 2 * pi * animateValue,
            origin: const Offset(0.5, 0.5),
            child: Transform.scale(
              scale: animateValue <= 0.4
                  ? 1 - animateValue / 2
                  : 0.8 + (animateValue) / 5,
              child: Opacity(
                opacity: animateValue < 0.8 ? 1 : (1 - animateValue) / 0.2,
                child: numberTile,
              ),
            ),
          );
        default:
          return numberTile;
      }
    }

    if (config is MultiplePlayboardConfig) {
      final tileConfig = config.configs[playerId]!;

      return NumberTile(
        key: ValueKey('${tileConfig.mapOrNull<String>(
          number: (c) => '',
          blind: (c) => 'blind-',
        )!}number-tile-${loc.index(boardSize)}'),
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
