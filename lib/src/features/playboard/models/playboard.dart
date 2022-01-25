// ignore_for_file: unused_element, unused_local_variable

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:slideparty/src/utils/breakpoint.dart';
import 'package:sprintf/sprintf.dart';

import 'loc.dart';

enum PlayboardDirection { up, down, left, right }

extension PlayboardDirectionExtension on PlayboardDirection {
  PlayboardDirection get opposite => {
        PlayboardDirection.up: PlayboardDirection.down,
        PlayboardDirection.down: PlayboardDirection.up,
        PlayboardDirection.left: PlayboardDirection.right,
        PlayboardDirection.right: PlayboardDirection.left,
      }[this]!;
}

class Playboard {
  Playboard({
    required this.size,
    required this.currentBoard,
  }) {
    solvedBoard = List.generate(size * size, (index) => index);
  }

  factory Playboard.random(int size) {
    List<int> currentBoard = List.generate(size * size, (index) => index)
      ..shuffle();
    while (!isSolvable(size, currentBoard)) {
      currentBoard.shuffle();
    }

    return Playboard(size: size, currentBoard: currentBoard);
  }

  @visibleForTesting
  factory Playboard.fromMatrix(List<List<int>> matrix) {
    return Playboard(
      size: matrix.length,
      currentBoard: matrix.expand((row) => row).toList(),
    );
  }

  static const bp = Breakpoint(small: 300, normal: 400, large: 500);

  late final List<int> solvedBoard;
  final int size;
  final List<int> currentBoard;

  Playboard clone() =>
      Playboard(size: size, currentBoard: List.from(currentBoard));

  int get hole => size * size - 1;

  int get cost {
    int cost = 0;
    for (int i = 0; i < currentBoard.length; i++) {
      if (currentBoard[i] != solvedBoard[i]) {
        cost++;
      }
    }
    return cost;
  }

  static bool isSolvable(int size, List<int> board) {
    final inversion = board.inversion;
    if (size.isOdd) {
      return inversion.isEven;
    } else {
      final holeLoc = Loc.fromIndex(size, board.indexOf(board.hole));
      if (inversion.isOdd) {
        return holeLoc.isInEvenRow(size);
      } else {
        return !holeLoc.isInEvenRow(size);
      }
    }
  }

  @override
  String toString() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < size; i++) {
      sb.writeln(List.generate(size * 4 + 1, (index) => '-').join());
      sb.writeln(List.generate(size, (index) {
            if (currentBoard[i * size + index] == size - 1) {
              return '| X ';
            }
            return sprintf('|%3d', [currentBoard[i * size + index]]);
          }).join() +
          '|');
    }
    sb.writeln(List.generate(size * 4 + 1, (index) => '-').join());

    return sb.toString();
  }

  void logPlayboard() => currentBoard.printBoard();

  Loc currentLoc(int number) {
    final index = currentBoard.indexOf(number);
    return Loc.fromIndex(size, index);
  }

  bool get canSolve {
    switch (size) {
      case 3:
        return true;
      case 4:
        return cost < 4;
      case 5:
        return cost < 4;
      default:
        return false;
    }
  }

  bool get isSolved {
    for (int i = 0; i < solvedBoard.length; i++) {
      if (currentBoard[i] != solvedBoard[i]) {
        return false;
      }
    }
    return true;
  }

  // Auto solve the puzzle with A* algorithm
  List<PlayboardDirection>? autoSolve([List<int>? finalBoard]) {
    if (!canSolve) return null;
    if (!isSolvable(size, currentBoard)) return null;

    final _playboardNode =
        SolvingMachine.bestStepSolution(PlayboardSolverParams(
      currentBoard,
      finalBoard ?? solvedBoard,
      currentLoc(hole),
    ));

    if (_playboardNode == null) return null;
    return _playboardNode.directions;
  }

  Playboard? move(int number) {
    Loc holeLoc = currentLoc(hole);
    Loc numberLoc = currentLoc(number);

    var newBoard = clone();

    if (holeLoc.dx == numberLoc.dx) {
      final dyDistance = holeLoc.dy - numberLoc.dy;
      if (dyDistance < 0) {
        for (int i = 0; i < dyDistance.abs(); i++) {
          newBoard = newBoard.moveHole(PlayboardDirection.up)!;
        }
      } else {
        for (int i = 0; i < dyDistance; i++) {
          newBoard = newBoard.moveHole(PlayboardDirection.down)!;
        }
      }
    }

    if (holeLoc.dy == numberLoc.dy) {
      final dxDistance = holeLoc.dx - numberLoc.dx;
      if (dxDistance < 0) {
        for (int i = 0; i < dxDistance.abs(); i++) {
          newBoard = newBoard.moveHole(PlayboardDirection.left)!;
        }
      } else {
        for (int i = 0; i < dxDistance; i++) {
          newBoard = newBoard.moveHole(PlayboardDirection.right)!;
        }
      }
    }

    return newBoard;
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

  Playboard? moveHoleExact(PlayboardDirection direction) {
    final holeLoc = currentLoc(hole);
    final numberLoc = holeLoc.move(size, direction);
    if (numberLoc != null) return swap(holeLoc, numberLoc);
  }
}

