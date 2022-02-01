import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:line_icons/line_icon.dart';
import 'package:slideparty/src/features/playboard/models/playboard_keyboard_control.dart';

class KeyboardGuide extends StatelessWidget {
  const KeyboardGuide(this.keyboardControl, {Key? key, required this.size})
      : super(key: key);

  final PlayboardKeyboardControl keyboardControl;
  final double size;

  Widget _buildKey(BuildContext context, LogicalKeyboardKey key) {
    switch (key.keyLabel) {
      case 'Arrow Up':
        return Card(
            margin: const EdgeInsets.all(2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Center(child: LineIcon.arrowUp(size: size < 30 ? 8 : 15)));
      case 'Arrow Down':
        return Card(
            margin: const EdgeInsets.all(2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Center(child: LineIcon.arrowDown(size: size < 30 ? 8 : 15)));
      case 'Arrow Left':
        return Card(
            margin: const EdgeInsets.all(2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child: Center(child: LineIcon.arrowLeft(size: size < 30 ? 8 : 15)));
      case 'Arrow Right':
        return Card(
            margin: const EdgeInsets.all(2),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            child:
                Center(child: LineIcon.arrowRight(size: size < 30 ? 8 : 15)));
      default:
        return Card(
            child: Center(
          child: Text(key.keyLabel,
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontSize: size < 30 ? 8 : 15)),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size * 2,
      width: size * 3,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: List.generate(
                3,
                (index) => Expanded(
                  child: index == 1
                      ? _buildKey(context, keyboardControl.up)
                      : const SizedBox(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildKey(context, keyboardControl.left),
                ),
                Expanded(
                  child: _buildKey(context, keyboardControl.down),
                ),
                Expanded(
                  child: _buildKey(context, keyboardControl.right),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
