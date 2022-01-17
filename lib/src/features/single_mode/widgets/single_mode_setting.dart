import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/audio/general_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';

class SingleModeSetting extends ConsumerWidget {
  const SingleModeSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openSettingController = ref.watch(singleModeSettingProvider.notifier);
    final size = ref.watch(playboardControllerProvider.select((state) {
      if (state is SinglePlayboardState) {
        return state.playboard.size;
      }
      throw Exception('SingleModeSetting: state is not SinglePlayboardState');
    }));
    final controller = ref.watch(playboardControllerProvider.notifier)
        as SingleModePlayboardController;

    return Card(
      color: Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 16.0),
      child: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 32.0, left: 32.0, right: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    child: LineIcon.home(),
                    onTap: () => context.go('/'),
                  ),
                  Text(
                    'Setting',
                    style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  GestureDetector(
                    child: LineIcon.times(),
                    onTap: () => openSettingController.state = false,
                  ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 32.0, top: 32.0, right: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer(
                    builder: (context, ref, _) {
                      final audioController =
                          ref.watch(generalAudioControllerProvider);
                      final color = audioController.isMuted
                          ? Theme.of(context).disabledColor
                          : Theme.of(context).colorScheme.primary;

                      return TextButton(
                        onPressed: () =>
                            audioController.isMuted = !audioController.isMuted,
                        style: TextButton.styleFrom(
                            backgroundColor: color.withOpacity(0.1)),
                        child: Text(
                          'Sound',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2!
                              .copyWith(color: color),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 16.0, left: 32.0, right: 32.0),
                child: Text(
                  'Layout',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 32.0,
                  right: 32.0,
                  bottom: 32.0,
                  top: 16.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeDimension(3),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: size == 3
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              width: 1,
                            ),
                            color: Colors.transparent,
                          ),
                          child: Center(
                              child: Text(
                            '3 x 3',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  color: size == 3
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeDimension(4),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: size == 4
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            '4 x 4',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  color: size == 4
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                          )),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.changeDimension(5),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: size == 5
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context).colorScheme.onSurface,
                              width: 1,
                            ),
                          ),
                          child: Center(
                              child: Text(
                            '5 x 5',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                  color: size == 5
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                          )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
