import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

final buttonAudioControllerProvider =
    Provider((ref) => ButtonAudioController());

class ButtonAudioController {
  final _player = AudioPlayer();

  void clickSound() async {
    await _player.setAsset('assets/sounds/click1.wav');
    _player.play();
  }
}
