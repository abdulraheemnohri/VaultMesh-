import 'package:flutter/services.dart';

class ClipboardManager {
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  static Future<void> clearClipboard() async {
    await Clipboard.setData(const ClipboardData(text: ''));
  }
}