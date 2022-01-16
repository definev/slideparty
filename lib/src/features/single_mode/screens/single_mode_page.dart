import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/controllers.dart';
import 'package:slideparty/src/features/single_mode/widgets/single_mode_setting.dart';
import 'package:slideparty/src/features/single_mode/widgets/widgets.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_dialog.dart';
import 'package:slideparty/src/widgets/widgets.dart';

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
    Size screenSize,
    SingleModePlayboardController controller,
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

          return SizedBox(
            height: size,
            width: size,
            child: Stack(
              children: [
                Center(
                  child: Consumer(
                    builder: (context, ref, child) {
                      final openSetting = ref.watch(singleModeSettingProvider);
                      return PlayboardView(
                        size: size - 32,
                        onPressed: controller.move,
                        clipBehavior: openSetting ? Clip.antiAlias : Clip.none,
                      );
                    },
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final openSetting = ref.watch(singleModeSettingProvider);
                    return IgnorePointer(
                      ignoring: !openSetting,
                      child: AnimatedOpacity(
                        opacity: openSetting ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: child,
                      ),
                    );
                  },
                  child: const SingleModeSetting(),
                ),
              ],
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
                    child: playboard(context, controller),
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
                      child: playboard(context, controller),
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
                        child: playboard(context, controller),
                      ),
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}
