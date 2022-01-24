import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
    return Scaffold(
      body: Center(
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
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Enter room code',
                ),
              ),
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
              Row(
                children: [
                  Expanded(
                    child: SlidepartyButton(
                      color: playboardDefaultColor,
                      customSize: const Size(double.maxFinite, 49),
                      onPressed: () {},
                      child: const Text('Create room'),
                      style: SlidepartyButtonStyle.invert,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) => SlidepartyButton(
                        color: playboardDefaultColor,
                        customSize: const Size(double.maxFinite, 49),
                        onPressed: () {
                          showSlidepartyToast(
                            context,
                            'Wrong input',
                            constraints.maxWidth,
                          );
                        },
                        child: const Text('Join room'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
