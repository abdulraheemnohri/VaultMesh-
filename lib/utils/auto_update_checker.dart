import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class AutoUpdateChecker {
  static const String _githubRepoOwner = 'abdulraheemnohri';
  static const String _githubRepoName = 'VaultMesh-';

  // GitHub Releases API سے نیا ورژن چیک کرنا
  static Future<bool> isUpdateAvailable() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(
        Uri.parse('https://api.github.com/repos/$_githubRepoOwner/$_githubRepoName/releases/latest'),
      );

      if (response.statusCode == 200) {
        final latestRelease = response.body;
        final latestVersion = _extractVersionFromRelease(latestRelease);

        return _compareVersions(currentVersion, latestVersion) < 0;
      }
      return false;
    } catch (e) {
      debugPrint('Error checking for updates: $e');
      return false;
    }
  }

  // ریلیز سے ورژن نکالنا
  static String _extractVersionFromRelease(String releaseBody) {
    final versionRegex = RegExp(r'tag_name\":\s*\"v([\d.]+)\"');
    final match = versionRegex.firstMatch(releaseBody);
    return match?.group(1) ?? '0.0.0';
  }

  // ورژنز کی موازنہ کرنا
  static int _compareVersions(String currentVersion, String latestVersion) {
    final currentParts = currentVersion.split('.').map(int.parse).toList();
    final latestParts = latestVersion.split('.').map(int.parse).toList();

    for (int i = 0; i < 3; i++) {
      if (currentParts[i] < latestParts[i]) return -1;
      if (currentParts[i] > latestParts[i]) return 1;
    }
    return 0;
  }

  // نیا ورژن دستیاب ہونے پر نوٹیفیکیشن دکھانا
  static Future<void> showUpdateDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('نیا ورژن دستیاب ہے!'),
          content: const Text('آپ کے پاس اب ایک نیا ورژن دستیاب ہے۔ براہ کرم اپ ڈیٹ کر لیجئے۔'),
          actions: <Widget>[
            TextButton(
              child: const Text('ابھی اپ ڈیٹ کریں'),
              onPressed: () {
                _launchGitHubReleases();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('بعد میں'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // GitHub ریلیز پیج کھولنا
  static Future<void> _launchGitHubReleases() async {
    final url = 'https://github.com/$_githubRepoOwner/$_githubRepoName/releases/latest';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}