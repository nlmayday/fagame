import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/utils/logger.dart';
import 'package:fagame/features/auth/presentation/widgets/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.register)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // 应用Logo
            Icon(Icons.games, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(
              l10n.appTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),
            // 注册表单
            RegisterForm(
              onRegister: (username, email, password) {
                _handleRegister(context, username, email, password);
              },
            ),
            const SizedBox(height: 16),
            // 登录链接
            TextButton(
              onPressed: () {
                // 导航到登录页面
                context.pushReplacement('/login');
              },
              child: Text(l10n.login),
            ),
          ],
        ),
      ),
    );
  }

  /// 处理注册
  void _handleRegister(
    BuildContext context,
    String username,
    String email,
    String password,
  ) {
    // TODO: 实现注册逻辑，可以使用RegisterCubit
    final l10n = AppLocalizations.of(context);

    AppLogger.i('处理用户注册: $username, $email');

    // 模拟注册成功
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.registerSuccess)));

    // 注册成功后跳转到登录页
    Future.delayed(const Duration(seconds: 1), () {
      context.pushReplacement('/login');
    });
  }
}
