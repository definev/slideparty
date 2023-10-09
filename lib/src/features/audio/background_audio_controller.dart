import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slideparty/src/features/audio/general_audio_controller.dart';

final backgroundAudioControllerProvider =
    StateNotifierProvider<BackgroundAudioController, bool>(
        (ref) => BackgroundAudioController(ref));

class BackgroundAudioController extends StateNotifier<bool> {
  BackgroundAudioController(this.ref) : super(false);

  final Ref ref;
  final _player = AudioPlayer();

  void playWinSound() async {
    if (ref.read(generalAudioControllerProvider).isMuted) return;

    try {
      await _player.setAsset('assets/sounds/win.mp3');
      _player.play();
    } catch (_) {}
  }

  void stop() => _player.stop();
}
