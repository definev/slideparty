import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final backgroundAudioControllerProvider =
    StateNotifierProvider<BackgroundAudioController, bool>(
        (ref) => BackgroundAudioController());

class BackgroundAudioController extends StateNotifier<bool> {
  BackgroundAudioController() : super(false);
  final _player = AudioPlayer();

  Future<void> _play() async {
    try {
      await _player.setAsset('assets/sounds/background.wav');
      _player.play();
      _player.setLoopMode(LoopMode.one);
      state = true;
    } catch (e) {
      return _play();
    }
  }

  void play() async {
    await _play();
  }

  void stop() {
    state = false;
    _player.stop();
  }
}
