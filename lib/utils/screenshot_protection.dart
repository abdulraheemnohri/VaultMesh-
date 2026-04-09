import 'package:flutter/services.dart';

class ScreenshotProtection {
  static void disable() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  static void enable() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
}