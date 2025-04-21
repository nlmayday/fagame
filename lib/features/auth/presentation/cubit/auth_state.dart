import 'package:equatable/equatable.dart';
import 'package:fagame/features/auth/domain/entities/user_entity.dart';

/// 认证状态的基类
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// 初始状态
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// 加载中状态
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// 已认证状态
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  List<Object> get props => [user];
}

/// 未认证状态
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// 认证错误状态
class AuthError extends AuthState {
  final String errorCode;
  final String? message;

  const AuthError(this.errorCode, {this.message});

  @override
  List<Object?> get props => [errorCode, message];
}
