import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/multiple_mode/screens/multiple_playground.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_snack_bar.dart';

class OnlinePlayboardPage extends ConsumerWidget {
  const OnlinePlayboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      playboardControllerProvider
          .select((value) => (value as OnlinePlayboardState).serverState),
    );
    final controller =
        ref.watch(playboardControllerProvider.notifier) as OnlineModeController;
    ref.listen(
      isDisconnectWebSocketProvider,
      (previous, next) {
        showSlidepartyToast(
          context,
          'Your connection is lost. Please reconnect.',
          250,
        );
        context.go('/');
      },
    );

    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: Scaffold(
        body: state.map(
          wrongBoardSize: (value) => Center(
            child: Text(
              'Wrong board size',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          roomData: (data) => const MultiplePlayground(),
          waiting: (_) => const Center(child: CircularProgressIndicator()),
          roomFull: (_) => const Center(child: Text('Room is full')),
          connected: (_) {
            return HookBuilder(
              builder: (context) {
                useEffect(() {
                  controller.initController();
                  return null;
                });

                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        ),
      ),
    );
  }
}
