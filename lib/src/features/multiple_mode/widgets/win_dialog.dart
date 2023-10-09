import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/widgets/dialogs/slideparty_dialog.dart';
import 'package:slideparty/src/widgets/widgets.dart';

class MultipleModeWinDialog extends StatelessWidget {
  const MultipleModeWinDialog({
    Key? key,
    required this.whoWin,
    required this.controller,
  }) : super(key: key);

  final String whoWin;
  final MultipleModeController controller;

  @override
  Widget build(BuildContext context) {
    final whoWin = int.parse(this.whoWin);

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Theme(
          data: ButtonColors.values[whoWin].adaptiveTheme(context),
          child: SlidepartyDialog(
            height: 250,
            width: 313,
            title: 'Winner !!!',
            content: Text(
              'Player $whoWin solved the puzzle!',
              textAlign: TextAlign.center,
            ),
            actions: [
              SlidepartyButton(
                key: const Key('play-again-button'),
                color: ButtonColors.values[whoWin],
                size: ButtonSize.square,
                style: SlidepartyButtonStyle.invert,
                child: const LineIcon.syncIcon(),
                onPressed: () {
                  Navigator.pop(context);
                  controller.restart();
                },
              ),
              const SizedBox(width: 10),
              SlidepartyButton(
                color: ButtonColors.values[whoWin],
                child: const Text('Go Home'),
                onPressed: () {
                  context.go('/');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
