import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fagame/core/localization/app_localizations.dart';

typedef LoginCallback = void Function(String email, String password);

class LoginForm extends StatefulWidget {
  final LoginCallback onLogin;

  const LoginForm({Key? key, required this.onLogin}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
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
          // 邮箱输入框
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email,
              prefixIcon: const Icon(Icons.email),
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.emailRequired;
              }

              // 简单的邮箱验证
              final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
              if (!emailRegex.hasMatch(value)) {
                return l10n.invalidEmail;
              }

              return null;
            },
          ),
          const SizedBox(height: 16),

          // 密码输入框
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: l10n.password,
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
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

          // 忘记密码按钮
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // 跳转到忘记密码页面
                context.push('/forgot-password');
              },
              child: Text(l10n.forgotPassword),
            ),
          ),

          const SizedBox(height: 24),

          // 登录按钮
          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(l10n.login, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // 表单验证通过，调用登录回调
      widget.onLogin(_emailController.text, _passwordController.text);
    }
  }
}
