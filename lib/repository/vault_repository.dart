import 'package:hive/hive.dart';

class VaultRepository {
  static const _boxName = 'vaultBox';

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<void> saveItem(String key, String encryptedData) async {
    final box = await _openBox();
    await box.put(key, encryptedData);
  }

  Future<String?> getItem(String key) async {
    final box = await _openBox();
    return box.get(key);
  }

  Future<void> deleteItem(String key) async {
    final box = await _openBox();
    await box.delete(key);
  }
}