import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slideparty/src/features/audio/general_audio_controller.dart';

final backgroundAudioControllerProvider =
    StateNotifierProvider<BackgroundAudioController, bool>(
        (ref) => BackgroundAudioController(ref.read));

class BackgroundAudioController extends StateNotifier<bool> {
  BackgroundAudioController(this._read) : super(false);

  final Reader _read;
  final _player = AudioPlayer();

  void playWinSound() async {
    if (_read(generalAudioControllerProvider).isMuted) return;

    try {
      await _player.setAsset('assets/sounds/win.mp3');
      _player.play();
    } catch (_) {}
  }

  void stop() => _player.stop();
}
