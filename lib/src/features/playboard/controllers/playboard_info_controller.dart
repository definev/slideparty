import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/playboard/repositories/playboard_local.dart';
import 'package:slideparty/src/widgets/buttons/buttons.dart';

final playboardInfoControllerProvider =
    ChangeNotifierProvider<PlayboardInfoController>(
  (ref) => PlayboardInfoController(ref.read),
);

class PlayboardInfoController extends ChangeNotifier {
  PlayboardInfoController(this._read) {
    _color = _read(playboardLocalProvider).buttonColor;
    _boardSize = _read(playboardLocalProvider).boardSize;
  }

  final Reader _read;

  ButtonColors _color = ButtonColors.blue;
  ButtonColors get color => _color;
  set color(ButtonColors color) {
    _read(playboardLocalProvider).buttonColor = color;
    _color = color;
    notifyListeners();
  }

  int _boardSize = 3;
  int get boardSize => _boardSize;
  set boardSize(int value) {
    _read(playboardLocalProvider).boardSize = value;
    _boardSize = value;
    notifyListeners();
  }
}

extension ColorSchemeExt on ButtonColors {
  Color get primaryColor {
    switch (this) {
      case ButtonColors.blue:
        return const Color(0xFF25ADE6);
      case ButtonColors.green:
        return const Color(0xFF75CF4E);
      case ButtonColors.yellow:
        return const Color(0xFFFFCD06);
      case ButtonColors.red:
        return const Color(0xFFED701E);
    }
  }
}
