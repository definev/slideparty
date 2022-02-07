import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/multiple_mode/screens/multiple_playground.dart';
import 'package:slideparty/src/features/multiple_mode/screens/multiple_setting.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';

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
        return const MultipleSetting();
      default:
        return const MultiplePlayground();
    }
  }
}
