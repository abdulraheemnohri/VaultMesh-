import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionManager {
  static const _storage = FlutterSecureStorage();
  static const _keyStorageKey = 'encryption_key';

  static Future<Key> _getOrCreateKey(String masterPassword) async {
    final storedKey = await _storage.read(key: _keyStorageKey);
    if (storedKey != null) {
      return Key.fromBase64(storedKey);
    } else {
      final key = Key.fromUtf8(masterPassword.padRight(32).substring(0, 32));
      await _storage.write(key: _keyStorageKey, value: key.base64);
      return key;
    }
  }

  static Future<String> encrypt(String plainText, String masterPassword) async {
    final key = await _getOrCreateKey(masterPassword);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return encrypter.encrypt(plainText, iv: iv).base64;
  }

  static Future<String> decrypt(String encryptedText, String masterPassword) async {
    final key = await _getOrCreateKey(masterPassword);
    final iv = IV.fromLength(16);
    final encrypter = Encrypter(AES(key, mode: AESMode.gcm));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: iv);
  }
}