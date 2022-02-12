import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:slideparty/src/features/app_setting/app_setting_controller.dart';
import 'package:slideparty/src/features/home/home.dart';
import 'package:slideparty/src/features/multiple_mode/controllers/multiple_mode_controller.dart';
import 'package:slideparty/src/features/multiple_mode/multiple_mode.dart';
import 'package:slideparty/src/features/online_mode/controllers/online_playboard_controller.dart';
import 'package:slideparty/src/features/online_mode/online_mode.dart';
import 'package:slideparty/src/features/online_mode/screens/online_playboard_page.dart';
import 'package:slideparty/src/features/playboard/playboard.dart';
import 'package:slideparty/src/features/single_mode/controllers/single_mode_controller.dart';
import 'package:slideparty/src/features/single_mode/single_mode.dart';
import 'package:slideparty/src/utils/app_infos/app_infos.dart';
import 'package:slideparty/src/widgets/buttons/models/slideparty_button_params.dart';
import 'package:slideparty_socket/slideparty_socket_fe.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  static final router = GoRouter(
    initialLocation: '/',
    urlPathStrategy: UrlPathStrategy.hash,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          AppInfos.setAppTitle('Slide Party - Home');
          return const NoTransitionPage(
            child: HomePage(),
          );
        },
      ),
      GoRoute(
        path: '/_refresh',
        pageBuilder: (context, state) {
          AppInfos.setAppTitle('Loading ...');
          return const NoTransitionPage(
            child: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
      GoRoute(
        path: '/s_mode',
        pageBuilder: (context, state) {
          AppInfos.setAppTitle('Slide Party - Single Mode');
          return NoTransitionPage(
            child: ProviderScope(
              overrides: [
                playboardControllerProvider
                    .overrideWithProvider(singleModeControllerProvider),
              ],
              child: const SingleModePage(),
            ),
          );
        },
      ),
      GoRoute(
        path: '/o_mode',
        pageBuilder: (context, state) {
          AppInfos.setAppTitle('Slide Party - Online Mode');
          return const NoTransitionPage(
            child: OnlineModePage(),
          );
        },
      ),
      GoRoute(
        path: '/o_mode/:boardSize/:roomCode',
        pageBuilder: (context, state) {
          final info = RoomInfo(
            int.parse(state.params['boardSize']!),
            state.params['roomCode']!,
          );
          AppInfos.setAppTitle(
            'Online room: ${info.boardSize} x ${info.boardSize} - ${info.roomCode}',
          );

          return NoTransitionPage(
            child: ProviderScope(
              overrides: [
                playboardControllerProvider.overrideWithProvider(
                    onlinePlayboardControlllerProvider(info)),
              ],
              child: OnlinePlayboardPage(info: info),
            ),
          );
        },
      ),
      GoRoute(
        path: '/m_mode',
        pageBuilder: (context, state) {
          AppInfos.setAppTitle('Slide Party - Multiple Mode');
          return NoTransitionPage(
            child: ProviderScope(
              overrides: [
                playboardControllerProvider
                    .overrideWithProvider(multipleModeControllerProvider),
              ],
              child: const MultipleModePage(),
            ),
          );
        },
      ),
    ],
  );

  @override
  _AppState createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final playboardDefaultColor = ref
        .watch(playboardInfoControllerProvider.select((value) => value.color));
    final isDarkTheme = ref.watch(
        appSettingControllerProvider.select((value) => value.isDarkTheme));

    return MaterialApp.router(
      routeInformationParser: App.router.routeInformationParser,
      routerDelegate: App.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: playboardDefaultColor.lightTheme,
      darkTheme: playboardDefaultColor.darkTheme,
      onGenerateTitle: (context) => 'Not Found',
    );
  }
}
