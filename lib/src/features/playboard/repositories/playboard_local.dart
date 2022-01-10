import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/cores/db/db_core.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';

final playboardLocalProvider = Provider<PlayboardLocal>(
  (ref) => PlayboardLocalImpl(),
);

abstract class PlayboardLocal extends DbCore<dynamic> {
  ButtonColors get buttonColor;
  set buttonColor(ButtonColors color);
}

class PlayboardLocalImpl extends PlayboardLocal {
  @override
  ButtonColors get buttonColor => box.get(
        'buttonColor',
        defaultValue: ButtonColors.blue,
      );

  @override
  set buttonColor(ButtonColors color) => box.put('buttonColor', color);
}
