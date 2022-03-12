import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';

import 'html_locator.dart' if (dart.library.html) 'dart:html';
import 'io_locator.dart' if (dart.library.io) 'dart:io';

import 'package:flutter/foundation.dart';

enum ScreenTypes { touchscreen, touchscreenAndMouse, mouse }

class AppInfos {
  static ScreenTypes get screenType {
    ScreenTypes getOSInsideWeb() {
      final userAgent = window.navigator.userAgent.toString().toLowerCase();
      if (userAgent.contains("iphone")) return ScreenTypes.touchscreen;
      if (userAgent.contains("ipad")) return ScreenTypes.touchscreenAndMouse;
      if (userAgent.contains("android")) return ScreenTypes.touchscreen;
      return ScreenTypes.mouse;
    }

    if (kIsWeb) {
      return getOSInsideWeb();
    } else {
      if (Platform.environment.containsKey('FLUTTER_TEST')) {
        return ScreenTypes.touchscreenAndMouse;
      }
    }

    return UniversalPlatform.isDesktop
        ? ScreenTypes.mouse
        : ScreenTypes.touchscreenAndMouse;
  }

  static void setAppTitle(String label) {
    if (!kIsWeb) return;
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(label: label),
    );
  }
}
