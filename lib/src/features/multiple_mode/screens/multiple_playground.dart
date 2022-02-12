import 'dart:math';

import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:dartx/dartx.dart';

import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/multiple_mode/widgets/win_dialog.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/models/playboard_config.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/playboard/widgets/playboard_view.dart';
import 'package:slideparty/src/features/playboard/widgets/skill_keyboard.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class MultiplePlayground extends HookConsumerWidget {
  const MultiplePlayground({Key? key}) : super(key: key);

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

  void _showWinningDialog(
    BuildContext context,
    String whoWin,
    StateNotifier<PlayboardState> controller,
  ) {
    if (controller is MultipleModeController) {
      showDialog(
        context: context,
        builder: (context) => MultipleModeWinDialog(
          whoWin: whoWin,
          controller: controller,
        ),
        barrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(playboardControllerProvider.notifier);
    final playerCount = ref.watch(
      playboardControllerProvider.select((value) {
        if (value is MultiplePlayboardState) {
          return value.playerCount;
        }
        if (value is OnlinePlayboardState) {
          return value.multiplePlayboardState?.playerCount ?? 0;
        }
      }),
    )!;
    ref.listen<String?>(
      playboardControllerProvider.select(
        (value) {
          if (value is MultiplePlayboardState) {
            return value.whoWin;
          }
          if (value is OnlinePlayboardState) {
            return value.multiplePlayboardState?.whoWin;
          }
          return null;
        },
      ),
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
              if (controller is MultipleModeController) {
                controller.moveByKeyboard(event.logicalKey);
              }
              if (controller is OnlineModeController) {
                controller.moveByKeyboard(event.logicalKey);
              }
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
      min(constraints.biggest.shortestSide - 32, 425);

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
          if (value is OnlinePlayboardState) {
            if (value.serverState is! RoomData) {
              return (index).toString();
            }
            return (value.serverState as RoomData)
                .players
                .keys
                .elementAt(index);
          }
          return index.toString();
        },
      ),
    );
    final playerCount = ref.watch(playboardControllerProvider.select(
      (value) {
        if (value is MultiplePlayboardState) {
          return value.playerCount;
        }
        if (value is OnlinePlayboardState) {
          if (value.multiplePlayboardState == null) return 0;
          return value.multiplePlayboardState!.playerCount;
        }
      },
    ))!;
    final controller = ref.watch(playboardControllerProvider.notifier);
    final keyboard = useMemoized(() {
      if (controller is MultipleModeController) {
        return controller.playerControl(playerId);
      }
      if (controller is OnlineModeController) {
        return controller.defaultControl;
      }
      return null;
    }, [controller]);
    final isMyPlayerId = () {
      if (controller is MultipleModeController) {
        return true;
      }
      if (controller is OnlineModeController) {
        return controller.isMyPlayerId(playerId);
      }
      return false;
    }();
    final color = useMemoized(() {
      if (controller is MultipleModeController) {
        return ButtonColors.values[index];
      }
      if (controller is OnlineModeController) {
        return controller.getColor(playerId);
      }
    }, [controller])!;

    final view = Theme(
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
                                  controller is OnlineModeController &&
                                          isMyPlayerId
                                      ? 'YOU'
                                      : 'P.' + playerId,
                                  style:
                                      themeData.textTheme.headline1!.copyWith(
                                    fontSize: (constraints.biggest.longestSide -
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
                                child: Consumer(builder: (context, ref, _) {
                                  final otherPlayersIds = ref.watch(
                                    playboardControllerProvider.select(
                                      (state) {
                                        if (state is MultiplePlayboardState) {
                                          return state.getPlayerIds(playerId);
                                        }
                                      },
                                    ),
                                  );
                                  final otherPlayersColors = ref.watch(
                                    playboardControllerProvider.select(
                                      (state) {
                                        if (state is OnlinePlayboardState) {
                                          if (state.multiplePlayboardState ==
                                              null) return null;
                                          return state.multiplePlayboardState!
                                              .getPlayerColors(playerId);
                                        }
                                      },
                                    ),
                                  );
                                  return SkillKeyboard(
                                    keyboard!,
                                    playerId: playerId,
                                    playerCount: playerCount,
                                    size: min(
                                        60,
                                        min(
                                          (constraints.biggest.longestSide -
                                                  _playboardSize(constraints) -
                                                  32) /
                                              8,
                                          constraints.biggest.shortestSide / 6,
                                        )),
                                    otherPlayersColors: otherPlayersColors,
                                    otherPlayersIds: otherPlayersIds,
                                  );
                                }),
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
    );

    if (AppInfos.screenType == ScreenTypes.touchscreen ||
        AppInfos.screenType == ScreenTypes.touchscreenAndMouse) {
      return SwipeDetector(
        onSwipeLeft: () {
          if (controller is MultipleModeController) {
            controller.moveByGesture(playerId, PlayboardDirection.left);
          }
          if (controller is OnlineModeController) {
            controller.moveByGesture(PlayboardDirection.left);
          }
        },
        onSwipeRight: () {
          if (controller is MultipleModeController) {
            controller.moveByGesture(playerId, PlayboardDirection.right);
          }
          if (controller is OnlineModeController) {
            controller.moveByGesture(PlayboardDirection.right);
          }
        },
        onSwipeUp: () {
          if (controller is MultipleModeController) {
            controller.moveByGesture(playerId, PlayboardDirection.up);
          }
          if (controller is OnlineModeController) {
            controller.moveByGesture(PlayboardDirection.up);
          }
        },
        onSwipeDown: () {
          if (controller is MultipleModeController) {
            controller.moveByGesture(playerId, PlayboardDirection.down);
          }
          if (controller is OnlineModeController) {
            controller.moveByGesture(PlayboardDirection.down);
          }
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
                style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
    final controller = ref.watch(playboardControllerProvider.notifier);
    final boardSize = ref.watch(
      playboardControllerProvider.select(
        (value) {
          if (value is MultiplePlayboardState) {
            return value.boardSize;
          }
          if (value is OnlinePlayboardState) {
            if (value.multiplePlayboardState == null) return 2;
            return value.multiplePlayboardState!.boardSize;
          }
        },
      ),
    )!;
    final affectedActions = ref.watch<List<SlidepartyActions>?>(
      playboardControllerProvider.select(
        (value) {
          if (value is MultiplePlayboardState) {
            return value.currentAction(playerId);
          }
          if (value is OnlinePlayboardState) {
            if (value.affectedAction?[playerId] == null) return [];
            return value.affectedAction![playerId]!.values.flatten().toList();
          }
          return null;
        },
      ),
    )!;
    final isMyPlayerId = () {
      if (controller is MultipleModeController) {
        return true;
      }
      if (controller is OnlineModeController) {
        return controller.isMyPlayerId(playerId);
      }
      return false;
    }();
    bool isPause = affectedActions.contains(SlidepartyActions.pause);

    return Stack(
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
                    isOnlineMode: controller is OnlineModeController,
                  )
                : null,
            onPressed: (number) {
              if (controller is MultipleModeController) {
                return controller.move(playerId, number);
              }
              if (isMyPlayerId == false) return;
              if (controller is OnlineModeController) {
                return controller.move(number);
              }
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
              final otherPlayersIds = ref.watch(
                playboardControllerProvider.select(
                  (state) {
                    if (state is MultiplePlayboardState) {
                      return state.getPlayerIds(playerId);
                    }
                  },
                ),
              );
              final otherPlayersColors = ref.watch(
                playboardControllerProvider.select(
                  (state) {
                    if (state is OnlinePlayboardState) {
                      if (state.multiplePlayboardState == null) return null;
                      return state.multiplePlayboardState!
                          .getPlayerColors(playerId);
                    }
                  },
                ),
              );
              final color =
                  ref.watch(playboardControllerProvider.select((state) {
                if (state is OnlinePlayboardState) {
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
                }
                return ButtonColors.values[int.parse(playerId)];
              }));

              return Center(
                child: IgnorePointer(
                  ignoring: !show,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeInOutCubic,
                    opacity: show ? 1 : 0,
                    child: SmallSkillMenu(
                      size: size + 32,
                      playerId: playerId,
                      color: color,
                      otherPlayersIds: otherPlayersIds,
                      otherPlayerColors: otherPlayersColors,
                    ),
                  ),
                ),
              );
            },
          ),
      ],
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
                child: SizedBox(
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

class SmallSkillMenu extends HookConsumerWidget {
  const SmallSkillMenu({
    Key? key,
    required this.size,
    required this.playerId,
    required this.otherPlayersIds,
    required this.color,
    this.otherPlayerColors,
  }) : super(key: key);

  final double size;
  final String playerId;
  final ButtonColors color;
  final List<String>? otherPlayersIds;
  final List<ButtonColors>? otherPlayerColors;

  Widget _actionIcon(
    BuildContext context,
    SlidepartyActions actions,
  ) {
    switch (actions) {
      case SlidepartyActions.blind:
        return LineIcon.lowVision();
      case SlidepartyActions.pause:
        return LineIcon.userSlash();
      case SlidepartyActions.clear:
        return LineIcon.userShield();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeData = Theme.of(context);
    final controller = ref.watch(playboardControllerProvider.notifier);
    final openSkill = ref.watch(multipleSkillStateProvider(playerId));
    final openSkillNotifier =
        ref.watch(multipleSkillStateProvider(playerId).notifier);
    final pickedPlayer = useState<String?>(null);
    final pickedColor = useState<ButtonColors?>(null);

    return GestureDetector(
      onTap: () {
        openSkillNotifier.state =
            openSkill.copyWith(show: false, queuedAction: null);
        pickedPlayer.value = null;
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
                  if (otherPlayersIds != null)
                    for (final otherPlayerIndex in otherPlayersIds!)
                      AnimatedScale(
                        duration: const Duration(milliseconds: 200),
                        scale: pickedPlayer.value == otherPlayerIndex ? 1.1 : 1,
                        child: SlidepartyButton(
                          key: ValueKey(
                              'Owner $playerId - Target $otherPlayerIndex'),
                          color: color,
                          onPressed: () =>
                              pickedPlayer.value = otherPlayerIndex,
                          size: ButtonSize.square,
                          style: pickedPlayer.value == otherPlayerIndex ||
                                  pickedPlayer.value == null
                              ? SlidepartyButtonStyle.normal
                              : SlidepartyButtonStyle.invert,
                          child: Text('P.$otherPlayerIndex'),
                        ),
                      ),
                  if (otherPlayerColors != null)
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
                        (pickedColor.value != null ||
                            pickedPlayer.value != null))
                    ? SlidepartyButtonStyle.normal
                    : SlidepartyButtonStyle.invert,
                customSize: const Size(49 * 3 + 16, 49),
                onPressed: () {
                  if (controller is MultipleModeController) {
                    controller.doAction(playerId, pickedPlayer.value!);
                  }
                  if (controller is OnlineModeController) {
                    controller.doAction(pickedColor.value!);
                  }
                  pickedPlayer.value = null;
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
