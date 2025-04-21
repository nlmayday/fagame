import 'package:fagame/core/utils/logger.dart';

/// API模式状态跟踪器
///
/// 用于跟踪和打印当前应用是使用模拟数据还是真实API
class ApiModeService {
  /// 单例实例
  static final ApiModeService _instance = ApiModeService._internal();

  /// 获取单例实例
  factory ApiModeService() => _instance;

  /// 私有构造函数r
  ApiModeService._internal();

  /// 当前是否使用模拟数据
  bool _useMock = true;

  /// 设置API模式
  ///
  /// [useMock] - 是否使用模拟数据
  /// [printLog] - 是否打印日志
  void setMode(bool useMock, {bool printLog = true}) {
    _useMock = useMock;

    if (printLog) {
      final mode = useMock ? '模拟数据 (Mock)' : '真实API (Real)';
      AppLogger.i('┌────── API模式 ──────');
      AppLogger.i('│ 当前模式: $mode');
      AppLogger.i('└────────────────────');
    }
  }

  /// 获取当前是否使用模拟数据
  bool get useMock => _useMock;

  /// 获取当前API模式描述
  String get modeDescription => _useMock ? '模拟数据 (Mock)' : '真实API (Real)';

  /// 打印当前API模式
  void printCurrentMode() {
    AppLogger.i('┌────── API模式 ──────');
    AppLogger.i('│ 当前模式: $modeDescription');
    AppLogger.i('└────────────────────');
  }
}
