import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/multiple_mode/widgets/win_dialog.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class MultiplePlayground extends HookConsumerWidget {
  const MultiplePlayground({
    Key? key,
    required this.playerCount,
  }) : super(key: key);

  final int playerCount;

  int get axisLength => playerCount ~/ 2 + (playerCount % 2 == 1 ? 1 : 0);

  int _flexSpace(int index, double ratio) {
    if (ratio <= 1.3) return 1;
    if (index == axisLength - 1 && playerCount % 2 == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  Axis _getDirectionOfParent(
    int index, {
    required bool preferVertical,
    required double ratio,
  }) {
    return preferVertical ? Axis.horizontal : Axis.vertical;
  }

  Axis _getDirectionOfChild(
    int index, {
    required bool preferVertical,
    required double ratio,
  }) {
    if (preferVertical) {
      if (ratio > 1.3) return Axis.vertical;
      return Axis.horizontal;
    } else {
      if (ratio > 1.3) return Axis.horizontal;
      return Axis.vertical;
    }
  }

  Widget _multiplePlayerView(
    BuildContext context, {
    required bool preferVertical,
    required double ratio,
  }) {
    switch (playerCount) {
      case 2:
        final children = List.generate(
          playerCount,
          (index) => Expanded(
            child: _PlayerPlayboardView(
              playerIndex: index,
              ratio: ratio,
            ),
          ),
        );
        return Flex(
          direction: preferVertical ? Axis.vertical : Axis.horizontal,
          children: children,
        );
      default:
        return Flex(
          direction: preferVertical ? Axis.vertical : Axis.horizontal,
          children: List.generate(
              axisLength,
              (index) => Flexible(
                    flex: _flexSpace(index, ratio),
                    child: Flex(
                      direction: _getDirectionOfParent(
                        index,
                        preferVertical: preferVertical,
                        ratio: ratio,
                      ),
                      children: [
                        Expanded(
                          child: Flex(
                            direction: _getDirectionOfChild(
                              index,
                              preferVertical: preferVertical,
                              ratio: ratio,
                            ),
                            children: List.generate(
                              playerCount % 2 == 1 && index == axisLength - 1
                                  ? 1
                                  : 2,
                              (colorIndex) => Expanded(
                                child: _PlayerPlayboardView(
                                  playerIndex: index * 2 + colorIndex,
                                  ratio: ratio,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
        );
    }
  }

  void _showWinningDialog(
    BuildContext context,
    int whoWin,
    MultipleModeController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => WinDialog(
        whoWin: whoWin,
        controller: controller,
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playboardControllerProvider.notifier)
        as MultipleModeController;
    ref.listen<int?>(
      playboardControllerProvider
          .select((value) => (value as MultiplePlayboardState).whoWin),
      (_, who) {
        if (who != null) {
          _showWinningDialog(context, who, controller);
        }
      },
    );
    final focusNode = useFocusNode();

    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        onKey: (FocusNode node, RawKeyEvent event) => KeyEventResult.handled,
        child: RawKeyboardListener(
          focusNode: focusNode,
          autofocus: true,
          onKey: (event) {
            if (event is RawKeyDownEvent) {
              controller.moveByKeyboard(event.logicalKey);
            }
          },
          child: LayoutBuilder(
            builder: (context, constraints) => _multiplePlayerView(
              context,
              preferVertical: constraints.maxWidth < constraints.maxHeight,
              ratio: constraints.biggest.longestSide /
                  constraints.biggest.shortestSide,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerPlayboardView extends ConsumerWidget {
  const _PlayerPlayboardView({
    Key? key,
    required this.playerIndex,
    required this.ratio,
  }) : super(key: key);

  final int playerIndex;
  final double ratio;

  double _playboardSize(BoxConstraints constraints) =>
      min(constraints.biggest.shortestSide - 32, 425);

  double _textPadding(BoxConstraints constraints) =>
      3 * (constraints.biggest.longestSide - _playboardSize(constraints)) / 64;

  bool isLargeScreen(BoxConstraints constraints) =>
      ratio > 1.3 && constraints.biggest.longestSide > 750;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final boardSize = ref.watch(
      playboardControllerProvider.select(
        (value) => (value as MultiplePlayboardState).boardSize,
      ),
    );
    final playerCount = ref.watch(
      playboardControllerProvider.select(
        (value) => (value as MultiplePlayboardState).playerCount,
      ),
    );
    final controller = ref.watch(playboardControllerProvider.notifier)
        as MultipleModeController;

    final view = Theme(
      data: themeData.colorScheme.brightness == Brightness.light
          ? ButtonColors.values[playerIndex].lightTheme
          : ButtonColors.values[playerIndex].darkTheme,
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final themeData = Theme.of(context);
            return TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween<double>(begin: 0, end: 1),
              curve: Curves.easeInOutCubicEmphasized,
              child: Scaffold(
                body: Stack(
                  children: [
                    if (isLargeScreen(constraints)) ...[
                      Align(
                        alignment: constraints.biggest.aspectRatio > 1
                            ? Alignment.centerLeft
                            : Alignment.topCenter,
                        child: SizedBox.square(
                          dimension: (constraints.biggest.longestSide -
                                  _playboardSize(constraints)) /
                              2,
                          child: Center(
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: _textPadding(constraints),
                              ),
                              child: Text(
                                '${playerIndex + 1}',
                                style: themeData.textTheme.headline1!.copyWith(
                                  fontSize: (constraints.biggest.longestSide -
                                          _playboardSize(constraints)) /
                                      4,
                                  color: themeData.colorScheme.surface,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (AppInfos.screenType == ScreenTypes.mouse ||
                          AppInfos.screenType ==
                              ScreenTypes.touchscreenAndMouse)
                        Align(
                          alignment: constraints.biggest.aspectRatio > 1
                              ? Alignment.centerRight
                              : Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SkillKeyboard(
                              controller.playerControl(playerIndex),
                              index: playerIndex,
                              playerCount: playerCount,
                              size: (constraints.biggest.longestSide -
                                      _playboardSize(constraints) -
                                      32) /
                                  8,
                            ),
                          ),
                        ),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: HookConsumer(builder: (context, ref, _) {
                        final affectedActions = ref.watch(
                          playboardControllerProvider.select(
                            (value) => (value as MultiplePlayboardState)
                                .currentAction(playerIndex),
                          ),
                        );
                        bool isPause =
                            affectedActions.contains(SlidepartyActions.pause);
                        final openMenu = useState(false);

                        return Stack(
                          children: [
                            Center(
                              child: PlayboardView(
                                boardSize: boardSize,
                                size: _playboardSize(constraints),
                                playerIndex: playerIndex,
                                holeWidget: isLargeScreen(constraints)
                                    ? null
                                    : _holeMenu(themeData, openMenu),
                                onPressed: (number) =>
                                    controller.move(playerIndex, number),
                                clipBehavior: Clip.none,
                              ),
                            ),
                            if (openMenu.value == true &&
                                !isLargeScreen(constraints))
                              Center(
                                child: ColoredBox(
                                  color: themeData.scaffoldBackgroundColor
                                      .withOpacity(0.3),
                                  child: SizedBox(
                                    width: _playboardSize(constraints) + 32,
                                    height: _playboardSize(constraints) + 32,
                                    child: Column(
                                      children: [
                                        Text(
                                          'Skill',
                                          style: themeData.textTheme.headline6,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            if (isPause)
                              Center(
                                child: ColoredBox(
                                  color: themeData.scaffoldBackgroundColor
                                      .withOpacity(0.3),
                                  child: SizedBox(
                                    width: _playboardSize(constraints) + 32,
                                    height: _playboardSize(constraints) + 32,
                                    child: Center(
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color:
                                              themeData.scaffoldBackgroundColor,
                                          shape: BoxShape.circle,
                                          boxShadow: const [BoxShadow()],
                                        ),
                                        child: SizedBox(
                                          height: 64,
                                          width: 64,
                                          child: Center(
                                            child: LineIcon.pauseCircleAlt(
                                                size: 32),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      }),
                    ),
                  ],
                ),
              ),
              builder: (context, value, child) => Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: constraints.biggest.height * value,
                      width: constraints.biggest.width * value,
                      child: child,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );

    if (AppInfos.screenType == ScreenTypes.touchscreen ||
        AppInfos.screenType == ScreenTypes.touchscreenAndMouse) {
      return SwipeDetector(
        onSwipeLeft: () =>
            controller.moveByGesture(playerIndex, PlayboardDirection.left),
        onSwipeRight: () =>
            controller.moveByGesture(playerIndex, PlayboardDirection.right),
        onSwipeUp: () =>
            controller.moveByGesture(playerIndex, PlayboardDirection.up),
        onSwipeDown: () =>
            controller.moveByGesture(playerIndex, PlayboardDirection.down),
        child: view,
      );
    }
    return view;
  }

  Widget _holeMenu(ThemeData themeData, ValueNotifier<bool> openMenu) {
    return Center(
      child: LayoutBuilder(
        builder: (context, cs) => InkWell(
          borderRadius: BorderRadius.circular(100),
          onTap: () => openMenu.value = !openMenu.value,
          child: Container(
            height: cs.maxHeight / 2,
            width: cs.maxHeight / 2,
            decoration: BoxDecoration(
              color: themeData.colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'P.${playerIndex + 1}',
                style: themeData.textTheme.bodyText2!.copyWith(
                  fontSize: cs.maxHeight / 10,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
