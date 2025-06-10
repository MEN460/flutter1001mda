import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';
import 'dart:convert';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

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

      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw Exception(_parseError(e));
    }
  }

  Future<UserModel> login(String loginId, String password) async {
    try {
      final response = await _apiService.post('/auth/login', {
        'login_id': loginId,
        'password': password,
      });

      if (response == null || response['user'] == null) {
        throw Exception('Login failed: Invalid response');
      }

      await _storageService.saveTokens(
        response['access_token'],
        response['refresh_token'],
      );

      return UserModel.fromJson(response['user']);
    } catch (e) {
      throw Exception(_parseError(e));
    }
  }

  Future<void> logout() async {
    await _storageService.deleteTokens();
  }

  /// Utility: Parses exceptions to extract clean error messages
  String _parseError(Object error) {
    try {
      final raw = error.toString();
      final startIndex = raw.indexOf('{');
      if (startIndex != -1) {
        final jsonPart = jsonDecode(raw.substring(startIndex));
        return jsonPart['message'] ?? jsonPart['error'] ?? raw;
      }
      return raw;
    } catch (_) {
      return error.toString();
    }
  }
}