class PlayboardSolverParams {
  const PlayboardSolverParams(this.currentBoard, this.finalBoard, this.holeLoc);

  final List<int> currentBoard;
  final List<int> finalBoard;
  final Loc holeLoc;
}

@visibleForTesting
class SolvingMachine {
  @visibleForTesting
  static _PlayboardNode? bestStepSolution(PlayboardSolverParams params) {
    PriorityQueue<_PlayboardNode> queue = PriorityQueue<_PlayboardNode>();
    _PlayboardNode root = _PlayboardNode(
      holeLoc: params.holeLoc,
      board: params.currentBoard,
      finalBoard: params.finalBoard,
      depth: 0,
    );
    queue.add(root);

    while (queue.isNotEmpty) {
      _PlayboardNode node = queue.first;
      queue.removeFirst();
      if (node.cost == 0) return node;

      for (int i = 0; i < 4; i++) {
        final direction = PlayboardDirection.values[i];
        switch (node.direction) {
          case PlayboardDirection.up:
            if (direction == PlayboardDirection.down) continue;
            break;
          case PlayboardDirection.down:
            if (direction == PlayboardDirection.up) continue;
            break;
          case PlayboardDirection.left:
            if (direction == PlayboardDirection.right) continue;
            break;
          case PlayboardDirection.right:
            if (direction == PlayboardDirection.left) continue;
            break;
          default:
            break;
        }
        final newNode = node.move(direction);
        if (newNode != null) queue.add(newNode);
      }
    }

    return null;
  }

  // Quick solve solution
  static List<int> needToSolvePos(int size) => List.generate(
        size * 2 - 1,
        (index) => index >= size ? (index - size + 1) * size : index,
      );

  static List<PlayboardDirection> _getHoleToRightNumberLocPath({
    required int size,
    required Loc holeLoc,
    required Loc rightNumberLoc,
    required List<int> currentBoard,
  }) {
    var directions = <PlayboardDirection>[];
    if (holeLoc == rightNumberLoc) return directions;
    final dxDistance = holeLoc.dx - rightNumberLoc.dx;
    final dyDistance = holeLoc.dy - rightNumberLoc.dy;
    if (dxDistance < 0) {
      holeLoc = holeLoc.move(size, PlayboardDirection.right)!;
      directions.add(PlayboardDirection.right);
    } else if (dxDistance > 0) {
      holeLoc = holeLoc.move(size, PlayboardDirection.left)!;
      directions.add(PlayboardDirection.left);
    }
    if (dyDistance < 0) {
      holeLoc = holeLoc.move(size, PlayboardDirection.down)!;
      directions.add(PlayboardDirection.down);
    } else if (dyDistance > 0) {
      holeLoc = holeLoc.move(size, PlayboardDirection.up)!;
      directions.add(PlayboardDirection.up);
    }
    return directions;
  }

