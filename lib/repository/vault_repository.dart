import 'package:hive/hive.dart';
import 'dart:convert';

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

  // تمام ڈیٹا حاصل کرنا
  Future<Map<String, dynamic>> getAllData() async {
    final box = await _openBox();
    final allData = <String, dynamic>{};
    for (final key in box.keys) {
      allData[key.toString()] = box.get(key);
    }
    return allData;
  }

  // تمام ڈیٹا سینک کرنا
  Future<void> syncAllData(Map<String, dynamic> newData) async {
    final box = await _openBox();
    await box.clear();
    for (final entry in newData.entries) {
      await box.put(entry.key, entry.value);
    }
  }
}