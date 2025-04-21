import 'package:fagame/core/error/app_exception.dart';

/// 网络异常类
///
/// 用于表示网络请求过程中发生的错误
class NetworkException extends AppException {
  /// 创建网络异常
  ///
  /// [errorCode] - 错误码，通常对应国际化资源中的key
  /// [message] - 错误消息，可选
  /// [originalException] - 原始异常，可选
  NetworkException(
    String errorCode, {
    String? message,
    Object? originalException,
  }) : super(errorCode, message: message, originalException: originalException);
}
