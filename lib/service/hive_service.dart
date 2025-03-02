import 'package:hive_flutter/hive_flutter.dart';
import 'package:linkjo/utils/hive_key.dart';

class HiveService {
  static late Box _box;

  /// Inisialisasi Hive
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(HiveKey.box); 
  }

  /// Simpan data ke Hive
  static Future<void> putData(String key, dynamic value) async {
    await _box.put(key, value);
  }

  /// Ambil data dari Hive
  static dynamic getData(String key, {dynamic defaultValue}) {
    return _box.get(key, defaultValue: defaultValue);
  }

  /// Hapus data dari Hive
  static Future<void> deleteData(String key) async {
    await _box.delete(key);
  }

  /// Hapus semua data di box
  static Future<void> clearBox() async {
    await _box.clear();
  }

  /// Cek apakah key ada di Hive
  static bool containsKey(String key) {
    return _box.containsKey(key);
  }
}