  /// From the hole loc to number loc
  /// The the `dxDistance` and `dyDistance` is the distance between the hole and the number
  /// - `dxDistance` must be zero or positive
  /// - `dyDistance` must be zero or positive
  ///
  /// CASE 0: `dxDistance` is zero and `dyDistance` is zero (So it's already in the right position)
  ///
  /// CASE 1: `dxDistance` and `dyDistance` are both positive
  /// Loc(0, 0)
  ///  |
  /// -------------
  /// |X |2 |3 |4 |
  /// -------------
  /// |5 |6 |7 |8 |
  /// -------------
  /// |9 |10|11|1 | -----> Loc(2, 3)
  /// -------------
  /// |13|14|15|12|
  /// -------------
  ///
  /// CASE 2: `dxDistance` is positive and `dyDistance` is zero
  /// Loc(0, 0)
  ///  |
  ///  |    Loc(0, 2)
  ///  |     |
  ///  |     |
  /// -------------
  /// |X |2 |1 |4 |
  /// -------------
  /// |5 |6 |7 |8 |
  /// -------------
  /// |9 |10|11|3 |
  /// -------------
  /// |13|14|15|12|
  /// -------------
  ///
  /// CASE 3: `dxDistance` is zero and `dyDistance` is positive
  ///
  ///             -------------
  /// Loc(0, 0)-> |X |2 |3 |4 |
  ///             -------------
  ///             |5 |6 |7 |8 |
  ///             -------------
  /// Loc(2, 0)-> |1 |10|11|9 |
  ///             -------------
  ///             |13|14|15|12|
  ///             -------------
  ///
  static List<PlayboardDirection> _numberToRightNumberLocPositiveCase({
    required int dyDistance,
    required int dxDistance,
  }) {
    assert(dxDistance >= 0);
    assert(dyDistance >= 0);
    List<PlayboardDirection> directions = [];
    // [Case 0]
    if (dxDistance == 0 && dyDistance == 0) return <PlayboardDirection>[];
    // [Case 1]
    if (dxDistance > 0 && dyDistance > 0) {
      var loop = dxDistance + dyDistance - 1;
      while (loop > 0) {
        loop--;
        directions.addAll([
          ...List.generate(dyDistance, (index) => PlayboardDirection.down),
          ...List.generate(dxDistance, (index) => PlayboardDirection.right),
          ...List.generate(dyDistance, (index) => PlayboardDirection.up),
          ...List.generate(dxDistance, (index) => PlayboardDirection.left),
        ]);
      }
      directions.add(PlayboardDirection.down);
    }
    // [Case 2]
    if (dxDistance > 0 && dyDistance == 0) {
      var loop = dxDistance - 1;
      while (loop > 0) {
        loop--;
        directions.addAll([
          ...List.generate(dxDistance, (index) => PlayboardDirection.left),
          PlayboardDirection.down,
          ...List.generate(dxDistance, (index) => PlayboardDirection.right),
          PlayboardDirection.up,
        ]);
      }
      directions.add(PlayboardDirection.left);
    }

    // [Case 3]
    if (dxDistance == 0 && dyDistance > 0) {
      var loop = dyDistance - 1;
      while (loop > 0) {
        loop--;
        directions.addAll([
          ...List.generate(dyDistance, (index) => PlayboardDirection.down),
          PlayboardDirection.right,
          ...List.generate(dyDistance, (index) => PlayboardDirection.up),
          PlayboardDirection.left,
        ]);
      }
      directions.add(PlayboardDirection.down);
    }
    return directions;
  }

  ///
  static List<PlayboardDirection> _numberToRightNumberLocNegativeCase({
    required int dyDistance,
    required int dxDistance,
    required List<int> currentBoard,
  }) {
    var directions = <PlayboardDirection>[];
    return directions;
  }

  static List<PlayboardDirection> _numberToRightNumberLoc({
    required int size,
    required Loc numberLoc,
    required Loc rightNumberLoc,
    required List<int> currentBoard,
  }) {
    if (rightNumberLoc.relate(numberLoc)) {
      if (rightNumberLoc.dx - numberLoc.dx == 0) {
        if (rightNumberLoc.dy - numberLoc.dy == 0) return [];
        return [
          rightNumberLoc.dy > numberLoc.dy
              ? PlayboardDirection.down
              : PlayboardDirection.up
        ];
      }
      return [
        rightNumberLoc.dx > numberLoc.dx
            ? PlayboardDirection.right
            : PlayboardDirection.left
      ];
    }

    final dxDistance = numberLoc.dx - rightNumberLoc.dx;
    final dyDistance = numberLoc.dy - rightNumberLoc.dy;

    final directions = <PlayboardDirection>[];

    if (dxDistance >= 0 && dyDistance >= 0) {
      directions.addAll(
        _numberToRightNumberLocPositiveCase(
          dxDistance: dxDistance,
          dyDistance: dyDistance,
        ),
      );
    } else {
      directions.addAll(_numberToRightNumberLocNegativeCase(
        dyDistance: dyDistance,
        dxDistance: dxDistance,
        currentBoard: currentBoard,
      ));
    }
    return directions;
  }

