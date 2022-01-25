import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_dialog.dart';
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
              TextField(
                decoration: const InputDecoration(labelText: 'Enter room code'),
                onChanged: (value) => roomCode.value = value,
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
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => HookBuilder(builder: (context) {
                            final roomCode = useMemoized(
                              () => (List.generate(6, (index) => index)
                                    ..shuffle())
                                  .join(),
                            );

                            return Center(
                              child: SizedBox(
                                height: 250,
                                child: SlidepartyDialog(
                                  title: 'New room',
                                  content: SizedBox(
                                    height: 400,
                                    child: Material(
                                      color: Colors.transparent,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text.rich(
                                            TextSpan(
                                              text: 'Your room code is: ',
                                              children: [
                                                TextSpan(
                                                  text: roomCode,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => Clipboard.setData(
                                              ClipboardData(
                                                  text:
                                                      'https://slideparty.vercel.app/#/o_mode/${isSelected.value.indexOf(true) + 3}/$roomCode'),
                                            ),
                                            icon: LineIcon.copyAlt(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    SlidepartyButton(
                                      color: playboardDefaultColor,
                                      size: ButtonSize.square,
                                      style: SlidepartyButtonStyle.invert,
                                      child: LineIcon.arrowCircleLeft(),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                    const SizedBox(width: 10),
                                    SlidepartyButton(
                                      color: playboardDefaultColor,
                                      child: const Text('Start game'),
                                      onPressed: () {
                                        context.go(
                                          '/o_mode/${isSelected.value.indexOf(true) + 3}/$roomCode',
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        );
                      },
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
                              constraints.maxWidth * 2 + 16,
                            );
                          } else {
                            context.go(
                                '/o_mode/${isSelected.value.indexOf(true) + 3}/${roomCode.value}');
                          }
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
