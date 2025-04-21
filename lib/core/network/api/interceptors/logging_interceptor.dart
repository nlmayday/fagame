import 'package:dio/dio.dart';
import 'package:fagame/core/utils/logger.dart';

/// 网络请求日志拦截器
///
/// 用于记录网络请求和响应的详细信息，便于调试
class LoggingInterceptor extends Interceptor {
  final bool logRequestBody;
  final bool logResponseBody;

  LoggingInterceptor({this.logRequestBody = true, this.logResponseBody = true});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.i('┌────── HTTP Request ──────');
    AppLogger.i('│ ${options.method} ${options.uri}');
    AppLogger.i('│ Headers: ${options.headers}');

    if (logRequestBody && options.data != null) {
      try {
        AppLogger.i('│ Body: ${_formatData(options.data)}');
      } catch (e) {
        AppLogger.i('│ Body: [无法序列化]');
      }
    }

    AppLogger.i('└────────────────────────');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i('┌────── HTTP Response ──────');
    AppLogger.i('│ ${response.statusCode} ${response.requestOptions.uri}');
    AppLogger.i('│ Headers: ${response.headers.map}');

    if (logResponseBody && response.data != null) {
      try {
        AppLogger.i('│ Body: ${_formatData(response.data)}');
      } catch (e) {
        AppLogger.i('│ Body: [无法序列化]');
      }
    }

    AppLogger.i('└────────────────────────');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e('┌────── HTTP Error ──────');
    AppLogger.e('│ ${err.type.toString()}');
    AppLogger.e('│ ${err.requestOptions.method} ${err.requestOptions.uri}');

    if (err.response != null) {
      AppLogger.e('│ Status: ${err.response!.statusCode}');
      if (err.response!.data != null) {
        try {
          AppLogger.e('│ Error Body: ${_formatData(err.response!.data)}');
        } catch (e) {
          AppLogger.e('│ Error Body: [无法序列化]');
        }
      }
    } else {
      AppLogger.e('│ Message: ${err.message}');
    }

    AppLogger.e('└────────────────────────');

    handler.next(err);
  }

  /// 格式化数据，控制长度并处理不同数据类型
  String _formatData(dynamic data) {
    if (data == null) return 'null';

    String text;
    if (data is Map || data is List) {
      // 尝试将Map或List转换为字符串
      text = data.toString();
    } else {
      // 其他类型直接转字符串
      text = data.toString();
    }

    // 如果内容太长，截断显示
    if (text.length > 500) {
      text = '${text.substring(0, 500)}... (${text.length} chars)';
    }

    return text;
  }
}
