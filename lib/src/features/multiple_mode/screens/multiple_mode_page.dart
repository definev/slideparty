import 'dart:math';

import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_snack_bar.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class MultipleModePage extends ConsumerWidget {
  const MultipleModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerCount = ref.watch(
      playboardControllerProvider.select((value) {
        return (value as MultiplePlayboardState).playerCount;
      }),
    );

    switch (playerCount) {
      case 0:
        return const _NoPlayerPage();
      default:
        return _MultiplePlayerPage(playerCount: playerCount);
    }
  }
}

class _NoPlayerPage extends HookConsumerWidget {
  const _NoPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final color = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));
    final controller = ref.watch(playboardControllerProvider.notifier)
        as MultipleModeController;
    final playerChosen = useState([false, false, false]);
    final boardChosen = useState([false, false, false]);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 425),
            child: LayoutBuilder(builder: (context, constraints) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Multiple Mode',
                    style: themeData.textTheme.headline5!.copyWith(
                      color: color.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Number of players',
                      style: themeData.textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SeparatedRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    separatorBuilder: () => const SizedBox(height: 10),
                    children: List.generate(
                      playerChosen.value.length,
                      (index) => SlidepartyButton(
                        color: color,
                        onPressed: () => playerChosen.value = List.generate(
                          playerChosen.value.length,
                          (i) => i == index,
                        ),
                        child: Text('${index + 2}'),
                        style: playerChosen.value[index]
                            ? SlidepartyButtonStyle.normal
                            : SlidepartyButtonStyle.invert,
                        customSize: Size((constraints.maxWidth - 20) / 3, 49),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Board size',
                      style: themeData.textTheme.subtitle1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SeparatedRow(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    separatorBuilder: () => const SizedBox(height: 10),
                    children: List.generate(
                      boardChosen.value.length,
                      (index) => SlidepartyButton(
                        color: color,
                        onPressed: () => boardChosen.value = List.generate(
                          playerChosen.value.length,
                          (i) => i == index,
                        ),
                        child: Text('${index + 3} x ${index + 3}'),
                        style: boardChosen.value[index]
                            ? SlidepartyButtonStyle.normal
                            : SlidepartyButtonStyle.invert,
                        customSize: Size((constraints.maxWidth - 20) / 3, 49),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlidepartyButton(
                    color: color,
                    onPressed: () {
                      final playerCount = playerChosen.value.indexOf(true);
                      final boardSize = boardChosen.value.indexOf(true);
                      if (playerCount != -1 && boardSize != -1) {
                        controller.startGame(playerCount + 2, boardSize + 3);
                      } else {
                        showSlidepartyToast(
                          context,
                          'Fill all the fields',
                          constraints.maxWidth,
                        );
                      }
                    },
                    child: const Text('Start'),
                    customSize: Size(constraints.maxWidth, 49),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _MultiplePlayerPage extends HookConsumerWidget {
  const _MultiplePlayerPage({
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

  void _showWinningDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playboardControllerProvider.notifier)
        as MultipleModeController;
    ref.listen<int?>(
      playboardControllerProvider
          .select((value) => (value as MultiplePlayboardState).whoWin),
      (_, who) {
        if (who != null) {
          _showWinningDialog(context);
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
