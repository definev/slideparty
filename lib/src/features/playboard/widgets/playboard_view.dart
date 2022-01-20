import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:slideparty/src/features/playboard/models/playboard_animation_types.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';

import '../playboard.dart';

class PlayboardView extends HookConsumerWidget {
  const PlayboardView({
    Key? key,
    required this.size,
    required this.onPressed,
    required this.clipBehavior,
  }) : super(key: key);

  final double size;
  final Function(int index) onPressed;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardSize = ref.watch(playboardControllerProvider.select((value) {
      if (value is SinglePlayboardState) {
        return value.playboard.size;
      }
      throw UnimplementedError('Unsupported state');
    }));
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
        animationTypes == PlayboardAnimationTypes.heartScaleFade,
        boardSize,
      ),
    );
  }

  TweenAnimationBuilder<double> _heartScaleFade(
    bool isAnimated,
    int boardSize,
  ) {
    return TweenAnimationBuilder<double>(
        duration: const Duration(seconds: 2),
        curve: Curves.decelerate,
        tween: Tween<double>(begin: 0, end: isAnimated ? 1 : 0),
        builder: (context, value, child) {
          return Transform.rotate(
            angle: -(pi * 3 / 4) * value,
            origin: const Offset(0.5, 0.5),
            child: Transform.scale(
              scale: value == 0
                  ? 1
                  : 1 + (size / sqrt(size * size * 2) - 1) * value,
              child: SizedBox(
                height: size,
                width: size,
                child: Stack(
                  clipBehavior: clipBehavior,
                  children: List.generate(
                    boardSize * boardSize,
                    (index) => _numberTile(
                      index: index,
                      size: size,
                      boardSize: boardSize,
                      animationType: PlayboardAnimationTypes.heartScaleFade,
                      animateValue: value,
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _numberTile({
    required int index,
    required double size,
    required int boardSize,
    required PlayboardAnimationTypes animationType,
    required double animateValue,
  }) {
    if (index == boardSize * boardSize - 1) return const SizedBox();
    return Consumer(
      builder: (context, ref, child) {
        final loc = ref.watch(
          playboardControllerProvider.select((state) {
            if (state is SinglePlayboardState) {
              return state.playboard.currentLoc(index);
            }
            throw UnimplementedError(
                'This kind of playboard is not implemented yet.');
          }),
        );

        final config = ref.watch(
          playboardControllerProvider.select((value) => value.config),
        );
        return TweenAnimationBuilder<Size?>(
          duration: const Duration(milliseconds: 500),
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
            child: _getTileWithConfig(
              loc: loc,
              size: size,
              index: index,
              config: config,
              boardSize: boardSize,
              animationType: animationType,
              animateValue: animateValue,
            ),
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
    required int boardSize,
    required PlayboardAnimationTypes animationType,
    required double animateValue,
  }) {
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

    throw UnimplementedError('Unimplemented kind of $config');
  }
}
