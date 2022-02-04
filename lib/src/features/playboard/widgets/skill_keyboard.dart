import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';

import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/models/skill_keyboard_state.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

final skillStateProvider =
    StateProvider.autoDispose.family<SkillKeyboardState, int>(
  (ref, index) => SkillKeyboardState.inGame(playerIndex: index),
);

class SkillKeyboard extends HookConsumerWidget {
  const SkillKeyboard(
    this.keyboard, {
    Key? key,
    required this.index,
    required this.size,
    required this.playerCount,
  }) : super(key: key);

  final int index;
  final int playerCount;
  final double size;
  final PlayboardSkillKeyboardControl keyboard;

  Widget _buildKey(BuildContext context, LogicalKeyboardKey key) {
    Widget label;
    switch (key.keyLabel) {
      case 'Arrow Up':
        label = LineIcon.arrowUp(size: size < 30 ? 8 : 12);
        break;
      case 'Arrow Down':
        label = LineIcon.arrowDown(size: size < 30 ? 8 : 12);
        break;
      case 'Arrow Left':
        label = LineIcon.arrowLeft(size: size < 30 ? 8 : 12);
        break;
      case 'Arrow Right':
        label = LineIcon.arrowRight(size: size < 30 ? 8 : 12);
        break;
      default:
        label = Text(key.keyLabel,
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontSize: size < 30 ? 8 : 12));
    }

    return Expanded(
      child: Card(
        margin: EdgeInsets.all(size < 30 ? 2 : 4),
        shape: RoundedRectangleBorder(
          borderRadius:
              size < 30 ? BorderRadius.zero : BorderRadius.circular(5),
        ),
        child: Center(child: label),
      ),
    );
  }

  String get skillButtonText => keyboard.activeSkillKey.keyLabel == ' '
      ? '⎵ Key'
      : keyboard.activeSkillKey.keyLabel + ' Key';

  Widget _actionIcon(
    BuildContext context,
    SlidepartyActions actions,
    bool isDisabled,
  ) {
    final color = isDisabled
        ? Theme.of(context).disabledColor
        : Theme.of(context).colorScheme.onSurface;
    switch (actions) {
      case SlidepartyActions.blind:
        return LineIcon.lowVision(color: color);
      case SlidepartyActions.pause:
        return LineIcon.userSlash(color: color);
      case SlidepartyActions.clear:
        return LineIcon.userShield(color: color);
    }
  }

  Color _cardColor(
    BuildContext context,
    SkillKeyboardState openSkill,
    List<int> otherPlayersIndex, {
    required int index,
  }) {
    if (openSkill.show) {
      if (openSkill.queuedAction == null) {
        if (openSkill.usedActions[SlidepartyActions.values[index]] == true) {
          return Theme.of(context).colorScheme.surface;
        }
        return Theme.of(context).colorScheme.primary;
      } else {
        if (otherPlayersIndex.length >= index + 1) {
          return Theme.of(context).colorScheme.primary;
        } else {
          return Theme.of(context).colorScheme.surface;
        }
      }
    } else {
      return Theme.of(context).colorScheme.surface;
    }
  }

  CrossFadeState _crossFadeState(SlidepartyActions? actions) =>
      actions == null ? CrossFadeState.showFirst : CrossFadeState.showSecond;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openSkill = ref.watch(skillStateProvider(index));
    final otherPlayersIndex = useMemoized(() => [
          for (var i = 0; i < playerCount; i++)
            if (i != index) i
        ]);

    return SizedBox.square(
      dimension: size * 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              children: List.generate(
                3,
                (index) => index == 1
                    ? _buildKey(context, keyboard.control.up)
                    : const Expanded(child: SizedBox()),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                _buildKey(context, keyboard.control.left),
                _buildKey(context, keyboard.control.down),
                _buildKey(context, keyboard.control.right),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: openSkill.show ? 1 : 0),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: SizedBox(
                    height: size,
                    width: size * 3,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCirc,
                      opacity: openSkill.show ? 1 : 0,
                      child: Row(
                        children: [
                          for (int cardIndex = 0; cardIndex < 3; cardIndex++)
                            Expanded(
                              child: Card(
                                margin: EdgeInsets.all(size < 30 ? 2 : 4),
                                color: _cardColor(
                                  context,
                                  openSkill,
                                  otherPlayersIndex,
                                  index: cardIndex,
                                ),
                                child: Center(
                                  child: AnimatedCrossFade(
                                    duration: const Duration(milliseconds: 300),
                                    firstCurve: Curves.decelerate,
                                    secondCurve: Curves.easeOutCirc,
                                    crossFadeState:
                                        _crossFadeState(openSkill.queuedAction),
                                    firstChild: _actionIcon(
                                      context,
                                      SlidepartyActions.values[cardIndex],
                                      openSkill.usedActions[SlidepartyActions
                                              .values[cardIndex]] ==
                                          true,
                                    ),
                                    secondChild: Text(
                                      '${otherPlayersIndex.length > cardIndex ? otherPlayersIndex[cardIndex] + 1 : ''}',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  builder: (context, value, child) {
                    return Positioned(
                      left: 0,
                      top: -value * size,
                      child: child!,
                    );
                  },
                ),
                Card(
                  margin: EdgeInsets.all(size < 30 ? 2 : 4),
                  shape: RoundedRectangleBorder(
                    borderRadius: size < 30
                        ? BorderRadius.zero
                        : BorderRadius.circular(5),
                  ),
                  elevation: 10,
                  color: Theme.of(context).colorScheme.primary,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              'Skills',
                              style: Theme.of(context)
                                  .textTheme
                                  .caption!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.6)),
                            )),
                            Center(
                              child: Text(
                                skillButtonText,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedSize(
                        duration: const Duration(milliseconds: 300),
                        child: openSkill.queuedAction != null
                            ? SizedBox(
                                height: size - 8,
                                width: size - 8,
                                child: Center(
                                  child: _actionIcon(
                                    context,
                                    openSkill.queuedAction!,
                                    false,
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
