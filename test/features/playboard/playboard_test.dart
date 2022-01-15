import 'package:flutter_test/flutter_test.dart';
import 'package:slideparty/src/features/playboard/models/playboard.dart';

void main() {
  group('Playboard auto solving', () {
    test('Not solve with greater than 3x3', () {
      Playboard board = Playboard.fromMatrix(
        [
          [0, 1, 2, 3],
          [4, 5, 6, 7],
          [8, 9, 10, 11],
          [12, 13, 14, 15],
        ],
      );

      final directions = board.autoSolve();
      expect(directions, null);
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

    test('Inversion test', () {
      final inversion = [
        [0, 7, 1],
        [8, 3, 2],
        [6, 5, 4],
      ].expand((e) => e).toList().inversion;
      expect(inversion, 10);
    });
  });
}
