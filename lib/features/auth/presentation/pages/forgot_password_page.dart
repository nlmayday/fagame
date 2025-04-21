import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/utils/logger.dart';
import 'package:fagame/features/auth/presentation/widgets/forgot_password_form.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  bool _isLoading = false;
  bool _codeSent = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetPassword)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            // 应用Logo
            Icon(
              Icons.lock_reset,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.resetPassword,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),

            if (_isLoading)
              // 加载状态
              const Center(child: CircularProgressIndicator())
            else
              // 表单状态
              ForgotPasswordForm(
                onSendResetLink: _handleSendVerificationCode,
                onVerifyAndReset: _handleVerifyAndReset,
                codeSent: _codeSent,
              ),

            // 提示消息：验证码已发送
            if (_codeSent && !_isLoading)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.verificationCodeSent,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

            // 错误消息
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                  textAlign: TextAlign.center,
                ),
              ),

            const SizedBox(height: 16),
            // 返回登录按钮
            TextButton(
              onPressed: () {
                context.go('/login');
              },
              child: Text(l10n.backToLogin),
            ),
          ],
        ),
      ),
    );
  }

  // 处理发送验证码
  Future<void> _handleSendVerificationCode(String email) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 模拟发送验证码
      AppLogger.i('发送验证码到邮箱: $email');
      await Future.delayed(const Duration(seconds: 2));

      // 模拟成功
      setState(() {
        _isLoading = false;
        _codeSent = true;
      });
    } catch (e) {
      // 处理错误
      AppLogger.e('发送验证码失败: {0}', [e]);
      final l10n = AppLocalizations.of(context);

      setState(() {
        _isLoading = false;
        _errorMessage = l10n.resetPasswordFailed;
      });
    }
  }

  // 处理验证和重置密码
  Future<void> _handleVerifyAndReset(
    String email,
    String code,
    String newPassword,
  ) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // 模拟验证和重置密码
      AppLogger.i(
        '验证码重置密码: $email, 验证码: $code, 新密码: ${newPassword.replaceAll(RegExp(r'.'), '*')}',
      );
      await Future.delayed(const Duration(seconds: 2));

      // 模拟成功 - 导航到登录页
      setState(() {
        _isLoading = false;
      });

      if (!context.mounted) return;

      // 显示成功消息
      final l10n = AppLocalizations.of(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.passwordResetSuccess)));

      // 导航回登录页
      Future.delayed(const Duration(milliseconds: 500), () {
        if (!context.mounted) return;
        context.go('/login');
      });
    } catch (e) {
      // 处理错误
      AppLogger.e('重置密码失败: {0}', [e]);
      final l10n = AppLocalizations.of(context);

      setState(() {
        _isLoading = false;
        _errorMessage = l10n.resetPasswordFailed;
      });
    }
  }
}
