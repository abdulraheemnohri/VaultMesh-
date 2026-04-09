import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRSync {
  // QR کوڈ بنانا
  static Widget buildQRCode(String deviceId, String localIp) {
    final qrData = 'vaultmesh:sync:$deviceId:$localIp';
    return QrImageView(
      data: qrData,
      version: QrVersions.auto,
      size: 200.0,
    );
  }

  // QR کوڈ اسکین کرنا
  static Future<String?> scanQRCode() async {
    try {
      final qrResult = await MobileScanner.scan();
      return qrResult.rawValue;
    } catch (e) {
      return null;
    }
  }
}