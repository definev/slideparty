import 'package:flutter/material.dart';

import 'package:slideparty/src/widgets/widgets.dart';

class NumberTile extends StatelessWidget {
  const NumberTile({
    Key? key,
    required this.index,
    required this.color,
    required this.playboardSize,
    required this.boardSize,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final int index;
  final ButtonColors color;
  final double playboardSize;
  final int boardSize;
  final Function(int index) onPressed;
  final Widget child;

  double get _rSpacing => 3 * _tileSize / 49;
  double get _tileSize => playboardSize / boardSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(index),
      child: SizedBox(
        height: _tileSize,
        width: _tileSize,
        child: Padding(
          padding: EdgeInsets.all(_rSpacing),
          child: SlidepartyButton(
            color: color,
            size: ButtonSize.square,
            scale: _tileSize / 49,
            onPressed: () => onPressed(index),
            child: child,
          ),
        ),
      ),
    );
  }
}
