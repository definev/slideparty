import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_snack_bar.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class OnlineModePage extends HookConsumerWidget {
  const OnlineModePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playboardDefaultColor = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));

    final isSelected = useState([true, false, false]);
    final roomCode = useState('');

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 425),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'ONLINE MODE',
                    style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                HookBuilder(builder: (context) {
                  final controller = useTextEditingController();

                  return TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Enter room code',
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.text = (List.generate(6, (index) => index)
                                ..shuffle())
                              .join();
                          roomCode.value = controller.text;
                        },
                        icon: LineIcon.autoprefixer(),
                      ),
                    ),
                    onChanged: (value) => roomCode.value = value,
                  );
                }),
                const SizedBox.square(dimension: 16),
                Row(
                  children: [
                    const Expanded(child: Text('Board size')),
                    const SizedBox.square(dimension: 8),
                    ToggleButtons(
                      children: List.generate(
                        3,
                        (index) => Center(
                          child: Text('${index + 3}'),
                        ),
                      ),
                      onPressed: (index) {
                        isSelected.value = List.generate(3, (i) => i == index);
                      },
                      isSelected: isSelected.value,
                    ),
                  ],
                ),
                const SizedBox.square(dimension: 16),
                LayoutBuilder(
                  builder: (context, constraints) => SlidepartyButton(
                    color: playboardDefaultColor,
                    customSize: const Size(double.maxFinite, 49),
                    onPressed: () {
                      String errorMessage = '';

                      if (roomCode.value.isEmpty) {
                        errorMessage = 'Room code must not empty';
                      } else if (!isSelected.value.contains(true)) {
                        errorMessage = 'Board size is not selected';
                      }

                      if (errorMessage != '') {
                        showSlidepartyToast(
                          context,
                          errorMessage,
                          constraints.maxWidth,
                        );
                      } else {
                        context.go(
                            '/o_mode/${isSelected.value.indexOf(true) + 3}/${roomCode.value}');
                      }
                    },
                    child: const Text('Join room'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
