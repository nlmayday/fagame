import 'package:flutter/material.dart';
import 'package:fagame/core/localization/app_localizations.dart';
import 'package:fagame/core/utils/logger.dart';

typedef SendVerificationCodeCallback = void Function(String email);
typedef VerifyAndResetCallback =
    void Function(String email, String code, String newPassword);

class ForgotPasswordForm extends StatefulWidget {
  final SendVerificationCodeCallback onSendResetLink;
  final VerifyAndResetCallback onVerifyAndReset;
  final bool codeSent;

  const ForgotPasswordForm({
    Key? key,
    required this.onSendResetLink,
    required this.onVerifyAndReset,
    this.codeSent = false,
  }) : super(key: key);

  @override
  State<ForgotPasswordForm> createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool get _codeSent => widget.codeSent;

  // 保存最后一次发送验证码的邮箱
  String _lastEmailUsedForVerification = '';

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 说明文字
          Text(
            l10n.resetPasswordInstructions,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),

          // 邮箱输入框
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
            ),
            enabled: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emailRequired;
              }

              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return l10n.invalidEmail;
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          if (!_codeSent)
            // 发送验证码按钮
            ElevatedButton(
              onPressed: _sendVerificationCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                l10n.sendVerificationCode,
                style: const TextStyle(fontSize: 16),
              ),
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 验证码输入框
                TextFormField(
                  controller: _codeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.verificationCode,
                    prefixIcon: const Icon(Icons.pin),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.verificationCodeRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 新密码输入框
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.newPassword,
                    prefixIcon: const Icon(Icons.lock),
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.passwordTooShort;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // 验证并重置密码按钮
                ElevatedButton(
                  onPressed: _verifyAndResetPassword,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    l10n.verifyAndResetPassword,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _sendVerificationCode() {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      AppLogger.i('发送验证码到: $email');
      // 保存发送验证码的邮箱
      _lastEmailUsedForVerification = email;
      // 表单验证通过，调用回调
      widget.onSendResetLink(email);
    }
  }

  void _verifyAndResetPassword() {
    if (_formKey.currentState!.validate()) {
      // 使用最后一次发送验证码的邮箱或当前输入的邮箱
      final email =
          _lastEmailUsedForVerification.isNotEmpty
              ? _lastEmailUsedForVerification
              : _emailController.text;

      AppLogger.i('验证码重置密码: $email, 验证码: ${_codeController.text}');
      // 表单验证通过，调用回调
      widget.onVerifyAndReset(
        email,
        _codeController.text,
        _passwordController.text,
      );
    }
  }
}
