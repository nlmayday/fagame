import 'package:fagame/core/error/app_exception.dart';

/// 业务逻辑异常
///
/// 用于表示业务规则验证失败、业务操作失败等情况
class BusinessException extends AppException {
  /// 创建业务异常
  ///
  /// [errorCode] - 错误码，通常对应国际化资源中的key
  /// [message] - 错误消息，可选
  /// [originalException] - 原始异常，可选
  BusinessException(
    String errorCode, {
    String? message,
    Object? originalException,
  }) : super(errorCode, message: message, originalException: originalException);
}
