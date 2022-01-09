import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';
import 'package:slideparty/src/widgets/swipe_detector.dart';
import 'package:universal_platform/universal_platform.dart';

class SingleModePage extends StatelessWidget {
  const SingleModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        playboardControllerProvider
            .overrideWithProvider(singleModeControllerProvider),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            Center(
              child: HookConsumer(
                builder: (context, ref, child) {
                  final focusNode = useFocusNode();
                  final controller =
                      ref.watch(playboardControllerProvider.notifier)
                          as SingleModePlayboardController;
                  final playboard = ConstrainedBox(
                    constraints: BoxConstraints.tight(const Size(500, 500)),
                    child: Center(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final frameSize = constraints.biggest;
                          final size = frameSize.height < frameSize.width
                              ? frameSize.height
                              : frameSize.width;

                          return SizedBox(
                            height: size,
                            width: size,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: PlayboardView(
                                size: size - 32,
                                onPressed: controller.move,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
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
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [playboard],
                        ),
                      ),
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
                    child: playboard,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
