import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

/// [Loc] represents a coordinate in the puzzle map.
/// - **dx** is the horizontal distance from the left edge of the puzzle map.
/// - **dy** is the vertical distance from the top edge of the puzzle map.
class Loc extends Equatable {
  final int dx;
  final int dy;

  const Loc(this.dx, this.dy);

  factory Loc.fromIndex(int size, int index) =>
      Loc(index % size, index ~/ size);

  Size get toSize => Size(dx.toDouble(), dy.toDouble());

  bool isInEvenRow(int size) => (size - dy).isEven;

  int index(int size) => dy * size + dx;

  Loc? move(int size, PlayboardDirection? direction) {
    if (direction == null) return null;
    switch (direction) {
      case PlayboardDirection.up:
        return up(size);
      case PlayboardDirection.down:
        return down(size);
      case PlayboardDirection.left:
        return left(size);
      case PlayboardDirection.right:
        return right(size);
    }
  }

  Loc? up(int size) {
    if (dy > 0 && dy < size) return Loc(dx, dy - 1);
    return null;
  }

  Loc? down(int size) {
    if (dy < size - 1) return Loc(dx, dy + 1);
    return null;
  }

  Loc? left(int size) {
    if (dx > 0 && dx < size) return Loc(dx - 1, dy);
    return null;
  }

  Loc? right(int size) {
    if (dx < size - 1) return Loc(dx + 1, dy);
    return null;
  }

  bool relate(Loc other) {
    if ((other.dx - dx).abs() == 1 && other.dy == dy) {
      return true;
    }
    if ((other.dy - dy).abs() == 1 && other.dx == dx) {
      return true;
    }

    return false;
  }

  @override
  String toString() => 'Loc { dx = $dx | dy = $dy }';

  @override
  List<Object?> get props => [dx, dy];
}
