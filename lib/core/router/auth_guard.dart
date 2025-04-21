import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/services/user_service.dart';

/// 身份验证守卫
///
/// 用于拦截需要登录的路由，如果用户未登录则跳转到登录页面
class AuthGuard {
  final UserService _userService;
  final String loginRoute;

  /// 创建认证守卫
  ///
  /// [loginRoute] - 登录页面的路由路径
  AuthGuard({UserService? userService, this.loginRoute = '/login'})
    : _userService = userService ?? UserService();

  /// 检查用户是否已登录，未登录时重定向到登录页面
  ///
  /// 用于GoRouter中的redirect回调
  Future<String?> handleRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    // 获取当前路由路径
    final path = state.matchedLocation;

    // 如果已经在登录页面，不需要重定向
    if (path == loginRoute) {
      return null;
    }

    // 判断路由是否需要登录
    if (_isProtectedRoute(path)) {
      // 检查登录状态
      final isLoggedIn = await _userService.isLoggedIn();
      if (!isLoggedIn) {
        // 保存尝试访问的路径，登录后可以重定向回来
        return '$loginRoute?redirect=${Uri.encodeComponent(path)}';
      }
    }

    // 不需要重定向
    return null;
  }

  /// 异步检查用户是否已认证
  Future<bool> isAuthenticated() async {
    return await _userService.isLoggedIn();
  }

  /// 判断路由是否需要登录
  ///
  /// 可以根据项目需求自定义保护的路由
  bool _isProtectedRoute(String path) {
    // 需要登录才能访问的路由列表
    final protectedRoutes = ['/profile', '/settings', '/game', '/lobby'];

    // 检查路由是否在受保护列表中
    for (final route in protectedRoutes) {
      if (path.startsWith(route)) {
        return true;
      }
    }

    return false;
  }
}
