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

  double _rSpacing(double playboardSize, int boardSize) =>
      2.5 * _tileSize(playboardSize, boardSize) / 49;
  double _tileSize(double playboardSize, int boardSize) =>
      playboardSize / boardSize;
  double maxPlayboardSize(double screenSize, int boardSize) =>
      screenSize - 16 - 2 * _rSpacing(screenSize, boardSize);

  Widget playboard(
    BuildContext context,
    SingleModePlayboardController controller,
    SinglePlayboardState state,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return ColoredBox(
      color: state.config.bgColor.backgroundColor(context),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _header(screenSize, state, controller),
            ConstrainedBox(
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
            ),
            _controlBar(screenSize, state, context, controller),
          ],
        ),
      ),
    );
  }

  ConstrainedBox _controlBar(
    Size screenSize,
    SinglePlayboardState state,
    BuildContext context,
    SingleModePlayboardController controller,
  ) {
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
                onPressed: () {
                  controller.autoSolve(context);
                },
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

  ConstrainedBox _header(Size screenSize, SinglePlayboardState state,
      SingleModePlayboardController controller) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxPlayboardSize(
          min(425, screenSize.shortestSide),
          state.playboard.size,
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
                    child: Text.rich(
                      TextSpan(
                        text: 'STEP: ',
                        children: [
                          TextSpan(
                            text: '${state.step}',
                            style: textStyle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      style: textStyle,
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
                      child: Text.rich(
                        TextSpan(
                          text: 'BEST: ',
                          children: [
                            TextSpan(
                              text: state.bestStep == -1
                                  ? '?'
                                  : state.bestStep.toString(),
                              style: textStyle.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        style: textStyle,
                      )),
                ),
              ],
            );
          },
        ),
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
              final state = ref.watch(playboardControllerProvider)
                  as SinglePlayboardState;
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
                  child: playboard(context, controller, state),
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
                  child: playboard(context, controller, state),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
