import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionService {
  final _storage = const FlutterSecureStorage();
  final _argon2 = Argon2.id();
  final _aes = AesGcm.with256bits();

  static const String _saltKey = 'vault_master_salt';
  static const String _hashKey = 'vault_master_hash';

  Future<Uint8List> deriveKey(String password, List<int> salt) async {
    final secretKey = await _argon2.deriveKeyFromPassword(
      password: password,
      nonce: salt,
    );
    final bytes = await secretKey.extractBytes();
    return Uint8List.fromList(bytes);
  }

  Future<String> encrypt(String data, Uint8List key) async {
    final secretKey = SecretKey(key);
    final nonce = _aes.newNonce();
    final clearText = utf8.encode(data);

    final secretBox = await _aes.encrypt(
      clearText,
      secretKey: secretKey,
      nonce: nonce,
    );

    final combined = nonce + secretBox.mac.bytes + secretBox.cipherText;
    return base64.encode(combined);
  }

  Future<String> decrypt(String encryptedBase64, Uint8List key) async {
    final secretKey = SecretKey(key);
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

  Future<void> setupMasterPassword(String password) async {
    final salt = SecretKeyData.random(length: 16).bytes;
    final key = await deriveKey(password, salt);

    await _storage.write(key: _saltKey, value: base64.encode(salt));

    final canary = await encrypt("VAULTMESH_OK", key);
    await _storage.write(key: _hashKey, value: canary);
  }

  Future<Uint8List?> verifyAndDeriveKey(String password) async {
    final saltBase64 = await _storage.read(key: _saltKey);
    final hashBase64 = await _storage.read(key: _hashKey);

    if (saltBase64 == null || hashBase64 == null) return null;

    final salt = base64.decode(saltBase64);
    final key = await deriveKey(password, salt);

    try {
      final decrypted = await decrypt(hashBase64, key);
      if (decrypted == "VAULTMESH_OK") {
        return key;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<bool> isFirstLaunch() async {
    final salt = await _storage.read(key: _saltKey);
    return salt == null;
  }
}
