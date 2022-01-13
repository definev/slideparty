import 'dart:math';

import 'package:collection/collection.dart';
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
    for (int i = 0; i < currentBoard.length; i++) {
      String char = currentBoard[i] == hole ? 'X' : '${currentBoard[i] + 1}';
      buffer.write('${i % size == 0 ? '\n' : ''}$char ');
    }
    for (int i = 0; i < _solvedBoard.length; i++) {
      String char = _solvedBoard[i] == hole ? 'X' : '${_solvedBoard[i] + 1}';
      buffer.write('${i % size == 0 ? '\n' : ''}$char ');
    }
  }

  Loc currentLoc(int number) {
    final index = currentBoard.indexOf(number);
    return Loc.fromIndex(size, index);
  }

  // Auto solve the puzzle with A* algorithm
  List<Loc>? autoSolve(List<int> finalBoard) {
    if (isSolvable(size, currentBoard)) return null;

    _PlayboardNode? _solve(
      List<int> currentBoard,
      List<int> finalBoard,
      Loc holeLoc,
    ) {
      PriorityQueue<_PlayboardNode> queue = PriorityQueue<_PlayboardNode>();
      _PlayboardNode root = _PlayboardNode(
        holeLoc: holeLoc,
        board: currentBoard,
        finalBoard: finalBoard,
        depth: 0,
      );
      queue.add(root);

      while (queue.isNotEmpty) {
        _PlayboardNode node = queue.first;
        queue.removeFirst();
        if (node.cost == 0) return node;

        for (int i = 0; i < 4; i++) {
          final direction = PlayboardDirection.values[i];
          final newNode = node.move(direction);
          if (newNode != null) queue.add(newNode);
        }
      }

      return null;
    }

    final _playboardNode = _solve(currentBoard, finalBoard, currentLoc(hole));

    if (_playboardNode == null) return null;
    return _playboardNode.locs;
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
  int get size => sqrt(length).floor();

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

  void swap(int size, Loc holeLoc, Loc numberLoc) {
    final holeIndex = holeLoc.index(size);
    final numberIndex = numberLoc.index(size);
    final temp = this[holeIndex];
    this[holeIndex] = this[numberIndex];
    this[numberIndex] = temp;
  }
}

class _PlayboardNode implements Comparable<_PlayboardNode> {
  final _PlayboardNode? parent;
  final Loc holeLoc;
  final PlayboardDirection? direction;
  final List<int> board;
  final List<int> finalBoard;
  late final int cost;
  final int depth;

  _PlayboardNode({
    this.parent,
    this.direction,
    required this.holeLoc,
    required this.board,
    required this.finalBoard,
    required this.depth,
  }) {
    cost = _calulateCost();
  }

  _PlayboardNode? move(PlayboardDirection direction) {
    final newHoleLoc = () {
      switch (direction) {
        case PlayboardDirection.down:
          return holeLoc.down(board.size);
        case PlayboardDirection.up:
          return holeLoc.up(board.size);
        case PlayboardDirection.left:
          return holeLoc.left(board.size);
        case PlayboardDirection.right:
          return holeLoc.right(board.size);
      }
    }();
    if (newHoleLoc == null) return null;
    final newBoard = [...board]..swap(
        board.size,
        holeLoc,
        newHoleLoc,
      );
    return _PlayboardNode(
      parent: parent,
      holeLoc: newHoleLoc,
      direction: PlayboardDirection.left,
      board: newBoard,
      finalBoard: finalBoard,
      depth: depth + 1,
    );
  }

  int _calulateCost() {
    int cost = 0;
    for (int i = 0; i < board.length; i++) {
      if (board[i] != finalBoard[i]) {
        cost++;
      }
    }
    return cost;
  }

  List<Loc> get locs {
    final List<Loc> locs = [];
    _PlayboardNode? node = this;
    while (node != null) {
      locs.add(node.holeLoc);
      node = node.parent;
    }
    return locs.reversed.toList();
  }

  @override
  int compareTo(_PlayboardNode other) => cost - other.cost;
}
