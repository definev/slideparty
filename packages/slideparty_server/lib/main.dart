import 'package:mongo_dart/mongo_dart.dart';
import 'package:shelf/shelf_io.dart' as sio;
import 'package:shelf_router/shelf_router.dart';
import 'package:slideparty_server/src/db.dart';
import 'package:slideparty_server/src/slideparty_socket_handler.dart';

void main(List<String> args) async {
  final port = args[0];
  final mongoUrl = args[1];

  mongo = await Db.create(mongoUrl);
  await mongo.open();
  print('MongoDB connected');

  final router = Router() //
    ..get('/ws/<roomCode>',
        (request, roomCode) => slidepartySocketHandler(roomCode)(request));

  sio
      .serve(router, 'localhost', int.parse(port)) //
      .then((server) =>
          print('Server is serving at ${server.address.host}:${server.port}'));
}
