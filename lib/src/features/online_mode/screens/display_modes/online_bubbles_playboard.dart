import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket_be.dart';

class OnlineBubblesPlayboard extends HookConsumerWidget {
  const OnlineBubblesPlayboard({Key? key}) : super(key: key);

  Widget cannotHappenState(dynamic state) =>
      throw UnimplementedError('This cannot happen state: $state');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      playboardControllerProvider.select(
        (value) => value as OnlinePlayboardState,
      ),
    );
    final data = state.state as RoomData;
    final controller = ref.watch(playboardControllerProvider.notifier)
        as OnlinePlayboardController;
    final focusNode = useFocusNode();

    return GestureDetector(
      onTap: () => focusNode.requestFocus(),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 425, maxHeight: 425),
              child: LayoutBuilder(
                builder: (context, constraints) {
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
                        child: PlayboardView(
                          playerId: state.playerId,
                          boardSize: state.boardSize,
                          size: constraints.biggest.longestSide,
                          duration: const Duration(milliseconds: 400),
                          onPressed: controller.move,
                          clipBehavior: Clip.none,
                        ),
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
                        child: PlayboardView(
                          playerId: state.playerId,
                          boardSize: state.boardSize,
                          size: constraints.biggest.longestSide,
                          duration: const Duration(milliseconds: 400),
                          onPressed: controller.move,
                          clipBehavior: Clip.none,
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
                          child: PlayboardView(
                            playerId: state.playerId,
                            boardSize: state.boardSize,
                            size: constraints.biggest.longestSide,
                            duration: const Duration(milliseconds: 400),
                            onPressed: controller.move,
                            clipBehavior: Clip.none,
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text('Number of player: ${data.players.length}'),
            ),
          ],
        ),
      ),
    );
  }
}
