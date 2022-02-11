import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';
import 'package:slideparty/src/features/single_mode/widgets/single_mode_setting.dart';
import 'package:slideparty/src/features/single_mode/widgets/widgets.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_dialog.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_playboard_utils/slideparty_playboard_utils.dart';

class SingleModePage extends StatelessWidget {
  const SingleModePage({Key? key}) : super(key: key);

  Widget playboard(
    BuildContext context,
    SingleModePlayboardController controller,
    ValueNotifier<bool> showWinDialog,
  ) {
    final screenSize = MediaQuery.of(context).size;

    return Consumer(
      builder: (context, ref, child) {
        final backgroundColor =
            ref.watch(playboardControllerProvider.select((state) {
          if (state is SinglePlayboardState) {
            return (state.config as NumberPlayboardConfig)
                .color
                .backgroundColor(context);
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
                _playboardView(screenSize, controller, showWinDialog),
                const SingleModeControlBar(),
              ],
            ),
          ),
        );
      },
    );
  }

  ConstrainedBox _playboardView(
    Size screenSize,
    SingleModePlayboardController controller,
    ValueNotifier<bool> showWinDialog,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: min(425, screenSize.shortestSide),
        maxWidth: min(425, screenSize.shortestSide),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameSize = constraints.biggest;
          final size = frameSize.shortestSide;

          if (showWinDialog.value) {
            return Center(
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0, end: 1),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: child,
                  );
                },
                child: Consumer(builder: (context, ref, _) {
                  final playboardDefaultColor = ref.watch(
                      playboardInfoControllerProvider
                          .select((value) => value.color));

                  return SlidepartyDialog(
                    title: 'You win!',
                    content: const Text(
                      'You solved the puzzle!',
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      SlidepartyButton(
                        key: const Key('play-again-button'),
                        color: playboardDefaultColor,
                        size: ButtonSize.square,
                        style: SlidepartyButtonStyle.invert,
                        child: LineIcon.syncIcon(),
                        onPressed: () {
                          showWinDialog.value = false;
                          controller.reset();
                        },
                      ),
                      const SizedBox(width: 10),
                      SlidepartyButton(
                        color: playboardDefaultColor,
                        child: const Text('Go Home'),
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  );
                }),
              ),
            );
          }
          return SizedBox(
            height: size,
            width: size,
            child: Consumer(
              builder: (context, ref, child) {
                final openSetting = ref.watch(singleModeSettingProvider);
                return Stack(
                  children: [
                    Center(
                      child: Consumer(
                        builder: (context, ref, child) {
                          final boardSize = ref.watch(
                            playboardControllerProvider.select((state) =>
                                (state as SinglePlayboardState).playboard.size),
                          );

                          return PlayboardView(
                            key: const ValueKey('single-mode-playboard'),
                            size: size - 32,
                            onPressed: controller.move,
                            boardSize: boardSize,
                            clipBehavior:
                                openSetting ? Clip.antiAlias : Clip.none,
                          );
                        },
                      ),
                    ),
                    if (openSetting) const SingleModeSetting(),
                  ],
                );
              },
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
      child: Scaffold(
        body: HookConsumer(
          builder: (context, ref, child) {
            final focusNode = useFocusNode();
            final controller = ref.watch(playboardControllerProvider.notifier)
                as SingleModePlayboardController;
            final isMounted = useIsMounted();
            final showWinDialog = useState(false);
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
                    const Duration(seconds: 2),
                    () {
                      if (isMounted()) {
                        showWinDialog.value = true;
                      }
                    },
                  );
                }
              },
            );

            switch (AppInfos.screenType) {
              case ScreenTypes.touchscreen:
                return SwipeDetector(
                  onSwipeLeft: () =>
                      controller.moveByGesture(PlayboardDirection.left),
                  onSwipeRight: () =>
                      controller.moveByGesture(PlayboardDirection.right),
                  onSwipeUp: () =>
                      controller.moveByGesture(PlayboardDirection.up),
                  onSwipeDown: () =>
                      controller.moveByGesture(PlayboardDirection.down),
                  child: playboard(context, controller, showWinDialog),
                );
              case ScreenTypes.mouse:
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
                    child: playboard(context, controller, showWinDialog),
                  ),
                );
              case ScreenTypes.touchscreenAndMouse:
                return SwipeDetector(
                  onSwipeLeft: () =>
                      controller.moveByGesture(PlayboardDirection.left),
                  onSwipeRight: () =>
                      controller.moveByGesture(PlayboardDirection.right),
                  onSwipeUp: () =>
                      controller.moveByGesture(PlayboardDirection.up),
                  onSwipeDown: () =>
                      controller.moveByGesture(PlayboardDirection.down),
                  child: RawKeyboardListener(
                    focusNode: focusNode,
                    autofocus: true,
                    onKey: (event) {
                      if (event is RawKeyDownEvent) {
                        controller.moveByKeyboard(event.logicalKey);
                      }
                    },
                    child: GestureDetector(
                      onTap: () => focusNode.requestFocus(),
                      child: playboard(context, controller, showWinDialog),
                    ),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}
