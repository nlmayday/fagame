import 'package:shared_preferences/shared_preferences.dart';

/// 存储服务接口
class StorageService {
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// 初始化存储服务
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  /// 写入数据
  Future<void> write(String key, String value) async {
    await _ensureInitialized();
    await _prefs.setString(key, value);
  }

  /// 读取数据
  Future<String?> read(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key);
  }

  /// 删除数据
  Future<void> delete(String key) async {
    await _ensureInitialized();
    await _prefs.remove(key);
  }

  /// 清除所有数据
  Future<void> clear() async {
    await _ensureInitialized();
    await _prefs.clear();
  }

  /// 确保已初始化
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }
}
