import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:slideparty_server/src/db.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

shelf.Handler slidepartySocketHandler(String roomCode) {
  return shelf.Pipeline() //
      .addMiddleware(shelf.logRequests())
      .addHandler(
    webSocketHandler(
      (websocket) {
        final ws = websocket as WebSocketChannel;
        final userId = Uuid().v4();
        final col = mongo.collection('rooms');
        ws.stream.listen(
          (message) async {
            print("Request: $roomCode");
            print(message);

            var room = await col.findOne(where.eq('code', roomCode));
            if (room == null) {
              print("Create Room");
              await col.insertOne(
                {
                  'code': roomCode,
                  'users': {
                    userId: {
                      'name': 'Guest 0',
                      'color': 'red',
                      'ready': false,
                    }
                  },
                },
              );
              room = await col.findOne(where.eq('code', roomCode));
            } else {
              print("Create Room");
              await col.replaceOne(
                where.eq('code', roomCode),
                {
                  'code': roomCode,
                  'users': {
                    ...room['users'],
                    userId: {
                      'name': 'Guest ${room['users'].length}',
                      'color': 'red',
                      'ready': false,
                    }
                  },
                },
              );
              room = await col.findOne(where.eq('code', roomCode));
            }

            ws.sink.add("Pong from server: Your roomCode: $roomCode");
          },
          onDone: () async {
            final room = await col.findOne(where.eq('code', roomCode));
            if (room?['users'].length == 1) {
              print("Remove Room");
              await col.deleteOne(where.eq('code', roomCode));
            } else {
              print("Out Room");
              await col.replaceOne(
                where.eq('code', roomCode),
                {
                  'code': roomCode,
                  'users': room?['users']..remove(userId),
                },
              );
            }

            print('Done: No more connections at $roomCode');
          },
          cancelOnError: true,
        );
      },
    ),
  );
}
