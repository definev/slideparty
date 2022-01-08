import 'dart:developer';

import 'package:slideparty/src/utils/breakpoint.dart';

import 'loc.dart';

enum PlayboardDirection { up, down, left, right }

class Playboard {
  Playboard({
    required this.size,
    required this.currentBoard,
  }) {
    _solvedBoard = List.generate(size * size, (index) => index);
  }

  static const bp = Breakpoint(small: 300, normal: 400, large: 500);

  static bool isSolvable(int size, List<int> board) {
    final inversion = board.inversion;
    if (size.isOdd) {
      return inversion.isEven;
    } else {
      final holeLoc = Loc.fromIndex(size, board.indexOf(size * size - 1));
      if (inversion.isOdd) {
        return holeLoc.isEvenFarFromBottom(size);
      } else {
        return !holeLoc.isEvenFarFromBottom(size);
      }
    }
  }

  factory Playboard.random(int size) {
    List<int> currentBoard = List.generate(size * size, (index) => index)
      ..shuffle();
    while (!isSolvable(size, currentBoard)) {
      currentBoard.shuffle();
    }

    return Playboard(size: size, currentBoard: currentBoard);
  }

  late final List<int> _solvedBoard;
  final int size;
  final List<int> currentBoard;

  int get hole => size * size - 1;

  void logPlayboard() {
    StringBuffer buffer = StringBuffer();
    log('CURRENT STATE');
    for (int i = 0; i < currentBoard.length; i++) {
      String char = currentBoard[i] == hole ? 'X' : '${currentBoard[i] + 1}';
      buffer.write('${i % size == 0 ? '\n' : ''}$char ');
    }
    log(buffer.toString());
    log('EXPECT STATE');
    for (int i = 0; i < _solvedBoard.length; i++) {
      String char = _solvedBoard[i] == hole ? 'X' : '${_solvedBoard[i] + 1}';
      buffer.write('${i % size == 0 ? '\n' : ''}$char ');
    }
  }

  Loc currentLoc(int number) {
    final index = currentBoard.indexOf(number);
    return Loc.fromIndex(size, index);
  }

  Playboard? move(int number) {
    Loc holeLoc = currentLoc(hole);
    Loc numberLoc = currentLoc(number);

    if (numberLoc.relate(holeLoc)) {
      return swap(holeLoc, numberLoc);
    }
  }

  Playboard swap(Loc holeLoc, Loc numberLoc) {
    List<int> newBoard = [...currentBoard];
    final holePos = holeLoc.index(size);
    final numberPos = numberLoc.index(size);
    final temp = newBoard[holePos];
    newBoard[holePos] = newBoard[numberPos];
    newBoard[numberPos] = temp;

    return Playboard(size: size, currentBoard: newBoard);
  }

  Playboard? moveHole(PlayboardDirection direction) {
    final holeLoc = currentLoc(hole);
    switch (direction) {
      case PlayboardDirection.up:
        final numberLoc = holeLoc.down(size);
        if (numberLoc != null) return swap(holeLoc, numberLoc);
        break;
      case PlayboardDirection.down:
        final numberLoc = holeLoc.up(size);
        if (numberLoc != null) return swap(holeLoc, numberLoc);
        break;
      case PlayboardDirection.left:
        final numberLoc = holeLoc.right(size);
        if (numberLoc != null) return swap(holeLoc, numberLoc);
        break;
      case PlayboardDirection.right:
        final numberLoc = holeLoc.left(size);
        if (numberLoc != null) return swap(holeLoc, numberLoc);
        break;
    }
  }

  bool get isWin {
    for (int i = 0; i < _solvedBoard.length; i++) {
      if (currentBoard[i] != _solvedBoard[i]) {
        return false;
      }
    }
    return true;
  }
}

extension _SolvingPuzzleExt on List<int> {
  int get inversion {
    int first = this[0];
    int res = skip(0).fold(
      0,
      (inversion, second) {
        bool larger = first > second;
        first = second;
        if (larger) {
          return inversion + 1;
        }
        return inversion;
      },
    );
    return res;
  }
}
