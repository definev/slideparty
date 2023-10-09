import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/features/app_setting/app_setting_local.dart';

final appSettingControllerProvider =
    ChangeNotifierProvider<AppSettingController>(
        (ref) => AppSettingController(ref));

class AppSettingController extends ChangeNotifier {
  AppSettingController(this.ref) {
    _isDarkTheme = ref.read(appSettingLocalProvider).isDarkTheme;
    _reduceMotion = ref.read(appSettingLocalProvider).reduceMotion;
  }

  final Ref ref;

  bool _isDarkTheme = false;
  bool get isDarkTheme => _isDarkTheme;
  set isDarkTheme(bool value) {
    _isDarkTheme = value;
    ref.read(appSettingLocalProvider).isDarkTheme = value;
    notifyListeners();
  }

  bool _reduceMotion = false;
  bool get reduceMotion => _reduceMotion;
  set reduceMotion(bool value) {
    _reduceMotion = value;
    ref.read(appSettingLocalProvider).reduceMotion = value;
    notifyListeners();
  }
}
