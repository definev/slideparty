import 'package:slideparty_socket/slideparty_socket_fe.dart';

typedef SendCallback = Future<void> Function(ClientEvent event);

class MockSlidepartySocket implements SlidepartySocket {
  MockSlidepartySocket({
    required this.info,
    required this.userId,
    required SendCallback send,
    required Stream<ServerState> state,
  })  : _send = send,
        _serverStateStream = state;

  @override
  late final RoomInfo info;

  @override
  final String userId;
  final SendCallback _send;
  final Stream<ServerState> _serverStateStream;

  @override
  Future<void> close() async {}

  @override
  Future<void> send(ClientEvent event) => _send(event);

  @override
  Stream<ServerState> get state => _serverStateStream;
}
