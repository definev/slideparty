// ignore: avoid_web_libraries_in_flutter
import 'package:universal_platform/universal_platform.dart';

import 'html_localtor.dart' if (dart.library.html) 'dart:html';

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
    }
    return UniversalPlatform.isDesktop
        ? ScreenTypes.mouse
        : ScreenTypes.touchscreenAndMouse;
  }
}