import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';

class OnlinePlayboardPage extends ConsumerWidget {
  const OnlinePlayboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(
      playboardControllerProvider
          .select((value) => value as OnlinePlayboardState),
    );

    return WillPopScope(
      onWillPop: () async {
        context.go('/');
        return false;
      },
      child: Scaffold(
        body: Center(child: Text(state.toString())),
      ),
    );
  }
}
