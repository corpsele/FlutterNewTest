import 'package:get_storage/get_storage.dart';

class StorageService {
  late final GetStorage _box;

  bool _initialized = false;

  // 单例 App全局一个
  static final StorageService _instance = StorageService._();
  StorageService._();

  static StorageService get instance => _instance;

  Future<void> init() async {
    if (_initialized) return;
    await GetStorage.init();
    _box = GetStorage();
    _initialized = true;
  }

  // -- 泛型读写 (T须为 String/int/bool/double/List<String> 等可序列化类型)
  Future<bool> write(String key, dynamic value) async {
    try {
      await _box.write(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  dynamic read(String key) => _box.read(key);

  Future<bool> remove(String key) async {
    try {
      await _box.remove(key);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      await _box.erase();
      return true;
    } catch (e) {
      return false;
    }
  }

  bool hasKey(String key) => _box.hasData(key);

  // --- 业务化 Key (集中管理，避免散落的魔法字符串) ---
  static const String kTmp = "";
}