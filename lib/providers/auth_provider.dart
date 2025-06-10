import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  late AuthService _authService;
  UserModel? _user;

  // Default constructor without AuthService
  AuthProvider();

  // Setter to inject AuthService instance later
  void updateAuthService(AuthService authService) {
    _authService = authService;
  }

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isMechanic => _user?.userType == 'mechanic';
  bool get isCarOwner => _user?.userType == 'car_owner';

  get token => null;

  Future<void> register(
    String username,
    String email,
    String password,
    String userType,
    String phone,
  ) async {
    _user = await _authService.register(
      username,
      email,
      password,
      userType,
      phone,
    );
    notifyListeners();
  }

  Future<bool> login(String loginId, String password) async {
    _user = await _authService.login(loginId, password);
    notifyListeners();
    return _user != null;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
