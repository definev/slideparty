// ignore_for_file: unused_element, unused_local_variable

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:slideparty/src/utils/breakpoint.dart';
import 'package:slideparty/src/utils/int_range.dart';
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
    return true;
    // switch (size) {
    //   case 3:
    //     return true;
    //   case 4:
    //     return cost < 4;
    //   case 5:
    //     return cost < 4;
    //   default:
    //     return false;
    // }
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

    if (size >= 4) {
      return SolvingMachine.quickSolveSolution(
        PlayboardSolverParams(
          currentBoard,
          finalBoard ?? solvedBoard,
          currentLoc(hole),
        ),
      );
    }

    final _playboardNode = SolvingMachine.bestStepSolution(
      PlayboardSolverParams(
        currentBoard,
        finalBoard ?? solvedBoard,
        currentLoc(hole),
      ),
    );

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

  static List<PlayboardDirection> _holeToRightNumberLoc({
    required Loc targetLoc,
    required List<int> currentBoard,
  }) {
    var directions = <PlayboardDirection>[];
    final holeLoc = currentBoard.holeLoc;
    if (holeLoc == targetLoc) return directions;
    final dxDistance = holeLoc.dx - targetLoc.dx;
    final dyDistance = holeLoc.dy - targetLoc.dy;
    if (dxDistance < 0) {
      directions.addAll(
        List.generate(dxDistance.abs(), (_) => PlayboardDirection.right),
      );
    } else {
      directions.addAll(
        List.generate(dxDistance, (_) => PlayboardDirection.left),
      );
    }
    if (dyDistance < 0) {
      directions.addAll(
        List.generate(dyDistance.abs(), (_) => PlayboardDirection.down),
      );
    } else {
      directions.addAll(
        List.generate(dyDistance, (_) => PlayboardDirection.up),
      );
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
  ///
  /// ```
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
  /// ```
  ///
  /// CASE 2: `dxDistance` is positive and `dyDistance` is zero
  /// ```
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
  /// ```
  ///
  /// CASE 3: `dxDistance` is zero and `dyDistance` is positive
  ///
  /// ```
  ///             -------------
  /// Loc(0, 0)-> |X |2 |3 |4 |
  ///             -------------
  ///             |5 |6 |7 |8 |
  ///             -------------
  /// Loc(2, 0)-> |1 |10|11|9 |
  ///             -------------
  ///             |13|14|15|12|
  ///             -------------
  /// ```
  static List<PlayboardDirection> _numberToRightNumberLocPositiveCase({
    required Loc numberLoc,
    required Loc rightNumberLoc,
  }) {
    int dxDistance = numberLoc.dx - rightNumberLoc.dx;
    int dyDistance = numberLoc.dy - rightNumberLoc.dy;

    bool isInvert = false;
    if (dxDistance <= 0 && dyDistance <= 0) {
      isInvert = true;
    }

    dxDistance = dxDistance.abs();
    dyDistance = dyDistance.abs();

    List<PlayboardDirection> directions = [];
    // [Case 0]
    if (dxDistance == 0 && dyDistance == 0) return <PlayboardDirection>[];
    // [Case 1]
    if (dxDistance > 0 && dyDistance > 0) {
      var loop = dxDistance + dyDistance - 1;
      while (loop > 0) {
        loop--;
        directions.addAll([
          ...List.generate(dyDistance, (_) => PlayboardDirection.down),
          ...List.generate(
              dxDistance,
              (_) => isInvert
                  ? PlayboardDirection.left
                  : PlayboardDirection.right),
          ...List.generate(dyDistance, (_) => PlayboardDirection.up),
          ...List.generate(
              dxDistance,
              (_) => isInvert
                  ? PlayboardDirection.right
                  : PlayboardDirection.left),
        ]);
      }
      directions.add(PlayboardDirection.down);
    }
    // [Case 2]
    if (dxDistance > 0 && dyDistance == 0) {
      for (final i in 0.till(dxDistance + 1)) {
        directions.addAll([
          PlayboardDirection.down,
          ...List.generate(
              dxDistance,
              (_) => isInvert
                  ? PlayboardDirection.left
                  : PlayboardDirection.right),
          PlayboardDirection.up,
          ...List.generate(
              dxDistance,
              (_) => isInvert
                  ? PlayboardDirection.right
                  : PlayboardDirection.left),
        ]);
      }
      directions.add(PlayboardDirection.down);
    }
    // [Case 3]
    if (dxDistance == 0 && dyDistance > 0) {
      for (final i in 0.till(dyDistance - 1)) {
        directions.addAll([
          ...List.generate(dyDistance, (_) => PlayboardDirection.down),
          isInvert ? PlayboardDirection.left : PlayboardDirection.right,
          ...List.generate(dyDistance, (_) => PlayboardDirection.up),
          isInvert ? PlayboardDirection.right : PlayboardDirection.left,
        ]);
      }
      directions.add(PlayboardDirection.down);
    }
    return directions;
  }

  /// From the hole loc to number loc
  /// The the `dxDistance` and `dyDistance` is the distance between the hole and the number
  /// - `dxDistance` or `dyDistance` must be negative
  ///
  /// CASE 0: `dxDistance` is negative and `dyDistance` is positive
  ///
  /// - SUB-CASE 0: `numberLoc` in the second row
  ///
  /// dyDistance = 1
  /// dxDistance = -2
  /// ```
  ///                    Loc(0, 2)
  ///                     |
  ///                     |
  ///              -------------
  ///              |1 |2 |X |14|
  ///              -------------
  /// Loc(1, 0)--->|3 |10|8 |9 |
  ///              -------------
  ///              |12|6 |11|15|
  ///              -------------
  ///              |5 |4 |13|7 |
  ///              -------------
  /// ```
  /// - SUB-CASE 1: `numberLoc` in the bottom row
  ///
  /// dyDistance = 2
  /// dxDistance = -1
  ///
  /// ```
  ///       Loc(0, 1)
  ///        |
  ///        |
  /// -------------
  /// |1 |2 |X |14|
  /// -------------
  /// |12|6 |11|15|
  /// -------------
  /// |9 |10|8 |4 |
  /// -------------
  /// |5 |3 |13|7 |
  /// -------------
  ///     |
  ///     |
  ///    Loc(3, 1)
  /// ```
  ///
  /// CASE 1: `dxDistance` is positive and `dyDistance` is negative
  ///
  /// - SUB-CASE 0: `numberLoc` in the right-most column
  /// dyDistance = -1
  /// dxDistance = 3
  ///
  /// ```
  ///              -------------
  ///              |1 |2 |3 |4 |
  ///              -------------
  ///              |5 |15|12|9 | <-- Loc(1, 3)
  ///              -------------
  /// Loc(2, 0)--> |X |13|8 |7 |
  ///              -------------
  ///              |14|6 |10|11|
  ///              -------------
  /// ```
  ///
  /// - SUB-CASE 0: `numberLoc` not in the right-most column
  /// dyDistance = -1
  /// dxDistance = 3
  ///
  /// ```
  ///              -------------
  ///              |1 |2 |3 |4 |
  ///              -------------
  ///              |5 |15|9 |12| <-- Loc(1, 2)
  ///              -------------
  /// Loc(2, 0)--> |X |13|8 |7 |
  ///              -------------
  ///              |14|6 |10|11|
  ///              -------------
  /// ```
  ///
  /// CASE 2: `dxDistance` is negative and `dyDistance` is negative (Not possible)
  ///
  /// CASE 3: `dxDistance` is negative and `dyDistance` is zero (Handle it in the `_numberToRightNumberLoc`)
  ///
  /// CASE 4: `dxDistance` is zero and `dyDistance` is negative (Handle it in the `_numberToRightNumberLoc`)
  static List<PlayboardDirection> _numberToRightNumberLocNegativeCase({
    required Loc numberLoc,
    required Loc rightNumberLoc,
    required List<int> currentBoard,
  }) {
    int dyDistance = numberLoc.dy - rightNumberLoc.dy;
    int dxDistance = numberLoc.dx - rightNumberLoc.dx;

    var directions = <PlayboardDirection>[];
    // [Case 0]
    if (dyDistance > 0 && dxDistance < 0) {
      directions.addAll(
        [...List.generate(dyDistance, (_) => PlayboardDirection.down)],
      );
      // [Sub case 0]
      if (numberLoc.dy == 1) {
        for (final i in 0.till(dxDistance.abs() + 1)) {
          directions.addAll([
            PlayboardDirection.down,
            ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.left),
            PlayboardDirection.up,
            ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.right),
          ]);
        }
        directions.add(PlayboardDirection.up);
        for (final i in 0.till(dyDistance + 1)) {
          directions.addAll([
            ...List.generate(dyDistance + 1, (_) => PlayboardDirection.down),
            PlayboardDirection.right,
            ...List.generate(dyDistance + 1, (_) => PlayboardDirection.up),
            PlayboardDirection.left,
          ]);
        }
        directions.add(PlayboardDirection.down);
      }
      // [Sub case 1]
      else {
        for (final i in 0.till(dxDistance.abs() + 1)) {
          directions.addAll([
            PlayboardDirection.up,
            ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.left),
            PlayboardDirection.down,
            ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.right),
          ]);
        }
        directions.addAll(
          [...List.generate(dyDistance, (_) => PlayboardDirection.up)],
        );
        for (final i in 0.till(dyDistance - 1)) {
          directions.addAll([
            ...List.generate(dyDistance, (_) => PlayboardDirection.down),
            PlayboardDirection.right,
            ...List.generate(dyDistance, (_) => PlayboardDirection.up),
            PlayboardDirection.left,
          ]);
        }
        directions.add(PlayboardDirection.down);
      }
    }
    // [Case 1]
    if (dyDistance < 0 && dxDistance > 0) {
      directions.addAll(
        List.generate(dxDistance.abs(), (_) => PlayboardDirection.right),
      );
      // [Sub case 0]
      if (numberLoc.dx == 1) {
        for (final i in 0.till(dyDistance.abs() + 1)) {
          directions.addAll([
            PlayboardDirection.right,
            ...List.generate(dyDistance.abs(), (_) => PlayboardDirection.up),
            PlayboardDirection.left,
            ...List.generate(dyDistance.abs(), (_) => PlayboardDirection.down),
          ]);
        }
        directions
          ..add(PlayboardDirection.left)
          ..addAll([
            PlayboardDirection.right,
            PlayboardDirection.down,
            ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.left),
            PlayboardDirection.up,
          ])
          ..add(PlayboardDirection.right);
      }
      // [Sub case 1]
      else {
        for (final i in 0.till(dyDistance.abs() + 1)) {
          directions.addAll([
            PlayboardDirection.left,
            ...List.generate(dyDistance.abs(), (_) => PlayboardDirection.up),
            PlayboardDirection.right,
            ...List.generate(dyDistance.abs(), (_) => PlayboardDirection.down),
          ]);
        }
        directions.addAll([
          PlayboardDirection.down,
          ...List.generate(dxDistance.abs(), (_) => PlayboardDirection.left),
          PlayboardDirection.up,
        ]);
        for (final i in 0.till(dxDistance - 2)) {
          directions.addAll([
            ...List.generate(dxDistance - 1, (_) => PlayboardDirection.right),
            PlayboardDirection.up,
            ...List.generate(dxDistance - 1, (_) => PlayboardDirection.left),
            PlayboardDirection.down,
          ]);
        }
        directions.add(PlayboardDirection.right);
      }
    }
    return directions;
  }

  static List<PlayboardDirection> _numberToRightNumberLoc({
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
            ? PlayboardDirection.left
            : PlayboardDirection.right
      ];
    }

    final dxDistance = numberLoc.dx - rightNumberLoc.dx;
    final dyDistance = numberLoc.dy - rightNumberLoc.dy;

    final directions = <PlayboardDirection>[];

    if (dxDistance >= 0 && dyDistance >= 0) {
      directions.addAll(
        _numberToRightNumberLocPositiveCase(
          numberLoc: numberLoc,
          rightNumberLoc: rightNumberLoc,
        ),
      );
    } else {
      directions.addAll(
        _numberToRightNumberLocNegativeCase(
          numberLoc: numberLoc,
          rightNumberLoc: rightNumberLoc,
          currentBoard: currentBoard,
        ),
      );
    }
    return directions;
  }

  static List<PlayboardDirection> _solveRowEdgeCase(List<int> currentBoard) {
    List<int> _currentBoard = [...currentBoard];
    var directions = <PlayboardDirection>[];
    final size = currentBoard.size;
    final numberLoc = currentBoard.loc(size - 1);
    // [Case 1.1]
    if (numberLoc == const Loc(0, 1)) {
      directions
        ..addAll([
          ...List.generate(size - 2, (_) => PlayboardDirection.left),
          PlayboardDirection.down,
          ...List.generate(size - 2, (_) => PlayboardDirection.right),
          PlayboardDirection.up,
        ])
        ..addAll([
          PlayboardDirection.right,
          PlayboardDirection.up,
          ...List.generate(size - 1, (index) => PlayboardDirection.left),
          PlayboardDirection.down,
        ])
        ..addAll([
          ...List.generate(size - 1, (index) => PlayboardDirection.right),
        ]);
      _currentBoard.moveDirections(directions);
      for (final i in 0.till(size)) {
        directions.addAll([
          PlayboardDirection.down,
          ...List.generate(size - 1, (_) => PlayboardDirection.left),
          PlayboardDirection.up,
          ...List.generate(size - 1, (_) => PlayboardDirection.right),
        ]);
      }
      directions
        ..add(PlayboardDirection.down)
        ..addAll(
          _holeToRightNumberLoc(
            targetLoc: const Loc(0, 0),
            currentBoard: _currentBoard,
          ),
        )
        ..addAll([
          ...List.generate(size - 1, (_) => PlayboardDirection.left),
          PlayboardDirection.down,
        ]);
    } else {
      final prePath = [
        PlayboardDirection.right,
        PlayboardDirection.up,
        ...List.generate(size - 1, (index) => PlayboardDirection.left),
        PlayboardDirection.down,
        ...List.generate(size - 1, (index) => PlayboardDirection.right),
      ];
      _currentBoard = _currentBoard.moveDirections(directions);
      final numberLoc = _currentBoard.loc(size - 1);
      final holeLoc = _currentBoard.holeLoc;
      final numberPath = _numberToRightNumberLocPositiveCase(
        numberLoc: numberLoc,
        rightNumberLoc: holeLoc,
      );
      _currentBoard = _currentBoard.moveDirections(numberPath);
      final holePath = _holeToRightNumberLoc(
        targetLoc: const Loc(0, 0),
        currentBoard: _currentBoard,
      );
      _currentBoard = _currentBoard.moveDirections(holePath);
      final finishPath = [
        ...List.generate(size - 1, (index) => PlayboardDirection.left),
        PlayboardDirection.down,
      ];
      _currentBoard = _currentBoard.moveDirections(finishPath);

      directions
        ..addAll(prePath)
        ..addAll(numberPath)
        ..addAll(holePath)
        ..addAll(finishPath);
    }

    return directions;
  }

  static List<PlayboardDirection> _solveColumnEdgeCase(List<int> currentBoard) {
    List<int> _currentBoard = List.from(currentBoard);
    var directions = <PlayboardDirection>[];
    final size = currentBoard.size;

    void _numberPath() {
      var numberPath = <PlayboardDirection>[];

      final numberLoc = _currentBoard.loc(size * (size - 1) + 1);
      final holeLoc = _currentBoard.holeLoc;

      final dxDistance = (numberLoc.dx - holeLoc.dx).abs();
      final dyDistance = (numberLoc.dy - holeLoc.dy).abs();

      if (dxDistance == 0) {
        for (final i in 0.till(dyDistance - 1)) {
          numberPath.addAll([
            ...List.generate(dyDistance, (index) => PlayboardDirection.up),
            PlayboardDirection.right,
            ...List.generate(dyDistance, (index) => PlayboardDirection.down),
            PlayboardDirection.left,
          ]);
        }
        numberPath.add(PlayboardDirection.up);
        _currentBoard = _currentBoard.moveDirections(numberPath);
        numberPath.addAll(
          _holeToRightNumberLoc(
            targetLoc: Loc(size - 1, 0),
            currentBoard: _currentBoard,
          ),
        );
      } else if (dyDistance == 0) {
        for (final i in 0.till(dxDistance - 1)) {
          numberPath.addAll([
            ...List.generate(dxDistance, (index) => PlayboardDirection.right),
            PlayboardDirection.up,
            ...List.generate(dxDistance, (index) => PlayboardDirection.left),
            PlayboardDirection.down,
          ]);
        }
        numberPath.add(PlayboardDirection.right);
        _currentBoard = _currentBoard.moveDirections(numberPath);
        numberPath.addAll(
          _holeToRightNumberLoc(
            targetLoc: Loc(size - 1, 0),
            currentBoard: _currentBoard,
          ),
        );
      } else {
        for (final i in 0.till(dxDistance + dyDistance - 1)) {
          numberPath.addAll([
            ...List.generate(dyDistance, (index) => PlayboardDirection.up),
            ...List.generate(dxDistance, (index) => PlayboardDirection.right),
            ...List.generate(dyDistance, (index) => PlayboardDirection.down),
            ...List.generate(dxDistance, (index) => PlayboardDirection.left),
          ]);
        }
        numberPath.add(PlayboardDirection.up);
        _currentBoard = _currentBoard.moveDirections(numberPath);
        numberPath.addAll(
          _holeToRightNumberLoc(
            targetLoc: Loc(size - 1, 0),
            currentBoard: _currentBoard,
          ),
        );
      }

      directions.addAll(numberPath);
    }

    void _finishPath() => directions.addAll([
          ...List.generate(size - 1, (_) => PlayboardDirection.left),
          ...List.generate(size - 1, (_) => PlayboardDirection.down),
          PlayboardDirection.right,
        ]);

    if (_currentBoard.loc(size * (size - 1) + 1) == Loc(size - 1, 1)) {
      final preProcessPath = [
        ...List.generate(size - 1, (index) => PlayboardDirection.right),
        ...List.generate(size - 2, (index) => PlayboardDirection.up),
        ...List.generate(size - 2, (index) => PlayboardDirection.left),
        ...List.generate(size - 2, (index) => PlayboardDirection.down),
        PlayboardDirection.left,
        ...List.generate(size - 1, (index) => PlayboardDirection.up),
        ...List.generate(size - 1, (index) => PlayboardDirection.left),
        ...List.generate(size - 1, (index) => PlayboardDirection.down),
        ...List.generate(size - 2, (index) => PlayboardDirection.left),
      ];
      directions.addAll(preProcessPath);
      _currentBoard = _currentBoard.moveDirections(preProcessPath);
      _numberPath();
      _finishPath();
    } else {
      _numberPath();
      _finishPath();
    }

    return directions;
  }

  /// [Case 0]
  /// - Normal case we need calculate step hole loc and number loc
  /// [Case 1]
  /// - Current number equal to `boardSize - 1`
  /// - Push all previous number to right
  /// - Move `boardSize - 1` number to Loc(1, boardSize - 1)
  /// - Move hole to Loc(0, 0)
  /// - Push all previous number to left
  /// - Move `boardSize - 1` number to Loc(0, boardSize - 1)
  /// [Case 2]
  /// - Current number equal to `boardSize * (boardSize - 1) + 1`
  /// - Push all top number to down
  /// - Push all right number to left
  /// - Move `boardSize * (boardSize - 1) + 1` number to Loc(boardSize - 1, 1)
  /// - Move hole to Loc(0, boardSize - 1)
  /// - Push all left number to right
  /// - Push all bottom number to up
  /// - Move `boardSize * (boardSize - 1) + 1` number to Loc(boardSize - 1, 0)
  @visibleForTesting
  static List<PlayboardDirection> quickSolveSolution(
    PlayboardSolverParams params,
  ) {
    var directions = <PlayboardDirection>[];
    var currentBoard = params.currentBoard;
    final size = params.currentBoard.size;
    final _needToSolvePos = needToSolvePos(size);

    for (final index in _needToSolvePos) {
      // [Case 1]
      if (index == size - 1) {
        if (currentBoard.loc(index) == Loc(size - 1, 0)) continue;
        final path = _solveRowEdgeCase(currentBoard);
        currentBoard = currentBoard.moveDirections(path);
      }
      // [Case 2]
      else if (index == size * (size - 1) + 1) {
        if (currentBoard.loc(index) == Loc(0, size - 1)) continue;
        final path = _solveColumnEdgeCase(currentBoard);
        currentBoard = currentBoard.moveDirections(path);
      }
      // [Case 0]
      else {
        final rightNumberLoc = Loc.fromIndex(size, index);
        var currentNumberLoc = currentBoard.loc(index);
        if (currentNumberLoc == rightNumberLoc) continue;

        final holePath = _holeToRightNumberLoc(
          targetLoc: rightNumberLoc,
          currentBoard: currentBoard,
        );
        currentBoard = currentBoard.moveDirections(holePath);

        currentNumberLoc = currentBoard.loc(index);
        final numberPath = _numberToRightNumberLoc(
          numberLoc: currentNumberLoc,
          rightNumberLoc: rightNumberLoc,
          currentBoard: currentBoard,
        );
        currentBoard = currentBoard.moveDirections(numberPath);

        directions.addAll([...holePath, ...numberPath]);
      }
    }

    final newParams = PlayboardSolverParams(
      currentBoard.transform(),
      params.finalBoard,
      params.holeLoc,
    );
    if (size > 4) {
      directions.addAll(quickSolveSolution(newParams));
    } else {
      directions.addAll(bestStepSolution(newParams)?.directions ?? []);
    }

    return directions;
  }
}

