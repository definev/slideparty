import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:slideparty/src/features/home/home.dart';
import 'package:slideparty/src/features/multiple_mode/multiple_mode.dart';
import 'package:slideparty/src/features/online_mode/online_mode.dart';
import 'package:slideparty/src/features/single_mode/single_mode.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  static final router = GoRouter(
    initialLocation: '/',
    urlPathStrategy: UrlPathStrategy.path,
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: HomePage(),
        ),
      ),
      GoRoute(
        path: '/s_mode',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: SingleModePage(),
        ),
      ),
      GoRoute(
        path: '/o_mode',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: OnlineModePage(),
        ),
      ),
      GoRoute(
        path: '/m_mode',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: MultipleModePage(),
        ),
      ),
    ],
  );

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    precacheImage(
      const AssetImage('assets/buttons/blue_hover_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_hover_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_hover_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_hover_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/blue_hover_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_hover_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_hover_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_hover_square_button.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/buttons/blue_pressed_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_pressed_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_pressed_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_pressed_large_button.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/buttons/blue_pressed_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_pressed_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_pressed_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_pressed_square_button.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/buttons/blue_idle_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_idle_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_idle_large_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_idle_large_button.png'),
      context,
    );

    precacheImage(
      const AssetImage('assets/buttons/blue_idle_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/yellow_idle_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/red_idle_square_button.png'),
      context,
    );
    precacheImage(
      const AssetImage('assets/buttons/green_idle_square_button.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: App.router.routeInformationParser,
      routerDelegate: App.router.routerDelegate,
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.dark(
        fontFamily: 'kenvector_future',
        scheme: FlexScheme.redWine,
        blendLevel: 20,
        surfaceMode: FlexSurfaceMode.highSurfaceLowScaffold,
      ).toTheme,
    );
  }
}
