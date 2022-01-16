import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';
import 'package:slideparty/src/utils/durations.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_dialog.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:universal_platform/universal_platform.dart';

class SingleModePage extends StatelessWidget {
  const SingleModePage({Key? key}) : super(key: key);

  Widget playboard(
    BuildContext context,
    SingleModePlayboardController controller,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final backgroundColor =
            ref.watch(playboardControllerProvider.select((state) {
          if (state is SinglePlayboardState) {
            return state.config.bgColor.backgroundColor(context);
          }
          throw UnimplementedError('This cannot happen');
        }));
        return ColoredBox(
          color: backgroundColor,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SingleModeHeader(),
                _playboardView(screenSize, controller),
                const SingleModeControlBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  ConstrainedBox _playboardView(
      Size screenSize, SingleModePlayboardController controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: min(425, screenSize.shortestSide),
        maxWidth: min(425, screenSize.shortestSide),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameSize = constraints.biggest;
          final size = frameSize.shortestSide;

          return SizedBox(
            height: size,
            width: size,
            child: Center(
              child: PlayboardView(
                size: size - 32,
                onPressed: controller.move,
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: ProviderScope(
        overrides: [
          playboardControllerProvider
              .overrideWithProvider(singleModeControllerProvider),
        ],
        child: Scaffold(
          body: HookConsumer(
            builder: (context, ref, child) {
              final focusNode = useFocusNode();
              final controller = ref.watch(playboardControllerProvider.notifier)
                  as SingleModePlayboardController;
              final isMounted = useIsMounted();
              ref.listen<bool>(
                playboardControllerProvider.select((state) {
                  if (state is SinglePlayboardState) {
                    return state.playboard.isSolved;
                  }
                  return false;
                }),
                (_, next) {
                  if (next) {
                    Future.delayed(
                      const Duration(seconds: 4),
                      () {
                        if (isMounted()) {
                          showDialog(
                            context: context,
                            builder: (context) => const SlidepartyDialog(),
                          );
                        }
                      },
                    );
                  }
                },
              );

              if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
                return SwipeDetector(
                  onSwipeLeft: () =>
                      controller.moveByGesture(PlayboardDirection.left),
                  onSwipeRight: () =>
                      controller.moveByGesture(PlayboardDirection.right),
                  onSwipeUp: () =>
                      controller.moveByGesture(PlayboardDirection.up),
                  onSwipeDown: () =>
                      controller.moveByGesture(PlayboardDirection.down),
                  child: playboard(context, controller),
                );
              }

              return RawKeyboardListener(
                focusNode: focusNode,
                autofocus: true,
                onKey: (event) {
                  if (event is RawKeyDownEvent) {
                    controller.moveByKeyboard(event.logicalKey);
                  }
                },
                child: GestureDetector(
                  onTap: () => focusNode.requestFocus(),
                  child: playboard(context, controller),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SingleModeHeader extends ConsumerWidget {
  const SingleModeHeader({Key? key}) : super(key: key);

  double _rSpacing(double playboardSize, int boardSize) =>
      2.5 * _tileSize(playboardSize, boardSize) / 49;
  double _tileSize(double playboardSize, int boardSize) =>
      playboardSize / boardSize;
  double maxPlayboardSize(double screenSize, int boardSize) =>
      screenSize - 16 - 2 * _rSpacing(screenSize, boardSize);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardSize = ref.watch(playboardControllerProvider.select((state) {
      if (state is SinglePlayboardState) {
        return state.playboard.size;
      }
      throw UnimplementedError('This cannot happen');
    }));
    final screenSize = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxPlayboardSize(
          min(425, screenSize.shortestSide),
          boardSize,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final textStyle = Theme.of(context).textTheme.subtitle1!.copyWith(
                  fontSize: Playboard.bp.responsiveValue(
                    constraints.biggest,
                    watch: 10,
                    tablet: 16,
                    defaultValue: 14,
                  ),
                );

            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Consumer(
                      builder: (context, ref, child) {
                        final step = ref
                            .watch(playboardControllerProvider.select((state) {
                          if (state is SinglePlayboardState) {
                            return state.step;
                          }
                          throw UnimplementedError('This cannot happen');
                        }));

                        return Text.rich(
                          TextSpan(
                            text: 'STEP: ',
                            children: [
                              TextSpan(
                                text: '$step',
                                style: textStyle.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          style: textStyle,
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Center(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final duration = ref.watch(counterProvider);
                        return Text(
                          Durations.watchFormat(duration),
                          style: textStyle.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Consumer(builder: (context, ref, child) {
                        final bestStep = ref
                            .watch(playboardControllerProvider.select((state) {
                          if (state is SinglePlayboardState) {
                            return state.bestStep;
                          }
                          throw UnimplementedError('This cannot happen');
                        }));

                        return Text.rich(
                          TextSpan(
                            text: 'BEST: ',
                            children: [
                              TextSpan(
                                text:
                                    bestStep == -1 ? '?' : bestStep.toString(),
                                style: textStyle.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          style: textStyle,
                        );
                      })),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class SingleModeControlBar extends ConsumerWidget {
  const SingleModeControlBar({Key? key}) : super(key: key);

  double _rSpacing(double playboardSize, int boardSize) =>
      2.5 * _tileSize(playboardSize, boardSize) / 49;
  double _tileSize(double playboardSize, int boardSize) =>
      playboardSize / boardSize;
  double maxPlayboardSize(double screenSize, int boardSize) =>
      screenSize - 16 - 2 * _rSpacing(screenSize, boardSize);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playboardControllerProvider.notifier)
        as SingleModePlayboardController;
    final state =
        ref.watch(playboardControllerProvider) as SinglePlayboardState;
    final screenSize = MediaQuery.of(context).size;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxPlayboardSize(
          min(425, screenSize.shortestSide),
          state.playboard.size,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () => controller.reset(),
              icon: Icon(
                LineIcons.syncIcon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            if (state.bestStep > 0)
              TextButton(
                onPressed: () => controller.autoSolve(context),
                child: const Text('SOLVE'),
              ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                LineIcons.cog,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
