import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class SkillMenu extends HookConsumerWidget {
  const SkillMenu({
    Key? key,
    required this.size,
    required this.playerId,
    required this.color,
    this.otherPlayerColors,
  }) : super(key: key);

  final double size;
  final String playerId;
  final ButtonColors color;
  final List<ButtonColors>? otherPlayerColors;

  Widget _actionIcon(
    BuildContext context,
    SlidepartyActions actions,
  ) {
    switch (actions) {
      case SlidepartyActions.blind:
        return const LineIcon.lowVision();
      case SlidepartyActions.pause:
        return const LineIcon.userSlash();
      case SlidepartyActions.clear:
        return const LineIcon.userShield();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final controller = ref.watch(playboardControllerProvider.notifier);
    final openSkill = ref.watch(multipleSkillStateProvider(playerId));
    final openSkillNotifier =
        ref.watch(multipleSkillStateProvider(playerId).notifier);
    final pickedColor = useState<ButtonColors?>(null);

    return GestureDetector(
      onTap: () {
        openSkillNotifier.state =
            openSkill.copyWith(show: false, queuedAction: null);
        pickedColor.value = null;
      },
      child: ColoredBox(
        color: themeData.scaffoldBackgroundColor.withOpacity(0.3),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: SeparatedColumn(
            separatorBuilder: () => const SizedBox(height: 16),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SeparatedRow(
                separatorBuilder: () => const SizedBox(width: 8),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final action in SlidepartyActions.values)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: openSkill.queuedAction == action ? 1.1 : 1,
                      child: SlidepartyButton(
                        key:
                            ValueKey('Owner $playerId - Action ${action.name}'),
                        color: color,
                        style: openSkill.queuedAction != null &&
                                openSkill.queuedAction != action
                            ? SlidepartyButtonStyle.invert
                            : openSkill.usedActions[action] == true
                                ? SlidepartyButtonStyle.invert
                                : SlidepartyButtonStyle.normal,
                        onPressed: () {
                          if (openSkill.usedActions[action] == true) {
                            Navigator.pop(context);
                            return;
                          }
                          if (controller is MultipleModeController) {
                            controller.pickAction(playerId, action);
                          }
                          if (controller is OnlineModeController) {
                            controller.pickAction(action);
                          }
                        },
                        size: ButtonSize.square,
                        child: _actionIcon(context, action),
                      ),
                    ),
                ],
              ),
              SeparatedRow(
                separatorBuilder: () => const SizedBox(width: 8),
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final otherColor in otherPlayerColors!)
                    AnimatedScale(
                      duration: const Duration(milliseconds: 200),
                      scale: pickedColor.value == otherColor ? 1.1 : 1,
                      child: SlidepartyButton(
                        color: otherColor,
                        onPressed: () => pickedColor.value = otherColor,
                        size: ButtonSize.square,
                        style: pickedColor.value == otherColor ||
                                pickedColor.value == null
                            ? SlidepartyButtonStyle.normal
                            : SlidepartyButtonStyle.invert,
                        child: Text(otherColor.name[0].toUpperCase()),
                      ),
                    ),
                ],
              ),
              SlidepartyButton(
                key: ValueKey('Owner $playerId - Apply skill'),
                color: color,
                style: (openSkill.queuedAction != null &&
                        pickedColor.value != null)
                    ? SlidepartyButtonStyle.normal
                    : SlidepartyButtonStyle.invert,
                customSize: const Size(49 * 3 + 16, 49),
                onPressed: () {
                  if (controller is MultipleModeController) {
                    controller.doAction(
                      playerId,
                      pickedColor.value!.index.toString(),
                    );
                  }
                  if (controller is OnlineModeController) {
                    controller.doAction(pickedColor.value!);
                  }
                  pickedColor.value = null;
                },
                child: const Text('Apply skill'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
