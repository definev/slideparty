import 'package:slideparty/src/features/playboard/controllers/playboard_controller.dart';
import 'package:slideparty/src/features/playboard/helpers/helpers.dart';

class MultipleModeController extends PlayboardController<MultiplePlayboardState>
    with AutoSolveHelper {
  MultipleModeController(MultiplePlayboardState state) : super(state);
}
