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
