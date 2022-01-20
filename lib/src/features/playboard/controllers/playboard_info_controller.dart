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
