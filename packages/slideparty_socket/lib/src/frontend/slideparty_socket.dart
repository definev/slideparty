import 'dart:convert';

import 'package:slideparty_socket/src/common/player_event.dart';
import 'package:slideparty_socket/src/common/room_state.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class SlidepartySocket {
  SlidepartySocket(String url)
      : _channel = WebSocketChannel.connect(Uri.parse(url));

  final WebSocketChannel _channel;

  Future<void> send(PlayerEvent event) async {
    if (event is SendAction) {
      _channel.sink.add({
        'type': 'SendAction',
        'payload': {
          'affectedPlayerId': event.affectedPlayerId,
          'action': event.action,
        },
      });
    } else if (event is SendBoard) {
      _channel.sink.add({
        'type': 'SendBoard',
        'payload': jsonEncode(event.board),
      });
    } else if (event is SendName) {
      _channel.sink.add({
        'type': 'SendName',
        'payload': event.name,
      });
    }
  }

  Future<void> close() async => await _channel.sink.close();

  Stream<RoomState> get roomState {
    return _channel.stream.asyncMap((event) {
      if (event is Map) {
        switch (event['type']) {
          case 'RoomData':
            return RoomState.fromJson(event['payload']);
          default:
            return RoomStateLoading();
        }
      } else {
        return RoomStateLoading();
      }
    });
  }
}
