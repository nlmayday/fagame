import 'package:fagame/core/error/app_exception.dart';
import 'package:fagame/core/error/business_exceptions.dart';
import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// 执行登录操作
  ///
  /// 参数:
  /// [email] - 用户邮箱
  /// [password] - 用户密码
  /// 返回:
  /// 登录成功后返回Token对象
  /// 异常:
  /// 可能抛出[NetworkException]或[BusinessException]
  Future<Token> execute(String email, String password) async {
    if (email.isEmpty) {
      throw BusinessException('emailRequired');
    }

    if (password.isEmpty) {
      throw BusinessException('passwordRequired');
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
      return await repository.login(email, password);
    } catch (e) {
      if (e is BusinessException) {
        rethrow;
      }
      throw BusinessException('loginFailed', originalException: e);
    }
  }
}
