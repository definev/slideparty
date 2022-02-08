import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:slideparty/app.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';
import 'package:slideparty/src/features/app_setting/app_setting_local.dart';
import 'package:slideparty/src/features/audio/repositories/audio_local.dart';
import 'package:slideparty/src/features/home/home.dart';
import 'package:slideparty/src/features/playboard/controllers/playboard_info_controller.dart';
import 'package:slideparty/src/features/playboard/repositories/playboard_local.dart';
import 'package:slideparty/src/widgets/widgets.dart';

import '../features/app_setting/mock_app_setting_local.dart';
import '../features/audio/mock_audio_local.dart';
import '../features/playboard/mock_playboard_local.dart';

class MockLocals {
  final audioLocal = MockAudioLocal();
  final playboardLocal = MockPlayboardLocal();
  final appSettingLocal = MockAppSettingLocal();
}

Future<Tuple2<Widget, MockLocals>> testApp(
  Widget child,
) async {
  final locals = MockLocals();
  when(() => locals.appSettingLocal.isDarkTheme).thenReturn(true);
  when(() => locals.audioLocal.isMuted).thenReturn(true);
  when(() => locals.playboardLocal.boardSize).thenReturn(3);
  when(() => locals.playboardLocal.buttonColor).thenReturn(ButtonColors.yellow);

  final widget = ProviderScope(
    overrides: [
      playboardLocalProvider.overrideWithValue(locals.playboardLocal),
      appSettingLocalProvider.overrideWithValue(locals.appSettingLocal),
      audioLocalProvider.overrideWithValue(locals.audioLocal),
    ],
    child: Portal(
      child: Consumer(
        builder: (context, ref, child) {
          final playboardDefaultColor = ref.watch(
              playboardInfoControllerProvider.select((value) => value.color));
          final isDarkTheme = ref.watch(appSettingControllerProvider
              .select((value) => value.isDarkTheme));

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: FlexColorScheme.light(
              fontFamily: 'kenvector_future',
              primary: playboardDefaultColor.primaryColor,
              blendLevel: 20,
              surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
            ).toTheme,
            darkTheme: FlexColorScheme.dark(
              fontFamily: 'kenvector_future',
              primary: playboardDefaultColor.primaryColor,
              blendLevel: 20,
              surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
            ).toTheme,
            home: child,
          );
        },
        child: child,
      ),
    ),
  );

  return Tuple2(widget, locals);
}

Future<MockLocals> testRouterApp(
  WidgetTester tester, {
  required String initialRoute,
}) async {
  final locals = MockLocals();
  when(() => locals.appSettingLocal.isDarkTheme).thenReturn(true);
  when(() => locals.audioLocal.isMuted).thenReturn(true);
  when(() => locals.playboardLocal.boardSize).thenReturn(3);
  when(() => locals.playboardLocal.buttonColor).thenReturn(ButtonColors.yellow);

  final widget = ProviderScope(
    overrides: [
      playboardLocalProvider.overrideWithValue(locals.playboardLocal),
      appSettingLocalProvider.overrideWithValue(locals.appSettingLocal),
      audioLocalProvider.overrideWithValue(locals.audioLocal),
    ],
    child: Portal(
      child: Consumer(
        builder: (context, ref, child) {
          final playboardDefaultColor = ref.watch(
              playboardInfoControllerProvider.select((value) => value.color));
          final isDarkTheme = ref.watch(appSettingControllerProvider
              .select((value) => value.isDarkTheme));

          return MaterialApp.router(
            routerDelegate: App.router.routerDelegate,
            routeInformationParser: App.router.routeInformationParser,
            debugShowCheckedModeBanner: false,
            themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            theme: FlexColorScheme.light(
              fontFamily: 'kenvector_future',
              primary: playboardDefaultColor.primaryColor,
              blendLevel: 20,
              surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
            ).toTheme,
            darkTheme: FlexColorScheme.dark(
              fontFamily: 'kenvector_future',
              primary: playboardDefaultColor.primaryColor,
              blendLevel: 20,
              surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
            ).toTheme,
          );
        },
      ),
    ),
  );

  await tester.pumpWidget(widget);
  await tester.pumpAndSettle();

  BuildContext context = tester.allElements.last;
  context.go(initialRoute);
  await tester.pumpAndSettle();

  return locals;
}