extension SolvingPuzzleExt on List<int> {
  int get size => sqrt(length).floor();

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

  String printBoard() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      String char = this[i] == hole ? 'X | ' : '${this[i] + 1} | ';
      buffer.write('${i % size == 0 ? '\n' : ''}$char');
    }
    return buffer.toString();
  }

  List<int> moveDirections(List<PlayboardDirection> directions) {
    List<int> newList = [...this];

    print('DIRECTION: ${directions.map((e) => e.name)}');
    print('PRE BOARD: \n${newList.printBoard()}');
    for (final direction in directions) {
      final newHoleLoc = newList.holeLoc.move(size, direction);
      if (newHoleLoc == null) throw Exception('Cannot move direction');
      final holeIndex = newList.indexOf(hole);
      final newHoleIndex = newHoleLoc.index(size);
      final temp = newList[holeIndex];
      newList[holeIndex] = newList[newHoleIndex];
      newList[newHoleIndex] = temp;
    }
    print('AFTER BOARD: \n${newList.printBoard()}');
    return newList;
  }

  /// ```
  /// -------------
  /// | 5 | 6 | 7 |
  /// -------------
  /// | 9 | 10| 11|
  /// -------------
  /// | 13| 14| X |
  /// -------------
  ///       |
  ///       |
  /// -------------
  /// | 0 | 1 | 2 |
  /// -------------
  /// | 3 | 4 | 5 |
  /// -------------
  /// | 6 | 7 | X |
  /// -------------
  ///
  /// -----------------
  /// | 6 | 7 | 8 | 9 |
  /// -----------------
  /// | 11| 12| 13| 14|
  /// -----------------
  /// | 16| 17| 18| 19|
  /// -----------------
  /// | 21| 22| 23| X |
  /// -----------------
  ///         |
  ///         |
  /// -----------------
  /// | 0 | 1 | 2 | 3 |
  /// -----------------
  /// | 4 | 5 | 6 | 7 |
  /// -----------------
  /// | 8 | 9 | 10| 11|
  /// -----------------
  /// | 12| 13| 14| X |
  /// -----------------
  /// ```
  List<int> transform() {
    final boardSize = size;
    final pos = SolvingMachine.needToSolvePos(size);
    var list = [...this];
    for (final solved in pos) {
      list.removeWhere((e) => e == solved);
    }

    return list.map((index) {
      final remain = index ~/ boardSize;
      final newIndex = index - boardSize - remain;
      return newIndex;
    }).toList();
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
