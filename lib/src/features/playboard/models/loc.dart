import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Loc extends Equatable {
  final int dx;
  final int dy;

  const Loc(this.dx, this.dy);

  factory Loc.fromIndex(int size, int index) =>
      Loc(index % size, index ~/ size);

  Size get toSize => Size(dx.toDouble(), dy.toDouble());

  bool isEvenFarFromBottom(int size) => (size - dy).isEven;

  int index(int size) => dy * size + dx;

  Loc? up(int size) {
    if (dy > 0 && dy < size) return Loc(dx, dy - 1);
  }

  Loc? down(int size) {
    if (dy < size - 1) return Loc(dx, dy + 1);
  }

  Loc? left(int size) {
    if (dx > 0 && dx < size) return Loc(dx - 1, dy);
  }

  Loc? right(int size) {
    if (dx < size - 1) return Loc(dx + 1, dy);
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
