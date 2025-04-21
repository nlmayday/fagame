import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fagame/core/error/business_exceptions.dart';
import 'package:fagame/core/error/network_exceptions.dart';
import 'package:fagame/core/services/user_service.dart';
import 'package:fagame/features/auth/domain/entities/user_entity.dart';
import 'package:fagame/features/auth/domain/usecases/login_usecase.dart';
import 'package:fagame/features/auth/domain/usecases/logout_usecase.dart';
import 'package:fagame/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final UserService _userService = UserService();

  AuthCubit({required this.loginUseCase, required this.logoutUseCase})
    : super(const AuthInitial());

  /// 初始化
  ///
  /// 检查用户是否已登录，并获取用户信息
  Future<void> checkAuthStatus() async {
    try {
      emit(const AuthLoading());

      final isLoggedIn = await _userService.isLoggedIn();

      if (isLoggedIn) {
        final user = await _userService.getCurrentUser();
        if (user != null) {
          emit(AuthAuthenticated(_userService.toEntity(user)));
        } else {
          emit(const AuthUnauthenticated());
        }
      } else {
        emit(const AuthUnauthenticated());
      }
    } catch (e) {
      emit(const AuthUnauthenticated());
    }
  }

  /// 登录
  ///
  /// 参数:
  /// [email] - 用户邮箱
  /// [password] - 用户密码
  Future<void> login(String email, String password) async {
    try {
      emit(const AuthLoading());

      // 登录并获取token
      final token = await loginUseCase.execute(email, password);

      // 获取用户信息
      final user = await logoutUseCase.repository.getCurrentUser();

      // 保存用户信息和token到本地存储
      await _userService.saveUserAndToken(user, token);

      // 更新状态
      emit(AuthAuthenticated(_userService.toEntity(user)));
    } on BusinessException catch (e) {
      emit(AuthError(e.errorCode, message: e.message));
    } on NetworkException catch (e) {
      emit(AuthError('networkError', message: e.message));
    } catch (e) {
      emit(const AuthError('unknownError'));
    }
  }

  /// 退出登录
  Future<void> logout() async {
    try {
      emit(const AuthLoading());

      // 调用登出API
      await logoutUseCase.execute();

      // 清除本地用户信息
      await _userService.clearUser();

      emit(const AuthUnauthenticated());
    } catch (e) {
      // 即使退出失败，我们也将状态设置为未认证
      await _userService.clearUser();
      emit(const AuthUnauthenticated());
    }
  }
}
