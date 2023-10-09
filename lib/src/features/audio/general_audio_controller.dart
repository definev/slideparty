import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/audio/repositories/audio_local.dart';

final generalAudioControllerProvider =
    ChangeNotifierProvider<GeneralAudioController>((ref) {
  return GeneralAudioController(ref);
});

class GeneralAudioController extends ChangeNotifier {
  final Ref ref;

  GeneralAudioController(this.ref) {
    _isMuted = ref.read(audioLocalProvider).isMuted;
  }

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  set isMuted(bool value) {
    ref.read(audioLocalProvider).isMuted = value;
    _isMuted = value;
    notifyListeners();
  }
}
