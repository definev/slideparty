import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:dartx/dartx.dart';

import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_menu.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class OnlinePlayground extends HookConsumerWidget {
  const OnlinePlayground({Key? key}) : super(key: key);

  int axisLength(int playerCount) =>
      playerCount ~/ 2 + (playerCount % 2 == 1 ? 1 : 0);

  int _flexSpace(int index, double ratio, playerCount) {
    if (ratio <= 1.3) return 1;
    if (index == axisLength(playerCount) - 1 && playerCount % 2 == 1) {
      return 1;
    } else {
      return 2;
    }
  }

  Axis _getDirectionOfParent(int index, {required bool preferVertical}) =>
      preferVertical ? Axis.horizontal : Axis.vertical;

  Axis _getDirectionOfChild(
    int index, {
    required BoxConstraints constraints,
    required bool preferVertical,
    required int playerCount,
  }) {
    if (preferVertical) {
      if (constraints.biggest.shortestSide > 600) {
        final ratio = constraints.maxHeight / constraints.maxWidth;
        if (ratio > 1.3) {
          return Axis.vertical;
        } else {
          return Axis.horizontal;
        }
      }
      if (constraints.biggest.height / playerCount <
          constraints.biggest.width / 2) {
        return Axis.horizontal;
      }
      return Axis.vertical;
    } else {
      if (constraints.maxHeight > 600) {
        final ratio = constraints.maxWidth / constraints.maxHeight;
        if (ratio > 1.3) {
          return Axis.horizontal;
        } else {
          return Axis.vertical;
        }
      }
      if (constraints.biggest.width / playerCount <
          constraints.biggest.height / 2) {
        return Axis.vertical;
      }
      return Axis.horizontal;
    }
  }

  Widget _multiplePlayerView(
    BuildContext context, {
    required bool preferVertical,
    required BoxConstraints constraints,
    required int playerCount,
  }) {
    final ratio =
        constraints.biggest.longestSide / constraints.biggest.shortestSide;
    return Flex(
      direction: preferVertical ? Axis.vertical : Axis.horizontal,
      children: List.generate(
          axisLength(playerCount),
          (index) => Flexible(
                flex: _flexSpace(index, ratio, playerCount),
                child: Flex(
                  direction: _getDirectionOfParent(
                    index,
                    preferVertical: preferVertical,
                  ),
                  children: [
                    Expanded(
                      child: Flex(
                        direction: _getDirectionOfChild(
                          index,
                          constraints: constraints,
                          preferVertical: preferVertical,
                          playerCount: playerCount,
                        ),
                        children: List.generate(
                          playerCount % 2 == 1 &&
                                  index == axisLength(playerCount) - 1
                              ? 1
                              : 2,
                          (colorIndex) => Expanded(
                            child: _PlayerPlayboardView(
                              index: index * 2 + colorIndex,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    final playerCount = ref.watch(
      playboardControllerProvider.select((value) =>
          (value as OnlinePlayboardState).multiplePlayboardState?.playerCount ??
          0),
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
              constraints: constraints,
              playerCount: playerCount,
            ),
          ),
        ),
      ),
    );
  }
}

class _PlayerPlayboardView extends HookConsumerWidget {
  const _PlayerPlayboardView({
    Key? key,
    required this.index,
    required this.ratio,
  }) : super(key: key);

  final int index;
  final double ratio;

  double _playboardSize(BoxConstraints constraints) =>
      min(constraints.biggest.shortestSide - 32, 375);

  double _textPadding(BoxConstraints constraints) =>
      3 * (constraints.biggest.longestSide - _playboardSize(constraints)) / 64;

  bool _isLargeScreen(BoxConstraints constraints) =>
      ratio > 1.3 && constraints.biggest.longestSide > 750;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final playerId = ref.watch(
      playboardControllerProvider.select(
        (value) {
          value as OnlinePlayboardState;
          if (value.serverState is! RoomData) {
            return (index).toString();
          }
          return (value.serverState as RoomData).players.keys.elementAt(index);
        },
      ),
    );
    final playerCount = ref.watch(playboardControllerProvider.select(
      (value) {
        value as OnlinePlayboardState;
        if (value.multiplePlayboardState == null) return 0;
        return value.multiplePlayboardState!.playerCount;
      },
    ));
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    final keyboard = controller.defaultControl;
    final isMyPlayerId =
        useMemoized(() => controller.isMyPlayerId(playerId), [playerId]);
    final color = useMemoized(() => controller.getColor(playerId), [playerId]);

    final view = RepaintBoundary(
      child: Theme(
        data: themeData.colorScheme.brightness == Brightness.light
            ? color.lightTheme
            : color.darkTheme,
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
                      if (_isLargeScreen(constraints)) ...[
                        if (isMyPlayerId)
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
                                    isMyPlayerId ? 'YOU' : 'P.$playerId',
                                    style:
                                        themeData.textTheme.displayLarge!.copyWith(
                                      fontSize:
                                          (constraints.biggest.longestSide -
                                                  _playboardSize(constraints)) /
                                              6,
                                      color: themeData.colorScheme.surface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if ((AppInfos.screenType == ScreenTypes.mouse ||
                                AppInfos.screenType ==
                                    ScreenTypes.touchscreenAndMouse) &&
                            isMyPlayerId)
                          Align(
                            alignment: constraints.biggest.aspectRatio > 1
                                ? Alignment.centerRight
                                : Alignment.bottomCenter,
                            child: SizedBox.square(
                              dimension: (constraints.biggest.longestSide -
                                      _playboardSize(constraints)) /
                                  2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final otherPlayersColors = ref.watch(
                                        playboardControllerProvider.select(
                                          (state) {
                                            if (state is OnlinePlayboardState) {
                                              if (state
                                                      .multiplePlayboardState ==
                                                  null) return null;
                                              return state
                                                  .multiplePlayboardState!
                                                  .getPlayerColors(playerId);
                                            }
                                          },
                                        ),
                                      );
                                      return SkillKeyboard(
                                        keyboard,
                                        playerId: playerId,
                                        playerCount: playerCount,
                                        size: min(
                                            60,
                                            min(
                                              (constraints.biggest.longestSide -
                                                      _playboardSize(
                                                          constraints) -
                                                      32) /
                                                  8,
                                              constraints.biggest.shortestSide /
                                                  6,
                                            )),
                                        otherPlayersColors: otherPlayersColors,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                      _MultipleMainPlayground(
                        playerId: playerId,
                        size: _playboardSize(constraints),
                        isLargeScreen: _isLargeScreen(constraints),
                      ),
                    ],
                  ),
                ),
                builder: (context, value, child) => SizedBox(
                  height: constraints.biggest.height * value,
                  width: constraints.biggest.width * value,
                  child: child,
                ),
              );
            },
          ),
        ),
      ),
    );

    if (AppInfos.screenType == ScreenTypes.touchscreen ||
        AppInfos.screenType == ScreenTypes.touchscreenAndMouse) {
      return SwipeDetector(
        onSwipeLeft: () {
          controller.moveByGesture(PlayboardDirection.left);
        },
        onSwipeRight: () {
          controller.moveByGesture(PlayboardDirection.right);
        },
        onSwipeUp: () {
          controller.moveByGesture(PlayboardDirection.up);
        },
        onSwipeDown: () {
          controller.moveByGesture(PlayboardDirection.down);
        },
        child: view,
      );
    }
    return view;
  }
}

class HoleMenu extends StatelessWidget {
  const HoleMenu({
    Key? key,
    required this.isOnlineMode,
    required this.playerId,
  }) : super(key: key);

  final bool isOnlineMode;
  final String playerId;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, cs) => Consumer(
          builder: (context, ref, child) {
            final skillStateNotifier =
                ref.watch(multipleSkillStateProvider(playerId).notifier);
            return InkWell(
              onTap: () => skillStateNotifier.state = skillStateNotifier.state
                  .copyWith(show: !skillStateNotifier.state.show),
              borderRadius: BorderRadius.circular(100),
              child: child,
            );
          },
          child: Container(
            height: cs.maxHeight / 2,
            width: cs.maxHeight / 2,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                isOnlineMode ? 'You' : 'P.$playerId',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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

class _MultipleMainPlayground extends HookConsumerWidget {
  const _MultipleMainPlayground({
    Key? key,
    required this.playerId,
    required this.size,
    required this.isLargeScreen,
  }) : super(key: key);

  final String playerId;
  final double size;
  final bool isLargeScreen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    final boardSize = ref.watch(
      playboardControllerProvider.select(
        (value) {
          value as OnlinePlayboardState;
          if (value.multiplePlayboardState == null) return 2;
          return value.multiplePlayboardState!.boardSize;
        },
      ),
    );
    final affectedActions = ref.watch<List<SlidepartyActions>?>(
      playboardControllerProvider.select(
        (value) {
          value as OnlinePlayboardState;
          if (value.affectedAction?[playerId] == null) return [];
          return value.affectedAction![playerId]!.values.flatten().toList();
        },
      ),
    )!;
    final isMyPlayerId = useMemoized(() {
      return controller.isMyPlayerId(playerId);
    }, [playerId]);
    bool isPause = affectedActions.contains(SlidepartyActions.pause);

    return RepaintBoundary(
      child: Stack(
        children: [
          Center(
            child: PlayboardView(
              boardSize: boardSize,
              size: size,
              playerId: playerId,
              holeWidget: (!isLargeScreen ||
                          AppInfos.screenType == ScreenTypes.touchscreen) &&
                      isMyPlayerId
                  ? HoleMenu(
                      key: ValueKey('HoleMenu: $playerId'),
                      playerId: playerId,
                      isOnlineMode: true,
                    )
                  : null,
              onPressed: (number) {
                if (isMyPlayerId == false) return;
                return controller.move(number);
              },
              clipBehavior: Clip.none,
            ),
          ),
          if (isPause) PauseAction(themeData: themeData, size: size),
          if (!isLargeScreen)
            Consumer(
              builder: (context, ref, child) {
                final show = ref.watch(
                  multipleSkillStateProvider(playerId).select(
                    (value) => value.show,
                  ),
                );
                final otherPlayersColors = ref.watch(
                  playboardControllerProvider.select(
                    (state) {
                      state as OnlinePlayboardState;
                      if (state.multiplePlayboardState == null) return null;
                      return state.multiplePlayboardState!
                          .getPlayerColors(playerId);
                    },
                  ),
                );
                final color =
                    ref.watch(playboardControllerProvider.select((state) {
                  state as OnlinePlayboardState;
                  if (state.multiplePlayboardState == null) {
                    return ButtonColors.blue;
                  }
                  return (state.multiplePlayboardState!.config
                          as MultiplePlayboardConfig)
                      .configs[playerId]!
                      .mapOrNull(
                        blind: (value) => value.color,
                        number: (value) => value.color,
                      )!;
                }));

                if (otherPlayersColors == null) return const SizedBox();

                return Center(
                  child: IgnorePointer(
                    ignoring: !show,
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.easeInOutCubic,
                      opacity: show ? 1 : 0,
                      child: SkillMenu(
                        size: size + 32,
                        playerId: playerId,
                        color: color,
                        otherPlayerColors: otherPlayersColors,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class PauseAction extends StatelessWidget {
  const PauseAction({
    Key? key,
    required this.themeData,
    required this.size,
  }) : super(key: key);

  final ThemeData themeData;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IgnorePointer(
        child: ColoredBox(
          color: themeData.scaffoldBackgroundColor.withOpacity(0.3),
          child: SizedBox(
            width: size + 32,
            height: size + 32,
            child: Center(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: themeData.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                  boxShadow: const [BoxShadow()],
                ),
                child: const SizedBox(
                  height: 64,
                  width: 64,
                  child: Center(
                    child: LineIcon.pauseCircleAlt(size: 32),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
