import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_state.dart';

export 'playboard_state.dart';

typedef PlayboardController<T extends PlayboardState> = StateNotifier<T>;

final playboardControllerProvider =
    StateNotifierProvider.autoDispose<PlayboardController, PlayboardState>(
        (_) => throw UnimplementedError(
            'Need implement controller this before access in playboard.'));
