import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/widgets/number_tile.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';

class PlayboardView extends HookConsumerWidget {
  const PlayboardView({
    Key? key,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final double size;
  final Function(int index) onPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardSize = ref.watch(playboardControllerProvider.select((value) {
      if (value is SinglePlayboardState) {
        return value.playboard.size;
      }
      throw UnimplementedError('Unsupported state');
    }));

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: List.generate(
          boardSize * boardSize,
          (index) => _numberTile(index, size, boardSize),
        ),
      ),
    );
  }

  Widget _numberTile(int index, double size, int boardSize) {
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
            begin: Size(boardSize / 2, boardSize / 2),
            end: loc.toSize,
          ),
          builder: (context, value, child) => Positioned(
            top: (value?.height ?? loc.dy) * size / boardSize,
            left: (value?.width ?? loc.dx) * size / boardSize,
            child: _getTileWithConfig(size, index, config, boardSize),
          ),
        );
      },
    );
  }

  Widget _getTileWithConfig(
    double size,
    int index,
    PlayboardConfig config,
    int boardSize,
  ) {
    if (config is NumberPlayboardConfig) {
      return NumberTile(
        index: index,
        boardSize: boardSize,
        playboardSize: size,
        color: config.color,
        onPressed: onPressed,
      );
    }

    throw UnimplementedError('Unimplemented kind of $config');
  }
}
