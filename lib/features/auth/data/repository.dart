import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/models/user.dart';

abstract class AuthRepository {
  /// 登录
  ///
  /// 参数:
  /// [email] - 用户邮箱
  /// [password] - 用户密码
  /// 返回:
  /// 登录成功后返回Token对象
  Future<Token> login(String email, String password);

  /// 注册
  ///
  /// 参数:
  /// [email] - 用户邮箱
  /// [password] - 用户密码
  /// [username] - 用户名
  /// 返回:
  /// 注册成功后返回Token对象
  Future<Token> register(String email, String password, String username);

  /// 获取当前用户信息
  ///
  /// 返回:
  /// 返回当前登录用户的信息
  Future<User> getCurrentUser();

  /// 退出登录
  ///
  /// 返回:
  /// 无返回值
  Future<void> logout();

  /// 是否已登录
  ///
  /// 返回:
  /// 如果当前已登录返回true，否则返回false
  Future<bool> isLoggedIn();
}
