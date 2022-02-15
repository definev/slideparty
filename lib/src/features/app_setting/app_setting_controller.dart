import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/app_setting/app_setting_local.dart';

final appSettingControllerProvider =
    ChangeNotifierProvider<AppSettingController>(
        (ref) => AppSettingController(ref.read));

class AppSettingController extends ChangeNotifier {
  AppSettingController(this._read) {
    _isDarkTheme = _read(appSettingLocalProvider).isDarkTheme;
    _reduceMotion = _read(appSettingLocalProvider).reduceMotion;
  }

  final Reader _read;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    _read(appSettingLocalProvider).isDarkTheme = value;
    notifyListeners();
  }

  bool _reduceMotion = false;
  bool get reduceMotion => _reduceMotion;
  set reduceMotion(bool value) {
    _reduceMotion = value;
    _read(appSettingLocalProvider).reduceMotion = value;
    notifyListeners();
  }
}
