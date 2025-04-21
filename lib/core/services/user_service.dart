import 'dart:convert';

import 'package:fagame/core/services/storage/storage_service.dart';
import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/models/user.dart';
import 'package:fagame/features/auth/domain/entities/user_entity.dart';

/// 用户信息服务，提供全局访问和管理用户信息
class UserService {
  /// 单例实例
  static final UserService _instance = UserService._internal();

  /// 获取单例实例
  factory UserService() => _instance;

  UserService._internal();

  final StorageService _storage = StorageService();
  static const String _userKey = 'current_user';
  static const String _tokenKey = 'auth_token';

  User? _currentUser;
  Token? _token;

  /// 获取当前用户，如果未登录返回null
  Future<User?> getCurrentUser() async {
    if (_currentUser != null) {
      return _currentUser;
    }

    // 尝试从存储加载用户
    final userData = await _storage.read(_userKey);
    if (userData != null && userData.isNotEmpty) {
      try {
        final json = jsonDecode(userData);
        _currentUser = User.fromJson(json);
        return _currentUser;
      } catch (e) {
        // 解析失败，清除无效数据
        await _storage.delete(_userKey);
      }
    }

    return null;
  }

  /// 获取当前认证令牌
  Future<Token?> getToken() async {
    if (_token != null) {
      return _token;
    }

    // 尝试从存储加载令牌
    final tokenData = await _storage.read(_tokenKey);
    if (tokenData != null && tokenData.isNotEmpty) {
      try {
        final json = jsonDecode(tokenData);
        _token = Token.fromJson(json);
        return _token;
      } catch (e) {
        // 解析失败，清除无效数据
        await _storage.delete(_tokenKey);
      }
    }

    return null;
  }

  /// 保存用户信息和认证令牌
  Future<void> saveUserAndToken(User user, Token token) async {
    // 保存用户信息
    _currentUser = user;
    final userData = jsonEncode(user.toJson());
    await _storage.write(_userKey, userData);

    // 保存令牌
    _token = token;
    final tokenData = jsonEncode(token.toJson());
    await _storage.write(_tokenKey, tokenData);
  }

  /// 保存用户信息
  Future<void> saveUser(User user) async {
    _currentUser = user;
    final userData = jsonEncode(user.toJson());
    await _storage.write(_userKey, userData);
  }

  /// 保存令牌
  Future<void> saveToken(Token token) async {
    _token = token;
    final tokenData = jsonEncode(token.toJson());
    await _storage.write(_tokenKey, tokenData);
  }

  /// 清除用户信息
  Future<void> clearUser() async {
    _currentUser = null;
    _token = null;
    await _storage.delete(_userKey);
    await _storage.delete(_tokenKey);
  }

  /// 将数据层User转换为领域层UserEntity
  UserEntity toEntity(User user) {
    return UserEntity(
      id: user.id,
      email: user.email,
      username: user.username,
      avatarUrl: user.avatarUrl,
    );
  }

  /// 检查用户是否已登录
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    // 同时验证token是否存在
    final token = await getToken();
    return user != null && token != null;
  }
}
