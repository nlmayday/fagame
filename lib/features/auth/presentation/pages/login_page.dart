import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/utils/logger.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_state.dart';
import 'package:fagame/features/auth/presentation/widgets/language_selector.dart';
import 'package:fagame/features/auth/presentation/widgets/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
        actions: const [
          // 添加语言选择器按钮
          LanguageSelector(isDense: true),
          SizedBox(width: 8),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // 登录成功时调用登录成功处理方法
            _onLoginSuccess(context);
          } else if (state is AuthError) {
            // 显示错误消息
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  _getErrorMessage(context, state.errorCode, state.message),
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // 应用Logo
                  Icon(
                    Icons.games,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.appTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 40),
                  // 登录表单
                  LoginForm(
                    onLogin: (email, password) {
                      context.read<AuthCubit>().login(email, password);
                    },
                  ),
                  const SizedBox(height: 16),
                  // 注册按钮
                  TextButton(
                    onPressed: () {
                      context.push('/register');
                    },
                    child: Text(l10n.register),
                  ),
                  // 语言选择行
                  Padding(
                    padding: const EdgeInsets.only(top: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [LanguageSelector()],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getErrorMessage(
    BuildContext context,
    String? errorCode,
    String? message,
  ) {
    final l10n = AppLocalizations.of(context);

    // 如果错误码为空，直接返回消息或未知错误
    if (errorCode == null) {
      return message ?? l10n.unknownError;
    }

    // 根据错误码返回本地化消息
    switch (errorCode) {
      case 'loginFailed':
        return l10n.loginFailed;
      case 'invalidCredentials':
        return l10n.invalidCredentials;
      case 'emailRequired':
        return l10n.emailRequired;
      case 'passwordRequired':
        return l10n.passwordRequired;
      case 'invalidEmail':
        return l10n.invalidEmail;
      case 'passwordTooShort':
        return l10n.passwordTooShort;
      case 'networkError':
        return l10n.networkError;
      default:
        // 如果有提供消息则使用，否则返回未知错误
        return message ?? l10n.unknownError;
    }
  }

  /// 登录成功后处理导航
  void _onLoginSuccess(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // 显示登录成功消息
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.loginSuccess)));

    AppLogger.i('登录成功，准备导航到首页');

    // 确保UI更新后再导航
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!context.mounted) {
        AppLogger.e('上下文已不再挂载，无法导航');
        return;
      }

      try {
        AppLogger.d('尝试使用GoRouter导航到首页');
        context.go('/');
        AppLogger.i('导航命令已执行');
      } catch (e) {
        AppLogger.e('GoRouter导航失败: {0}', [e]);
        try {
          AppLogger.d('尝试使用Navigator导航');
          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
        } catch (e) {
          AppLogger.e('Navigator导航也失败: {0}', [e]);
        }
      }
    });
  }
}