  @visibleForTesting
  static List<PlayboardDirection> quickSolveSolution(
    PlayboardSolverParams params,
  ) {
    var directions = <PlayboardDirection>[];
    var currentBoard = params.currentBoard;
    final size = params.currentBoard.size;
    final _needToSolvePos = needToSolvePos(size);

    for (int index = 0; index < size - 1; index++) {
      final rightNumberLoc = Loc.fromIndex(size, index);
      final holeLoc = currentBoard.holeLoc;
      final holePath = _getHoleToRightNumberLocPath(
        size: size,
        holeLoc: holeLoc,
        rightNumberLoc: rightNumberLoc,
        currentBoard: currentBoard,
      );
      currentBoard = currentBoard.moveDirections(holePath);
      final currentNumberLoc = currentBoard.loc(index);
      final numberPath = _numberToRightNumberLoc(
        size: size,
        numberLoc: currentNumberLoc,
        rightNumberLoc: rightNumberLoc,
        currentBoard: currentBoard,
      );

      directions.addAll([...holePath, ...numberPath]);
    }
    return directions;
  }
}

extension SolvingPuzzleExt on List<int> {
  int get size => sqrt(length).floor();

  bool get isSolved => sum == (length + 1) * length / 2;

  int get hole => length - 1;

  Loc get holeLoc {
    final index = indexOf(hole);
    return Loc.fromIndex(size, index);
  }

  Loc loc(int number) {
    if (number >= length) throw Exception('Number $number is out of range');
    final index = indexOf(number);
    return Loc.fromIndex(size, index);
  }

  int get inversion {
    final board = [...this]..remove(hole);
    int res = 0;

    for (int i = 0; i < board.length; i++) {
      for (int j = i + 1; j < board.length; j++) {
        if (board[i] > board[j]) {
          res++;
        }
      }
    }

    return res;
  }

  void swap(Loc holeLoc, Loc numberLoc) {
    final holeIndex = holeLoc.index(size);
    final numberIndex = numberLoc.index(size);
    final temp = this[holeIndex];
    this[holeIndex] = this[numberIndex];
    this[numberIndex] = temp;
  }

  void printBoard() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      String char = this[i] == hole ? 'X' : '${this[i] + 1}';
      buffer.write('${i % size == 0 ? '\n' : ''}$char ');
    }

    debugPrint(buffer.toString());
  }

  List<int>? move(int number) {
    if (number >= length) throw Exception('Number $number is out of range');
    final numberLoc = loc(number);
    if (numberLoc.relate(holeLoc)) {
      swap(holeLoc, numberLoc);
      return this;
    }
  }

  List<int>? moveDirection(PlayboardDirection direction) {
    final numberLoc = holeLoc.move(size, direction);
    if (numberLoc != null) {
      swap(holeLoc, numberLoc);
      return this;
    }
  }

  List<int> moveDirections(List<PlayboardDirection> directions) {
    List<int> newList = List.from(this);

    for (final direction in directions) {
      final newHoleLoc = holeLoc.move(size, direction);

      if (newHoleLoc == null) throw Exception('Cannot move direction');

      final temp = newList[hole];
      final newHoleIndex = newHoleLoc.index(size);
      newList[hole] = newHoleIndex;
      newList[newHoleIndex] = temp;
    }

    return newList;
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
    final newBoard = [...board]..swap(holeLoc, newHoleLoc);
    return _PlayboardNode(
      parent: this,
      holeLoc: newHoleLoc,
      direction: direction,
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

  List<PlayboardDirection> get directions {
    final List<PlayboardDirection> locs = [];
    _PlayboardNode? node = this;
    while (node != null) {
      if (node.parent != null) locs.add(node.direction!);
      node = node.parent;
    }
    return locs.reversed.toList();
  }

  @override
  String toString() => 'Playboard { cost = $cost, depth = $depth }';

  @override
  int compareTo(_PlayboardNode other) =>
      (cost + depth) - (other.cost + other.depth);
}
