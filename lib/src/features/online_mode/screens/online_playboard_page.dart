import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/online_mode/screens/online_endgame.dart';
import 'package:slideparty/src/features/online_mode/screens/online_playground.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_snack_bar.dart';
import 'package:slideparty_socket/slideparty_socket.dart';

class OnlinePlayboardPage extends ConsumerWidget {
  const OnlinePlayboardPage({
    Key? key,
    required this.info,
  }) : super(key: key);

  final RoomInfo info;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      playboardControllerProvider
          .select((value) => (value as OnlinePlayboardState).serverState),
    );
    final playerId = ref.watch(
      playboardControllerProvider
          .select((value) => (value as OnlinePlayboardState).playerId),
    );
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    ref.listen(
      isDisconnectWebSocketProvider,
      (previous, next) {
        showSlidepartyToast(
          context,
          'Your connection is lost. Please reconnect.',
          300,
        );
        context.go('/');
      },
    );

    debugPrint(state.runtimeType.toString());

    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: Scaffold(
        body: state.map(
            endGame: (value) => OnlineEndgame(
                  value,
                  playerId: playerId,
                  info: info,
                ),
            wrongBoardSize: (value) {
              controller.disconnect();
              return Center(
                child: Text(
                  'Wrong board size',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              );
            },
            roomData: (data) {
              if (state is! RoomData) return const SizedBox();
              return const OnlinePlayground();
            },
            waiting: (_) => const Center(child: CircularProgressIndicator()),
            roomFull: (_) {
              controller.disconnect();
              return const Center(child: Text('Room is full'));
            },
            connected: (_) {
              controller.initController();
              return const Center(child: CircularProgressIndicator());
            },
            restarting: (_) {
              controller.restartGame();
              return const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Restarting...'),
                    Gap(16),
                    CircularProgressIndicator(),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
