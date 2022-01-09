import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/audio/background_audio_controller.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class HomePage extends ConsumerWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioController =
        ref.watch(backgroundAudioControllerProvider.notifier);
    final initSound = ref.watch(backgroundAudioControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: Text.rich(
                TextSpan(
                  text: 'Slide',
                  children: [
                    TextSpan(
                      text: 'party',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                    ),
                  ],
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
            Column(
              children: [
                SlidepartyButton(
                  color: ButtonColor.blue,
                  onPressed: () => context.go('/s_mode'),
                  child: const Text('Single Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColor.green,
                  onPressed: () => context.go('/m_mode'),
                  child: const Text('Multiple Mode'),
                ),
                const SizedBox(height: 8),
                SlidepartyButton(
                  color: ButtonColor.yellow,
                  onPressed: () => context.go('/o_mode'),
                  child: const Text('Online Mode'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SlidepartyButton(
                    color: ButtonColor.red,
                    size: ButtonSize.square,
                    onPressed: () => initSound
                        ? audioController.stop()
                        : audioController.play(),
                    child: initSound
                        ? const Icon(Icons.music_off)
                        : const Icon(Icons.music_note),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
