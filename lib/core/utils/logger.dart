/// 日志工具类
///
/// 用于打印不同级别的调试信息，简单包装print函数
class AppLogger {
  /// 是否启用日志
  static bool enabled = true;

  /// 是否显示时间戳
  static bool showTimestamp = true;

  /// 日志级别
  static const String _debugPrefix = '[DEBUG]';
  static const String _infoPrefix = '[INFO]';
  static const String _warningPrefix = '[WARN]';
  static const String _errorPrefix = '[ERROR]';

  /// 获取当前时间戳
  static String _getTimestamp() {
    return showTimestamp ? '${DateTime.now()} ' : '';
  }

  /// 打印调试级别日志
  static void d(dynamic message, [List<dynamic>? args]) {
    if (enabled) {
      _print(_debugPrefix, message, args);
    }
  }

  /// 打印信息级别日志
  static void i(dynamic message, [List<dynamic>? args]) {
    if (enabled) {
      _print(_infoPrefix, message, args);
    }
  }

  /// 打印警告级别日志
  static void w(dynamic message, [List<dynamic>? args]) {
    if (enabled) {
      _print(_warningPrefix, message, args);
    }
  }

  /// 打印错误级别日志
  static void e(dynamic message, [List<dynamic>? args]) {
    if (enabled) {
      _print(_errorPrefix, message, args);
    }
  }

  /// 打印带标签的日志
  static void log(String tag, dynamic message, [List<dynamic>? args]) {
    if (enabled) {
      _print('[$tag]', message, args);
    }
  }

  /// 统一的打印方法
  static void _print(String prefix, dynamic message, List<dynamic>? args) {
    final timestamp = _getTimestamp();

    // 如果有额外参数，进行格式化
    if (args != null && args.isNotEmpty) {
      if (message is String) {
        // 尝试格式化字符串，类似于sprintf的功能
        print('$timestamp$prefix ${_formatString(message, args)}');
      } else {
        // 如果message不是字符串，直接打印
        print('$timestamp$prefix $message ${args.join(' ')}');
      }
    } else {
      // 没有参数，直接打印
      print('$timestamp$prefix $message');
    }
  }

  /// 简单的字符串格式化函数
  static String _formatString(String format, List<dynamic> args) {
    String result = format;
    for (var i = 0; i < args.length; i++) {
      result = result.replaceAll('{$i}', args[i].toString());
    }
    return result;
  }
}
