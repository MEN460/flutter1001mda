import 'dart:convert';

import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  /// You can inject mocks or defaults will be created if omitted.
  AuthService({ApiService? apiService, StorageService? storageService})
    : _apiService = apiService ?? ApiService(),
      _storageService = storageService ?? StorageService();

  /// Registers a new user and saves tokens on success.
  Future<UserModel> register(
    String username,
    String email,
    String password,
    String userType,
    String phone,
  ) async {
    try {
      final response = await _apiService.post('/auth/register', {
        'username': username,
        'email': email,
        'password': password,
        'user_type': userType,
        'phone': phone,
      });

      if (response == null || response['user'] == null) {
        final error = response?['error'] ?? 'Invalid response format';
        throw Exception('Registration failed: $error');
      }

      // Save tokens if returned alongside user
      if (response.containsKey('access_token') &&
          response.containsKey('refresh_token')) {
        await _storageService.saveTokens(
          response['access_token'],
          response['refresh_token'],
        );
      }

      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw Exception(_parseError(e));
    }
  }

  /// Logs in an existing user, saves tokens, and returns the user.
  Future<UserModel> login(String loginId, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'login_id': loginId,
        'password': password,
      });

      if (response == null || response['user'] == null) {
        throw Exception('Login failed: Invalid response');
      }

      // Always save tokens on login
      await _storageService.saveTokens(
        response['access_token'],
        response['refresh_token'],
      );

      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw Exception(_parseError(e));
    }
  }

  /// Logs out by removing stored tokens.
  Future<void> logout() async {
    await _storageService.deleteTokens();
  }

  /// Parses thrown errors to extract JSON 'message' or 'error' fields if present.
  String _parseError(Object error) {
    final raw = error.toString();
    final jsonStart = raw.indexOf('{');
    if (jsonStart != -1) {
      try {
        final decoded = jsonDecode(raw.substring(jsonStart));
        if (decoded is Map) {
          return decoded['message'] ?? decoded['error'] ?? raw;
        }
      } catch (_) {}
    }
    return raw;
  }
}
