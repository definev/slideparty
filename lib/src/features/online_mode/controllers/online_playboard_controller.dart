import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

final onlinePlayboardControlllerProvider = StateNotifierProvider.autoDispose
    .family<PlayboardController, PlayboardState, RoomInfo>((ref, info) {
  return OnlinePlayboardController(info);
});

class OnlinePlayboardController
    extends PlayboardController<OnlinePlayboardState> {
  OnlinePlayboardController(RoomInfo info)
      : _ssk = SlidepartySocket(info),
        super(
          OnlinePlayboardState(state: ServerState.waiting()),
        ) {
    _sub = _ssk.state.listen((event) {
      state = state.copyWith(state: event);
    });
  }

  final SlidepartySocket _ssk;
  late final StreamSubscription _sub;

  @override
  void dispose() {
    _sub.cancel();
    _ssk.close();
    super.dispose();
  }
}
