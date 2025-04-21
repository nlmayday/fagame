/// 应用异常基类
///
/// 所有自定义异常的基类，提供统一的错误处理机制
class AppException implements Exception {
  /// 错误码，通常对应国际化资源中的key
  final String errorCode;

  /// 错误消息
  final String? message;

  /// 原始异常
  final Object? originalException;

  /// 创建应用异常
  ///
  /// [errorCode] - 错误码，通常对应国际化资源中的key
  /// [message] - 错误消息，可选
  /// [originalException] - 原始异常，可选
  AppException(this.errorCode, {this.message, this.originalException});

  @override
  String toString() {
    if (message != null) {
      return '$errorCode: $message';
    }
    return errorCode;
  }
}
