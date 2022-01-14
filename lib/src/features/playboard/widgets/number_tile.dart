import 'package:flutter/material.dart';

import 'package:slideparty/src/widgets/widgets.dart';

class NumberTile extends StatefulWidget {
  const NumberTile({
    Key? key,
    required this.index,
    required this.color,
    required this.playboardSize,
    required this.boardSize,
    required this.onPressed,
  }) : super(key: key);

  final int index;
  final ButtonColors color;
  final double playboardSize;
  final int boardSize;
  final Function(int index) onPressed;

  @override
  State<NumberTile> createState() => _NumberTileState();
}

class _NumberTileState extends State<NumberTile> {
  double get _rSpacing => 2.5 * _tileSize / 49;
  double get _tileSize => widget.playboardSize / widget.boardSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(widget.index),
      child: SizedBox(
        height: _tileSize,
        width: _tileSize,
        child: Padding(
          padding: EdgeInsets.all(_rSpacing),
          child: SlidepartyButton(
            color: widget.color,
            size: ButtonSize.square,
            scale: _tileSize / 49,
            onPressed: () => widget.onPressed(widget.index),
            child: Text('${widget.index + 1}'),
          ),
        ),
      ),
    );
  }
}
