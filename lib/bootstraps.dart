import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:slideparty/src/cores/db.dart';
import 'package:slideparty/src/features/app_setting/app_setting_local.dart';
import 'package:slideparty/src/features/playboard/repositories/playboard_local.dart';

void bootstraps(Widget app) async {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  await Hive.initFlutter();

  // Database initialization
  AdapterIntializer.initialize();

  PlayboardLocal playboardLocal = PlayboardLocalImpl();
  await playboardLocal.init();
  AppSettingLocal appSettingLocal = AppSettingLocalImpl();
  await appSettingLocal.init();

  runApp(
    ProviderScope(
      overrides: [
        playboardLocalProvider.overrideWithValue(playboardLocal),
        appSettingLocalProvider.overrideWithValue(appSettingLocal),
      ],
      child: Portal(child: app),
    ),
  );
}
