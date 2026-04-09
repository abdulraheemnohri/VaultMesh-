import 'package:encrypt/encrypt.dart';

class EncryptionManager {
  static const _keyLength = 32;
  static const _ivLength = 16;

  final Key _key;
  final IV _iv;

  EncryptionManager(this._key, this._iv);

  String encrypt(String plainText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.encrypt(plainText, iv: _iv).base64;
  }

  String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(_key, mode: AESMode.gcm));
    return encrypter.decrypt(Encrypted.fromBase64(encryptedText), iv: _iv);
  }
}