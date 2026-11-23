import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/token_storage.dart';
import '../datasources/auth_remote_data_source.dart';

import 'package:dio/dio.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this._remoteDataSource,
    required this._tokenStorage,
  });
  final AuthRemoteDataSource _remoteDataSource;
  final TokenStorage _tokenStorage;

  @override
  Future<AuthUser> login({
    required String username,
    required String password,
  }) async {
    final response = await _remoteDataSource.login(
      username: username,
      password: password,
    );

    await _tokenStorage.saveToken(response.token);

    return AuthUser(
      email: response.email,
      nicename: response.nicename,
      displayName: response.displayName,
    );
  }

  @override
  Future<AuthUser?> restoreSession() async {
    final token = await _tokenStorage.readToken();

    if (token == null || token.trim().isEmpty) {
      return null;
    }

    try {
      final data = await _remoteDataSource.getCurrentUser();

      final userData = data['user'] is Map
          ? Map<String, dynamic>.from(data['user'] as Map)
          : data;

      final hasIdentity = [
        'id',
        'user_id',
        'email',
        'user_email',
        'display_name',
        'name',
        'roles',
      ].any((key) => userData.containsKey(key));

      if (!hasIdentity) {
        throw const FormatException('صيغة بيانات الحساب غير متوقعة.');
      }

      final rolesValue = userData['roles'];

      final roles = rolesValue is List
          ? rolesValue.map((role) => role.toString()).toList()
          : <String>[];

      String getString(List<String> keys) {
        for (final key in keys) {
          final value = userData[key];
          if (value != null && value.toString().trim().isNotEmpty) {
            return value.toString();
          }
        }
        return '';
      }

      return AuthUser(
        email: getString(['email', 'user_email']),
        nicename: getString(['nicename', 'user_nicename', 'username', 'name']),
        displayName: getString(['display_name', 'displayName', 'name']),
        roles: roles,
      );
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        await _tokenStorage.deleteToken();
        return null;
      }

      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _remoteDataSource.logout();
    } finally {
      await _tokenStorage.deleteToken();
    }
  }
}
