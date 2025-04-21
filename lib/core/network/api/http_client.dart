import 'package:dio/dio.dart';

/// HTTP客户端工具类，提供创建和配置Dio实例的方法
class HttpClient {
  /// 创建基本的Dio HTTP客户端
  ///
  /// 参数:
  /// [baseUrl] - API基础URL
  /// [connectTimeout] - 连接超时时间，默认10秒
  /// [receiveTimeout] - 接收超时时间，默认10秒
  /// [interceptors] - 拦截器列表，可选
  ///
  /// 返回:
  /// 配置好的Dio实例
  static Dio createDio({
    required String baseUrl,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
    List<Interceptor>? interceptors,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: connectTimeout,
      receiveTimeout: receiveTimeout,
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    final dio = Dio(options);

    // 添加拦截器
    if (interceptors != null) {
      dio.interceptors.addAll(interceptors);
    }

    return dio;
  }

  /// 创建文件上传专用客户端，配置更长的超时时间
  ///
  /// 参数:
  /// [baseUrl] - API基础URL
  /// [interceptors] - 拦截器列表，可选
  ///
  /// 返回:
  /// 配置好的文件上传专用Dio实例
  static Dio createUploadDio({
    required String baseUrl,
    List<Interceptor>? interceptors,
  }) {
    return createDio(
      baseUrl: baseUrl,
      connectTimeout: const Duration(minutes: 5),
      receiveTimeout: const Duration(minutes: 5),
      interceptors: interceptors,
    );
  }
}
