import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:slideparty/src/cores/db.dart';

final appSettingLocalProvider =
    Provider<AppSettingLocal>((ref) => AppSettingLocalImpl());

abstract class AppSettingLocal extends DbCore {
  bool get isDarkTheme;
  set isDarkTheme(bool value);
}

class AppSettingLocalImpl extends AppSettingLocal {
  @override
  bool get isDarkTheme => box.get('isDarkTheme', defaultValue: false);

  @override
  set isDarkTheme(bool value) => box.put('isDarkTheme', value);
}
