import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/services/user_service.dart';
import 'package:fagame/core/widgets/dialogs/token_expired_dialog.dart';

/// 认证拦截器
///
/// 处理请求认证相关的逻辑，包括：
/// 1. 添加认证头
/// 2. 处理认证错误（如token过期）
class AuthInterceptor extends Interceptor {
  final UserService _userService;
  final GlobalKey<NavigatorState> navigatorKey;

  // 用于防止多个请求同时触发token过期对话框
  bool _isShowingTokenExpiredDialog = false;

  AuthInterceptor({required this.navigatorKey, UserService? userService})
    : _userService = userService ?? UserService();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 检查是否登录并添加认证头
    final isLoggedIn = await _userService.isLoggedIn();
    if (isLoggedIn) {
      final token = await _userService.getToken();
      if (token != null) {
        options.headers['Authorization'] =
            '${token.tokenType} ${token.accessToken}';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 检查是否是认证错误（401 - Unauthorized）
    if (err.response?.statusCode == 401) {
      // 检查详细错误码，确认是否是token过期
      final data = err.response?.data;
      final errorCode = data is Map ? data['error_code'] : null;

      // 如果是token过期，显示对话框并跳转到登录页面
      if (errorCode == 'token_expired' || errorCode == 'invalid_token') {
        _handleTokenExpired();
        // 不继续传递错误，而是返回特定的错误响应
        return handler.resolve(
          Response(
            requestOptions: err.requestOptions,
            statusCode: 401,
            data: {'error': 'Session expired'},
          ),
        );
      }
    }

    // 其他错误正常传递
    return handler.next(err);
  }

  /// 处理token过期的情况
  Future<void> _handleTokenExpired() async {
    // 防止多个请求同时触发对话框
    if (_isShowingTokenExpiredDialog) return;

    try {
      _isShowingTokenExpiredDialog = true;

      // 获取当前context
      final context = navigatorKey.currentContext;
      if (context == null) return;

      // 清除用户登录状态
      await _userService.clearUser();

      // 显示token过期对话框
      final result = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => const TokenExpiredDialog(),
      );

      // 如果用户点击确定，跳转到登录页面
      if (result == true && context.mounted) {
        // 使用go_router导航到登录页面
        context.go('/login');
      }
    } finally {
      _isShowingTokenExpiredDialog = false;
    }
  }
}
