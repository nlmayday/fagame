import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/common/widgets/layouts/main_layout.dart';
import 'package:fagame/core/router/auth_guard.dart';
import 'package:fagame/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:fagame/features/auth/presentation/pages/login_page.dart';
import 'package:fagame/features/auth/presentation/pages/register_page.dart';
import 'package:fagame/features/user/presentation/pages/profile_page.dart';

/// 创建应用的路由配置
GoRouter createRouter({GlobalKey<NavigatorState>? navigatorKey}) {
  // 创建认证守卫
  final authGuard = AuthGuard();

  return GoRouter(
    // 使用传入的导航键
    navigatorKey: navigatorKey,

    // 初始路由
    initialLocation: '/login',

    // 重定向处理
    redirect: (context, state) async {
      // 使用认证守卫处理重定向
      return await authGuard.handleRedirect(context, state);
    },

    // 路由配置
    routes: [
      // 登录页面
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // 注册页面
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // 忘记密码页面
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // 主页路由 - 不需要登录
      GoRoute(
        path: '/',
        name: 'home',
        builder:
            (context, state) => const MainLayout(
              currentIndex: 0,
              child: Scaffold(body: Center(child: Text('首页'))),
            ),
      ),

      // 个人资料页面 - 需要登录
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder:
            (context, state) =>
                const MainLayout(currentIndex: 3, child: ProfilePage()),
      ),

      // 游戏大厅 - 需要登录
      GoRoute(
        path: '/lobby',
        name: 'lobby',
        builder:
            (context, state) => const MainLayout(
              currentIndex: 1,
              child: Scaffold(body: Center(child: Text('游戏大厅'))),
            ),
      ),

      // 游戏页面 - 需要登录
      GoRoute(
        path: '/game/:id',
        name: 'game',
        builder: (context, state) {
          final gameId = state.pathParameters['id'] ?? '';
          return MainLayout(
            currentIndex: 2,
            child: Scaffold(body: Center(child: Text('游戏页面 - ID: $gameId'))),
          );
        },
      ),
    ],

    // 错误页面
    errorBuilder:
        (context, state) =>
            Scaffold(body: Center(child: Text('页面不存在: ${state.uri.path}'))),
  );
}
