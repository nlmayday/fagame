import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:fagame/core/config/environment.dart';
import 'package:fagame/core/network/api/http_client.dart';
import 'package:fagame/core/network/api/interceptors/auth_interceptor.dart';
import 'package:fagame/core/network/api/interceptors/logging_interceptor.dart';
import 'package:fagame/core/services/api_mode_service.dart';
import 'package:fagame/core/services/storage/storage_service.dart';
import 'package:fagame/core/services/user_service.dart';
import 'package:fagame/core/services/locale_service.dart';

/// 初始化核心依赖
void initCoreDependencies(GetIt sl, {GlobalKey<NavigatorState>? navigatorKey}) {
  // 存储服务
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // 用户服务
  sl.registerLazySingleton<UserService>(() => UserService());

  // API模式服务
  sl.registerLazySingleton<ApiModeService>(() => ApiModeService());

  // 创建拦截器
  final authInterceptor = AuthInterceptor(
    navigatorKey: navigatorKey ?? GlobalKey<NavigatorState>(),
    userService: sl<UserService>(),
  );

  // 日志拦截器
  final loggingInterceptor = LoggingInterceptor();

  // 注册主要的HTTP客户端
  sl.registerLazySingleton<Dio>(() {
    final environment = sl<Environment>();

    // 设置API模式并打印
    sl<ApiModeService>().setMode(environment.useMock);

    return HttpClient.createDio(
      baseUrl: environment.baseUrl,
      interceptors: [authInterceptor, loggingInterceptor],
    );
  });

  // 注册文件上传专用HTTP客户端
  sl.registerLazySingleton<Dio>(() {
    final environment = sl<Environment>();
    return HttpClient.createUploadDio(
      baseUrl: environment.baseUrl,
      interceptors: [authInterceptor, loggingInterceptor],
    );
  }, instanceName: 'uploadDio');

  // 添加LocaleService
  sl.registerLazySingleton<LocaleService>(() => LocaleService());
}
