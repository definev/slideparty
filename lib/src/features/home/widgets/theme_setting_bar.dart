import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';
import 'package:slideparty/src/features/audio/background_audio_controller.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';

class ThemeSettingBar extends HookConsumerWidget {
  const ThemeSettingBar({Key? key}) : super(key: key);

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

    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Center(
        child: SizedBox(
          width: 190,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PortalEntry(
                visible: isColorPickerExpand.value,
                childAnchor: Alignment.bottomRight,
                portalAnchor: Alignment.bottomLeft,
                portal: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...ButtonColors.values.map(
                      (color) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: isPreCloseColorPicker.value ? 0.0 : 1.0,
                          ),
                          duration: Duration(
                            milliseconds: 200 +
                                200 *
                                    (isPreCloseColorPicker.value == false
                                        ? (ButtonColors.values.length -
                                            color.index -
                                            1)
                                        : color.index),
                          ),
                          curve: Curves.decelerate,
                          builder: (context, value, child) => Opacity(
                            opacity: delayedProgress(
                              ButtonColors.values.length,
                              value,
                              ButtonColors.values.length - color.index,
                            ),
                            child: child!,
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom:
                                  color.index == ButtonColors.values.length - 1
                                      ? 0.0
                                      : 8.0,
                              left: (190 - 49 * 3) / 2,
                            ),
                            child: IgnorePointer(
                              ignoring: isPreCloseColorPicker.value,
                              child: SlidepartyButton(
                                color: color,
                                size: ButtonSize.square,
                                onPressed: () =>
                                    playboardInfoController.color = color,
                                child: Text(color.name[0].toUpperCase()),
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
                            milliseconds: 200 * ButtonColors.values.length),
                        () {
                          isPreCloseColorPicker.value = false;
                          isColorPickerExpand.value = false;
                        },
                      );
                    }
                  },
                  child: isColorPickerExpand.value == false
                      ? const Icon(Icons.arrow_circle_up_outlined)
                      : const Icon(Icons.arrow_circle_down_outlined),
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
                          FadeTransition(opacity: animation, child: child),
                      child: isDarkMode
                          ? const Icon(Icons.light_mode)
                          : const Icon(Icons.dark_mode),
                    )),
              ),
              SlidepartyButton(
                color: playboardDefaultColor,
                size: ButtonSize.square,
                onPressed: () =>
                    initSound ? audioController.stop() : audioController.play(),
                child: initSound
                    ? const Icon(Icons.music_off)
                    : const Icon(Icons.music_note),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
