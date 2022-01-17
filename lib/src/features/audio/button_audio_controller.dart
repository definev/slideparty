import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:slideparty/src/features/audio/general_audio_controller.dart';

final buttonAudioControllerProvider =
    Provider((ref) => ButtonAudioController(ref.read));

class ButtonAudioController {
  ButtonAudioController(this._read);

  final Reader _read;
  final _player = AudioPlayer();

  void clickSound() async {
    if (_read(generalAudioControllerProvider).isMuted) return;
    try {
      await _player.setAsset('assets/sounds/click1.wav');
      _player.play();
    } catch (_) {}
  }
}
