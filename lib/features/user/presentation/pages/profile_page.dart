import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/utils/logger.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthUnauthenticated) {
                // 退出登录成功后，导航到登录页面
                context.go('/login');
              }
            },
            builder: (context, state) {
              if (state is AuthAuthenticated) {
                final user = state.user;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // 用户信息卡片
                    Center(
                      child: Column(
                        children: [
                          // 头像
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                user.avatarUrl != null
                                    ? NetworkImage(user.avatarUrl!)
                                    : null,
                            child:
                                user.avatarUrl == null
                                    ? const Icon(Icons.person, size: 50)
                                    : null,
                          ),
                          const SizedBox(height: 16),
                          // 用户名
                          Text(
                            user.username,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          // 邮箱
                          Text(
                            user.email,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    // 菜单列表
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('设置'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // 导航到设置页面
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('帮助与反馈'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // 导航到帮助页面
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.info),
                      title: const Text('关于我们'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () {
                        // 导航到关于页面
                      },
                    ),
                    const Divider(),

                    // 退出登录按钮
                    const Spacer(),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _confirmLogout(context),
                        icon: const Icon(Icons.logout),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red[400],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(200, 45),
                        ),
                        label: const Text('退出登录'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              }

              // 默认显示加载中
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  /// 显示退出确认对话框
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('确认退出'),
            content: const Text('确定要退出登录吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _logout(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('退出'),
              ),
            ],
          ),
    );
  }

  /// 退出登录
  void _logout(BuildContext context) {
    AppLogger.i('用户点击退出登录');
    context.read<AuthCubit>().logout();
  }
}
