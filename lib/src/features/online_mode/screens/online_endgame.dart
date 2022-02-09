import 'package:flutter/material.dart';
import 'package:slideparty/src/utils/app_infos/refresh_web_page.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

class OnlineEndgame extends StatelessWidget {
  const OnlineEndgame(
    this.value, {
    Key? key,
    required this.info,
  }) : super(key: key);

  final EndGame value;
  final RoomInfo info;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Winner is: ${value.winnerPlayerId}'),
        ElevatedButton(
          onPressed: () => refreshWindow(
              context, 'o_mode/${info.boardSize}/${info.roomCode}'),
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}
