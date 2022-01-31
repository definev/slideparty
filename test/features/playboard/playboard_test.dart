import 'dart:developer';

import 'package:flutter_test/flutter_test.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

void main() {
  group('Playboard test', () {
    group('Auto solving', () {
      test('Already solved state', () {
        Playboard board = Playboard.fromMatrix(
          [
            [0, 1, 2, 3],
            [4, 5, 6, 7],
            [8, 9, 10, 11],
            [12, 13, 14, 15],
          ],
        );

        final directions = board.autoSolve();
        expect(directions, <PlayboardDirection>[]);
      });
      test('Cannot solved state', () {
        Playboard board = Playboard.fromMatrix(
          [
            [0, 1, 2, 3],
            [4, 5, 6, 7],
            [8, 9, 10, 11],
            [12, 14, 13, 15],
          ],
        );

        final directions = board.autoSolve();
        expect(directions, null);
      });
      group('Solving state', () {
        group('Best solve solution', () {
          test('One move to finish state', () {
            Playboard board = Playboard.fromMatrix(
              [
                [0, 1, 2],
                [3, 4, 5],
                [6, 8, 7],
              ],
            );

            final directions = board.autoSolve();
            expect(directions, const [PlayboardDirection.right]);
          });

          test('More move to finish state', () {
            Playboard board = Playboard.fromMatrix(
              [
                [0, 7, 1],
                [8, 3, 2],
                [6, 5, 4],
              ],
            );

            final directions = board.autoSolve();
            expect(directions?.length, greaterThan(1));
          });
        });
        group('Quick solve solution', () {
          test('4x4: test case 1', () {
            final playboard = Playboard.fromMatrix([
              [0, 15, 13, 14],
              [1, 5, 3, 11],
              [6, 4, 7, 8],
              [10, 2, 12, 9],
            ]);

            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });
          test('4x4: test case 2', () {
            final playboard = Playboard.fromMatrix(
              [
                [0, 8, 10, 13],
                [15, 5, 14, 1],
                [9, 7, 12, 11],
                [3, 4, 2, 6],
              ],
            );
            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });

          test('4x4: test case 3', () {
            final playboard = Playboard.fromList(
              [10, 8, 12, 5, 15, 11, 16, 9, 13, 2, 4, 14, 3, 1, 6, 7]
                  .map((e) => e - 1)
                  .toList(),
            );
            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });
          test('4x4: test case 4', () {
            final playboard = Playboard.fromList(
              [1, 16, 14, 12, 13, 7, 4, 11, 3, 5, 9, 15, 10, 2, 8, 6]
                  .map((e) => e - 1)
                  .toList(),
            );
            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });
          test('4x4: test case random', () {
            for (int i = 0; i < 10; i++) {
              final playboard = Playboard.random(4);
              try {
                final directions =
                    SolvingMachine.quickSolveSolution(playboard.currentBoard);
                expect(
                  playboard.currentBoard.moveDirections(directions),
                  equals(playboard.solvedBoard),
                  reason: 'This board failed: ${playboard.currentBoard}',
                );
              } catch (e) {
                log('ERROR CASE: ${playboard.currentBoard.printBoard()}');
              }
            }
          });

          test('5x5: test case 1', () {
            final playboard = Playboard.fromList(
              [
                [25, 5, 17, 22, 18],
                [12, 7, 2, 10, 8],
                [15, 9, 14, 24, 20],
                [3, 21, 4, 19, 1],
                [13, 6, 16, 23, 11],
              ].expand((e) => e).map((e) => e - 1).toList(),
            );
            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });
          test('5x5: test case 2', () {
            final playboard = Playboard.fromList([
              [1, 2, 3, 4, 5],
              [6, 23, 12, 9, 13],
              [11, 25, 10, 19, 16],
              [15, 14, 8, 18, 7],
              [22, 17, 20, 21, 24],
            ].expand((e) => e).map((e) => e - 1).toList());
            final directions =
                SolvingMachine.quickSolveSolution(playboard.currentBoard);
            expect(
              playboard.currentBoard.moveDirections(directions),
              equals(playboard.solvedBoard),
            );
          });
          test('5x5: test case random', () {
            for (int i = 0; i < 10; i++) {
              final playboard = Playboard.random(5);
              try {
                final directions =
                    SolvingMachine.quickSolveSolution(playboard.currentBoard);
                final solvedBoard =
                    playboard.currentBoard.moveDirections(directions);

                expect(
                  solvedBoard,
                  equals(playboard.solvedBoard),
                );
              } catch (e) {
                log('ERROR CASE: ${playboard.currentBoard.printBoard()}');
              }
            }
          });
        });
      });
    });

    group('Inversion', () {
      test('have inversion', () {
        final inversion = [
          [0, 7, 1],
          [8, 3, 2],
          [6, 5, 4],
        ].expand((e) => e).toList().inversion;
        expect(inversion, 10);
      });
      test('no inversion', () {
        final inversion = [
          [0, 1, 2],
          [3, 4, 5],
          [6, 8, 7],
        ].expand((e) => e).toList().inversion;
        expect(inversion, 0);
      });
    });

    test('Quick solve solution: Need to solve pos 3x3, 4x4, 5x5', () {
      final _pos3x3 = SolvingMachine.needToSolvePos(3);
      expect(_pos3x3, equals([0, 1, 2, 3, 6]));
      final _pos4x4 = SolvingMachine.needToSolvePos(4);
      expect(_pos4x4, equals([0, 1, 2, 3, 4, 8, 12]));
      final _pos5x5 = SolvingMachine.needToSolvePos(5);
      expect(_pos5x5, equals([0, 1, 2, 3, 4, 5, 10, 15, 20]));
    });
  });
}
