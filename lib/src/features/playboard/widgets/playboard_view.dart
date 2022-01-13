import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/widgets/number_tile.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';

class PlayboardView extends StatelessWidget {
  const PlayboardView({
    Key? key,
    required this.size,
    required this.onPressed,
  }) : super(key: key);

  final double size;
  final Function(int index) onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        children: List.generate(
          16,
          (index) => _numberTile(index, size),
        ),
      ),
    );
  }

  Widget _numberTile(int index, double size) {
    if (index == 15) return const SizedBox();
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
            begin: const Size(2, 2),
            end: loc.toSize,
          ),
          builder: (context, value, child) => Positioned(
            top: (value?.height ?? loc.dy) * size / 4,
            left: (value?.width ?? loc.dx) * size / 4,
            child: _getTileWithConfig(size, index, config),
          ),
        );
      },
    );
  }

  Widget _getTileWithConfig(double size, int index, PlayboardConfig config) {
    if (config is NumberPlayboardConfig) {
      return NumberTile(
        index: index,
        boardSize: 4,
        playboardSize: size,
        color: config.color,
        onPressed: onPressed,
      );
    }

    throw UnimplementedError('Unimplemented kind of $config');
  }
}
