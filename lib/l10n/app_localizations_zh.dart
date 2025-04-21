// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'FA 游戏';

  @override
  String get login => '登录';

  @override
  String get register => '注册';

  @override
  String get email => '邮箱';

  @override
  String get password => '密码';

  @override
  String get forgotPassword => '忘记密码？';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get loginFailed => '登录失败';

  @override
  String get emailRequired => '请输入邮箱';

  @override
  String get passwordRequired => '请输入密码';

  @override
  String get invalidEmail => '请输入有效的邮箱地址';

  @override
  String get passwordTooShort => '密码至少需要6个字符';

  @override
  String get networkError => '网络错误，请重试';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get loading => '加载中...';

  @override
  String get retry => '重试';

  @override
  String get invalidCredentials => '用户名或密码错误';

  @override
  String get username => '用户名';

  @override
  String get usernameRequired => '请输入用户名';

  @override
  String get registerSuccess => '注册成功，请登录';

  @override
  String get confirmPassword => '确认密码';

  @override
  String get passwordsDoNotMatch => '两次输入的密码不一致';

  @override
  String get registerFailed => '注册失败';

  @override
  String get resetPassword => '重置密码';

  @override
  String get resetPasswordInstructions => '我们将向您的邮箱发送验证码以重置密码。';

  @override
  String get sendVerificationCode => '发送验证码';

  @override
  String get verifyAndResetPassword => '验证并重置密码';

  @override
  String get verificationCode => '验证码';

  @override
  String get newPassword => '新密码';

  @override
  String get verificationCodeRequired => '请输入验证码';

  @override
  String get verificationCodeSent => '验证码已发送到您的邮箱';

  @override
  String get backToLogin => '返回登录';

  @override
  String get resetPasswordFailed => '重置密码失败';

  @override
  String get verificationCodeInvalid => '验证码无效';

  @override
  String get passwordResetSuccess => '密码重置成功，请登录';

  @override
  String get language => '语言';

  @override
  String get english => '英文';

  @override
  String get chinese => '中文';
}
