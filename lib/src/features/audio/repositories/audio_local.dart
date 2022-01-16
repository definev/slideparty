import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/cores/db.dart';

final audioLocalProvider = Provider<AudioLocal>((ref) => AudioLocalImpl());

abstract class AudioLocal extends DbCore {
  bool get isMuted;
  set isMuted(bool value);
}

class AudioLocalImpl extends AudioLocal {
  @override
  bool get isMuted => box.get('isMute', defaultValue: false);

  @override
  set isMuted(bool value) => box.put('isMute', value);
}
