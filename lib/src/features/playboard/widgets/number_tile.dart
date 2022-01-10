import 'package:flutter/material.dart';

import 'package:slideparty/src/features/playboard/models/playboard.dart';
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
  double get _rSpacing => Playboard.bp.responsiveValue(
        Size(widget.playboardSize, widget.playboardSize),
        watch: 4.0,
        mobile: 6.0,
        defaultValue: 8.0,
      );
  double get _tileSize =>
      widget.playboardSize / widget.boardSize - _rSpacing * 2;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(widget.index),
      child: SizedBox(
        height: _tileSize + _rSpacing * 2,
        width: _tileSize + _rSpacing * 2,
        child: Padding(
          padding: EdgeInsets.all(_rSpacing),
          child: SlidepartyButton(
            color: widget.color,
            size: ButtonSize.square,
            scale: _tileSize / 49,
            onPressed: () => widget.onPressed(widget.index),
            fontSize: Playboard.bp.responsiveValue(
              Size(widget.playboardSize, widget.playboardSize),
              watch: 14,
              mobile: 18,
              tablet: 24,
              desktop: 32,
              defaultValue: 18,
            ),
            child: Text('${widget.index + 1}'),
          ),
        ),
      ),
    );
  }
}
