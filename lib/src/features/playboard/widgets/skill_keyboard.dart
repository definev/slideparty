import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';

import 'package:slideparty/src/features/playboard/models/playboard_skill_keyboard_control.dart';
import 'package:slideparty/src/features/playboard/models/skill_keyboard_state.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

final multipleSkillStateProvider = StateProvider //
    .autoDispose
    .family<SkillKeyboardState, String>(
  (ref, index) => SkillKeyboardState.inGame(playerId: index),
);

class SkillKeyboard extends HookConsumerWidget {
  const SkillKeyboard(
    this.keyboard, {
    Key? key,
    this.otherPlayersIds,
    this.otherPlayersColors,
    required this.playerId,
    required this.size,
    required this.playerCount,
  }) : super(key: key);

  final String playerId;
  final List<String>? otherPlayersIds;
  final List<ButtonColors>? otherPlayersColors;
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
        label = Text(
          key.keyLabel,
          style: Theme.of(context).textTheme.bodyText2!.copyWith(
                fontSize: size < 30 ? 8 : 12,
                color: Theme.of(context).colorScheme.onBackground,
              ),
        );
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
      ? 'Space Key'
      : keyboard.activeSkillKey.keyLabel + ' Key';

  Widget _actionIcon(
    BuildContext context,
    SlidepartyActions actions,
    bool isDisabled,
  ) {
    final color = isDisabled
        ? Theme.of(context).disabledColor
        : Theme.of(context).colorScheme.onPrimary;
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
    SkillKeyboardState openSkill, {
    required int index,
  }) {
    if (openSkill.show) {
      if (openSkill.queuedAction == null) {
        if (openSkill.usedActions[SlidepartyActions.values[index]] == true) {
          return Theme.of(context).colorScheme.surface;
        }
        return Theme.of(context).colorScheme.primary;
      } else {
        if (otherPlayersColors != null &&
            otherPlayersColors!.length >= index + 1) {
          return otherPlayersColors![index].primaryColor;
        }
        if (otherPlayersIds != null && otherPlayersIds!.length >= index + 1) {
          return ButtonColors
              .values[int.parse(otherPlayersIds![index])].primaryColor;
        }
        return Theme.of(context).colorScheme.surface;
      }
    } else {
      return Theme.of(context).colorScheme.surface;
    }
  }

  CrossFadeState _crossFadeState(SlidepartyActions? actions) =>
      actions == null ? CrossFadeState.showFirst : CrossFadeState.showSecond;

  Widget _buildOpponentSelect(
    BuildContext context,
    int cardIndex,
    SkillKeyboardState openSkill,
  ) {
    if (otherPlayersIds != null) {
      return Expanded(
        child: Card(
          margin: EdgeInsets.all(size < 30 ? 2 : 4),
          color: _cardColor(
            context,
            openSkill,
            index: cardIndex,
          ),
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.decelerate,
              secondCurve: Curves.easeOutCirc,
              crossFadeState: _crossFadeState(openSkill.queuedAction),
              firstChild: _actionIcon(
                context,
                SlidepartyActions.values[cardIndex],
                openSkill.usedActions[SlidepartyActions.values[cardIndex]] ==
                    true,
              ),
              secondChild: Text(
                otherPlayersIds!.length > cardIndex
                    ? otherPlayersIds![cardIndex]
                    : '',
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                key: otherPlayersIds!.length > cardIndex
                    ? ValueKey(
                        'Other player ${otherPlayersIds![cardIndex]} of $playerId',
                      )
                    : null,
              ),
            ),
          ),
        ),
      );
    }
    if (otherPlayersColors != null) {
      return Expanded(
        child: Card(
          margin: EdgeInsets.all(size < 30 ? 2 : 4),
          color: _cardColor(
            context,
            openSkill,
            index: cardIndex,
          ),
          child: Center(
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              firstCurve: Curves.decelerate,
              secondCurve: Curves.easeOutCirc,
              crossFadeState: _crossFadeState(openSkill.queuedAction),
              firstChild: _actionIcon(
                context,
                SlidepartyActions.values[cardIndex],
                openSkill.usedActions[SlidepartyActions.values[cardIndex]] ==
                    true,
              ),
              secondChild: Text(
                otherPlayersColors!.length > cardIndex
                    ? otherPlayersColors![cardIndex].name[0].toString()
                    : '',
                key: otherPlayersColors!.length > cardIndex
                    ? ValueKey(
                        'Other player ${otherPlayersColors![cardIndex]} of $playerId',
                      )
                    : null,
              ),
            ),
          ),
        ),
      );
    }
    throw UnimplementedError('No other players');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final openSkill = ref.watch(multipleSkillStateProvider(playerId));
    final reduceMotion = ref.watch(
        appSettingControllerProvider.select((value) => value.reduceMotion));

    final skillBar = SizedBox(
      height: size,
      width: size * 3,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCirc,
        opacity: openSkill.show ? 1 : 0,
        child: Row(
          children: [
            for (int cardIndex = 0; cardIndex < 3; cardIndex++)
              _buildOpponentSelect(context, cardIndex, openSkill),
          ],
        ),
      ),
    );

    return RepaintBoundary(
      child: SizedBox.square(
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
                  if (reduceMotion)
                    Positioned(
                      left: 0,
                      top: -(openSkill.show ? 1 : 0) * size,
                      child: skillBar,
                    )
                  else
                    _animateSkillBar(openSkill, skillBar),
                  _skillStateBar(context, reduceMotion, openSkill),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TweenAnimationBuilder<double> _animateSkillBar(
      SkillKeyboardState openSkill, SizedBox skillBar) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: openSkill.show ? 1 : 0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.decelerate,
      child: skillBar,
      builder: (context, value, child) {
        return Positioned(
          left: 0,
          top: -value * size,
          child: child!,
        );
      },
    );
  }

  Card _skillStateBar(
    BuildContext context,
    bool reduceMotion,
    SkillKeyboardState openSkill,
  ) {
    return Card(
      margin: EdgeInsets.all(size < 30 ? 2 : 4),
      shape: RoundedRectangleBorder(
        borderRadius: size < 30 ? BorderRadius.zero : BorderRadius.circular(5),
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
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withOpacity(0.6)),
                )),
                Center(
                  child: Text(
                    skillButtonText,
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ],
            ),
          ),
          reduceMotion
              ? (openSkill.queuedAction != null
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
                  : const SizedBox())
              : AnimatedSize(
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
    );
  }
}
