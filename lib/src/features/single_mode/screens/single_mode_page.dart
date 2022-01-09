import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';

class SingleModePage extends ConsumerWidget {
  const SingleModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ProviderScope(
      overrides: [
        playboardControllerProvider
            .overrideWithProvider(singleModeControllerProvider),
      ],
      child: Scaffold(
        body: Center(
          child: HookConsumer(
            builder: (context, ref, child) {
              final focusNode = useFocusNode();
              final controller = ref.watch(playboardControllerProvider.notifier)
                  as SingleModePlayboardController;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints.tight(const Size(500, 500)),
                  child: Center(
                    child: RawKeyboardListener(
                      focusNode: focusNode,
                      autofocus: true,
                      onKey: (event) {
                        if (event is RawKeyDownEvent) {
                          controller.moveByKeyboard(event.logicalKey);
                        }
                      },
                      child: PlayboardView(onPressed: controller.move),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
