import 'package:fagame/core/error/business_exceptions.dart';
import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/repository.dart';

class RegisterUseCase {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  /// 执行注册操作
  ///
  /// 参数:
  /// [email] - 用户邮箱
  /// [password] - 用户密码
  /// [username] - 用户名
  /// 返回:
  /// 注册成功后返回Token对象
  Future<Token> execute(String email, String password, String username) async {
    if (email.isEmpty) {
      throw BusinessException('emailRequired');
    }

    if (password.isEmpty) {
      throw BusinessException('passwordRequired');
    }

    if (username.isEmpty) {
      throw BusinessException('usernameRequired');
    }

    // 简单的邮箱验证
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      throw BusinessException('invalidEmail');
    }

    if (password.length < 6) {
      throw BusinessException('passwordTooShort');
    }

    try {
      return await repository.register(email, password, username);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('registerFailed', originalException: e);
    }
  }
}
