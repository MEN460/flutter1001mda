// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  // Initialize AuthService via constructor; no 'late' needed
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;

  /// You can inject a custom AuthService (e.g., for testing).
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  // Remove updateAuthService; service is ready on creation

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isMechanic => _user?.userType == 'mechanic';
  bool get isCarOwner => _user?.userType == 'car_owner';
  String? get token => _user?.token;
  bool get isLoading => _isLoading;

  Future<bool> login(String loginId, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.login(loginId, password);
      _user = user;
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register(
    String username,
    String email,
    String password,
    String userType,
    String phone,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final user = await _authService.register(
        username,
        email,
        password,
        userType,
        phone,
      );
      _user = user;
      return true;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
