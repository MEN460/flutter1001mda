// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late AuthService _authService;
  UserModel? _user;

  AuthProvider();

  void updateAuthService(AuthService authService) {
    _authService = authService;
  }

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isMechanic => _user?.userType == 'mechanic';
  bool get isCarOwner => _user?.userType == 'car_owner';
  String? get token => _user?.token;

  Future<void> register(
    String username,
    String email,
    String password,
    String userType,
    String phone,
  ) async {
    try {
      _user = await _authService.register(
        username,
        email,
        password,
        userType,
        phone,
      );
      notifyListeners();
    } catch (e) {
      print("Register failed: $e");
      rethrow;
    }
  }

  Future<bool> login(String loginId, String password) async {
    try {
      _user = await _authService.login(loginId, password);
      notifyListeners();
      return _user != null;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      _user = null;
      notifyListeners();
    }
  }
}
