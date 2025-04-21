import 'package:dio/dio.dart';
import 'package:fagame/core/error/business_exceptions.dart';
import 'package:fagame/core/error/network_exceptions.dart';
import 'package:fagame/core/services/storage/storage_service.dart';
import 'package:fagame/features/auth/data/models/token.dart';
import 'package:fagame/features/auth/data/models/user.dart';
import 'package:fagame/features/auth/data/repository.dart';

/// 实际的身份验证仓库实现
class RealAuthRepository implements AuthRepository {
  final Dio httpClient;
  late final StorageService _storageService;

  static const String _tokenKey = 'auth_token';
  User? _cachedUser;

  RealAuthRepository({
    required this.httpClient,
    StorageService? storageService,
  }) {
    // 在实际项目中，通过DI注入StorageService
    _storageService = storageService ?? StorageService();
  }

  @override
  Future<User> getCurrentUser() async {
    if (_cachedUser != null) {
      return _cachedUser!;
    }

    final token = await _getToken();
    if (token == null) {
      throw BusinessException('userNotLoggedIn');
    }

    try {
      final response = await httpClient.get(
        '/api/users/me',
        options: Options(
          headers: {'Authorization': '${token.tokenType} ${token.accessToken}'},
        ),
      );

      final user = User.fromJson(response.data);
      _cachedUser = user;
      return user;
    } on DioException catch (e) {
      throw NetworkException(
        'fetchUserFailed',
        message: e.message,
        originalException: e,
      );
    } catch (e) {
      throw BusinessException('fetchUserFailed', originalException: e);
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  @override
  Future<Token> login(String email, String password) async {
    try {
      final response = await httpClient.post(
        '/api/auth/login',
        data: {'email': email, 'password': password},
      );

      final token = Token.fromJson(response.data);
      await _saveToken(token);

      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        throw BusinessException('invalidCredentials');
      }
      throw NetworkException(
        'loginFailed',
        message: e.message,
        originalException: e,
      );
    } catch (e) {
      throw BusinessException('loginFailed', originalException: e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await _getToken();
      if (token != null) {
        await httpClient.post(
          '/api/auth/logout',
          options: Options(
            headers: {
              'Authorization': '${token.tokenType} ${token.accessToken}',
            },
          ),
        );
      }
    } catch (e) {
      // 即使API调用失败，我们仍然清除本地令牌
    } finally {
      await _clearToken();
      _cachedUser = null;
    }
  }

  @override
  Future<Token> register(String email, String password, String username) async {
    try {
      final response = await httpClient.post(
        '/api/auth/register',
        data: {'email': email, 'password': password, 'username': username},
      );

      final token = Token.fromJson(response.data);
      await _saveToken(token);

      return token;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw BusinessException('emailAlreadyExists');
      }
      throw NetworkException(
        'registerFailed',
        message: e.message,
        originalException: e,
      );
    } catch (e) {
      throw BusinessException('registerFailed', originalException: e);
    }
  }

  /// 保存令牌到安全存储
  Future<void> _saveToken(Token token) async {
    await _storageService.write(_tokenKey, token.toJson().toString());
  }

  /// 获取存储的令牌
  Future<Token?> _getToken() async {
    final tokenData = await _storageService.read(_tokenKey);
    if (tokenData == null || tokenData.isEmpty) {
      return null;
    }

    try {
      final Map<String, dynamic> json = tokenData as Map<String, dynamic>;
      return Token.fromJson(json);
    } catch (e) {
      await _clearToken();
      return null;
    }
  }

  /// 清除存储的令牌
  Future<void> _clearToken() async {
    await _storageService.delete(_tokenKey);
  }
}
