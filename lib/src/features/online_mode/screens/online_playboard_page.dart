import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/utils/display_party_types.dart';

import 'display_modes/online_playboard.dart';

class OnlinePlayboardPage extends ConsumerWidget {
  const OnlinePlayboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      playboardControllerProvider
          .select((value) => (value as OnlinePlayboardState).state),
    );
    final controller = ref.watch(playboardControllerProvider.notifier)
        as OnlinePlayboardController;

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
          roomData: (data) => LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.biggest.shortestSide < 450) {
                controller.changeDisplayMode(DisplayModes.bubbles);
              }

              return Consumer(
                builder: (context, ref, child) {
                  final displayMode = ref.watch(
                    playboardControllerProvider.select(
                        (value) => (value as OnlinePlayboardState).displayMode),
                  );
                  switch (displayMode) {
                    case DisplayModes.bubbles:
                      return const OnlineBubblesPlayboard();
                    case DisplayModes.grid:
                      return const OnlineGridPlayboard();
                    case DisplayModes.column:
                      return const OnlineColumnPlayboard();
                    case DisplayModes.row:
                      return const OnlineRowPlayboard();
                  }
                },
              );
            },
          ),
          waiting: (_) => const Center(child: CircularProgressIndicator()),
          roomFull: (_) => const Center(child: Text('Room is full')),
          connected: (_) {
            return HookBuilder(
              builder: (context) {
                useEffect(() {
                  controller.initController();
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
