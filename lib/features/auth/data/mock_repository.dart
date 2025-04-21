import 'dart:async';

import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/models/user.dart';
import 'package:fagame/features/auth/data/repository.dart';

class MockAuthRepository implements AuthRepository {
  bool _isLoggedIn = false;
  Token? _token;
  User? _currentUser;

  @override
  Future<User> getCurrentUser() async {
    if (!_isLoggedIn) {
      throw Exception('User not logged in');
    }

    return _currentUser ??
        User(
          id: 'mock-user-id',
          email: 'user@example.com',
          username: 'TestUser',
          avatarUrl: 'https://via.placeholder.com/150',
          createdAt: DateTime.now().subtract(const Duration(days: 30)),
          updatedAt: DateTime.now(),
        );
  }

  @override
  Future<bool> isLoggedIn() async {
    return _isLoggedIn;
  }

  @override
  Future<Token> login(String email, String password) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 简单验证
    if (email != '123456@qq.com' || password != '123456') {
      throw Exception('Invalid credentials');
    }

    // 创建模拟Token和User
    _token = Token(
      accessToken: 'mock-access-token-${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock-refresh-token',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );

    _currentUser = User(
      id: 'mock-user-id',
      email: email,
      username: 'TestUser',
      avatarUrl: 'https://via.placeholder.com/150',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now(),
    );

    _isLoggedIn = true;
    return _token!;
  }

  @override
  Future<void> logout() async {
    _isLoggedIn = false;
    _token = null;
    _currentUser = null;
  }

  @override
  Future<Token> register(String email, String password, String username) async {
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));

    // 模拟邮箱已存在的情况
    if (email == 'user@example.com') {
      throw Exception('Email already exists');
    }

    // 创建模拟Token和User
    _token = Token(
      accessToken: 'mock-access-token-${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock-refresh-token',
      tokenType: 'Bearer',
      expiresIn: 3600,
    );

    _currentUser = User(
      id: 'mock-user-id-${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      username: username,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    _isLoggedIn = true;
    return _token!;
  }
}
