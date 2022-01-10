import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';
import 'package:slideparty/src/features/audio/background_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class HomePage extends HookConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  double delayedProgress(int length, double animationValue, int i) =>
      ((animationValue * length.toDouble()) - (i / length))
          .clamp(0, 1)
          .toDouble();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioController =
        ref.watch(backgroundAudioControllerProvider.notifier);
    final initSound = ref.watch(backgroundAudioControllerProvider);
    final isDarkMode = ref.watch(
      appSettingControllerProvider.select((value) => value.isDarkTheme),
    );
    final appSettingController = ref.watch(appSettingControllerProvider);
    final playboardInfoController =
        ref.watch(playboardInfoControllerProvider.notifier);
    final playboardDefaultColor = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));
    final isColorPickerExpand = useState(false);
    final isPreCloseColorPicker = useState(false);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text.rich(
                TextSpan(
                  text: 'Slide',
                  children: [
                    TextSpan(
                      text: 'party',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Column(
              children: [
                SlidepartyButton(
                  color: ButtonColors.blue,
                  onPressed: () => context.go('/s_mode'),
                  child: const Text('Single Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColors.green,
                  onPressed: () => context.go('/m_mode'),
                  child: const Text('Multiple Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColors.red,
                  onPressed: () => context.go('/o_mode'),
                  child: const Text('Online Mode'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Center(
                child: SizedBox(
                  width: 190,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      PortalEntry(
                        visible: isColorPickerExpand.value,
                        childAnchor: Alignment.bottomCenter,
                        portalAnchor: Alignment.topCenter,
                        portal: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 8),
                            ...ButtonColors.values
                                .sublist(0, ButtonColors.values.length - 1)
                                .map(
                              (color) {
                                return TweenAnimationBuilder<double>(
                                  tween: Tween<double>(
                                    begin: 0.0,
                                    end:
                                        isPreCloseColorPicker.value ? 0.0 : 1.0,
                                  ),
                                  duration: Duration(
                                    milliseconds: 200 +
                                        200 *
                                            (isPreCloseColorPicker.value
                                                ? (ButtonColors.values.length -
                                                    color.index -
                                                    1)
                                                : color.index),
                                  ),
                                  curve: isPreCloseColorPicker.value
                                      ? Curves.easeOutCubic
                                      : Curves.easeInCubic,
                                  builder: (context, value, child) => Opacity(
                                    opacity: delayedProgress(
                                      ButtonColors.values.length,
                                      value,
                                      ButtonColors.values.length -
                                          color.index -
                                          1,
                                    ),
                                    child: child!,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: IgnorePointer(
                                      ignoring: isPreCloseColorPicker.value,
                                      child: SlidepartyButton(
                                        color: color,
                                        size: ButtonSize.square,
                                        onPressed: () => playboardInfoController
                                            .color = color,
                                        child:
                                            Text(color.name[0].toUpperCase()),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        child: SlidepartyButton(
                          color: playboardDefaultColor,
                          size: ButtonSize.square,
                          onPressed: () {
                            if (isPreCloseColorPicker.value == true) return;
                            if (isColorPickerExpand.value == false) {
                              isColorPickerExpand.value = true;
                            } else {
                              isPreCloseColorPicker.value = true;
                              Future.delayed(
                                Duration(
                                    milliseconds:
                                        200 * ButtonColors.values.length),
                                () {
                                  isPreCloseColorPicker.value = false;
                                  isColorPickerExpand.value = false;
                                },
                              );
                            }
                          },
                          child: isColorPickerExpand.value
                              ? const RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(Icons.arrow_drop_down_circle),
                                )
                              : const Icon(Icons.arrow_drop_down_circle),
                        ),
                      ),
                      SizedBox(
                        height: 49,
                        width: 49,
                        child: IconButton(
                            onPressed: () =>
                                appSettingController.isDarkTheme = !isDarkMode,
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 3000),
                              transitionBuilder: (child, animation) =>
                                  FadeTransition(
                                      opacity: animation, child: child),
                              child: isDarkMode
                                  ? const Icon(Icons.light_mode)
                                  : const Icon(Icons.dark_mode),
                            )),
                      ),
                      SlidepartyButton(
                        color: playboardDefaultColor,
                        size: ButtonSize.square,
                        onPressed: () => initSound
                            ? audioController.stop()
                            : audioController.play(),
                        child: initSound
                            ? const Icon(Icons.music_off)
                            : const Icon(Icons.music_note),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
