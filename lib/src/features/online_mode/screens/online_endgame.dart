import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/widgets.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

class OnlineEndgame extends ConsumerWidget {
  const OnlineEndgame(
    this.value, {
    Key? key,
    required this.playerId,
    required this.info,
  }) : super(key: key);

  final String playerId;
  final EndGame value;
  final RoomInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    final time = controller.time;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 190,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Winner',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Gap(16),
                SlidepartyButton(
                  size: ButtonSize.square,
                  color:
                      ButtonColors.values[value.winnerPlayerState.color.index],
                  onPressed: () {},
                  child: playerId == value.winnerPlayerState.id
                      ? const Text('You')
                      : Text(value.winnerPlayerState.color.name[0]),
                ),
              ],
            ),
          ),
          const Gap(16),
          Text(
              '${time.inHours % 24 <= 9 ? '0${time.inHours % 24}' : time.inHours % 24} : ${time.inMinutes % 60 <= 9 ? '0${time.inMinutes % 60}' : time.inMinutes % 60} : ${time.inSeconds % 60 <= 9 ? '0${time.inSeconds % 60}' : time.inSeconds % 60}'),
          const Gap(16),
          for (final stat in value.stats)
            if (stat.playerColor != value.winnerPlayerState.color)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: 250,
                  child: Row(
                    children: [
                      SlidepartyButton(
                        size: ButtonSize.square,
                        color: ButtonColors.values[stat.playerColor.index],
                        onPressed: () {},
                        child: value.winnerPlayerState.color == stat.playerColor
                            ? const Text('You')
                            : Text(stat.playerColor.name[0]),
                      ),
                      const Gap(16),
                      TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0.0, end: 1.0),
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceOut,
                        builder: (context, value, child) => Stack(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 50,
                                width: (250 - 16 - 49),
                                decoration: ShapeDecoration(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: ButtonColors
                                      .values[stat.playerColor.index]
                                      .primaryColor
                                      .withOpacity(0.3),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 50,
                                width: value *
                                    ((stat.totalTile - stat.remainTile) /
                                        stat.totalTile) *
                                    (250 - 16 - 49),
                                decoration: ShapeDecoration(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  color: ButtonColors
                                      .values[stat.playerColor.index]
                                      .primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          const Gap(16),
          SlidepartyButton(
            color: ButtonColors.values[value.stats.first.playerColor.index],
            onPressed: () => controller.restart(),
            child: const Text('Restart Game'),
          ),
        ],
      ),
    );
  }
}
