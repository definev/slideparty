import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_snack_bar.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class MultipleSetting extends HookConsumerWidget {
  const MultipleSetting({Key? key}) : super(key: key);

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
            constraints: const BoxConstraints(maxWidth: 300),
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
