import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:uuid/uuid.dart';

class SyncSecurityService {
  final _aes = AesGcm.with256bits();

  /// Generates a new pairing payload: IP, Port, and a random Sync Secret.
  Map<String, dynamic> generatePairingData(String ip, int port) {
    final secret = const Uuid().v4().replaceAll('-', ''); // 32 chars = 256 bits
    return {
      'ip': ip,
      'port': port,
      'secret': secret,
    };
  }

  /// Encrypts data for transmission using the shared sync secret.
  Future<String> encryptForSync(String data, String secret) async {
    final keyBytes = utf8.encode(secret.padRight(32).substring(0, 32));
    final secretKey = SecretKey(keyBytes);
    final nonce = _aes.newNonce();

    final secretBox = await _aes.encrypt(
      utf8.encode(data),
      secretKey: secretKey,
      nonce: nonce,
    );

    final combined = nonce + secretBox.mac.bytes + secretBox.cipherText;
    return base64.encode(combined);
  }

  /// Decrypts data received from a synced device.
  Future<String> decryptFromSync(String encryptedBase64, String secret) async {
    final keyBytes = utf8.encode(secret.padRight(32).substring(0, 32));
    final secretKey = SecretKey(keyBytes);
    final combined = base64.decode(encryptedBase64);

    final nonce = combined.sublist(0, 12);
    final macBytes = combined.sublist(12, 28);
    final cipherText = combined.sublist(28);

    final secretBox = SecretBox(
      cipherText,
      nonce: nonce,
      mac: Mac(macBytes),
    );

    final clearText = await _aes.decrypt(
      secretBox,
      secretKey: secretKey,
    );

    return utf8.decode(clearText);
  }
}
