import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/user_model.dart';
import 'package:mechanic_discovery_app/services/auth_service.dart';

class AuthProvider with ChangeNotifier {
<<<<<<< HEAD
=======
  // Initialize AuthService via constructor; no 'late' needed
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  final AuthService _authService;
  UserModel? _user;
  bool _isLoading = false;

<<<<<<< HEAD
  AuthProvider({required AuthService authService}) : _authService = authService;
=======
  /// You can inject a custom AuthService (e.g., for testing).
  AuthProvider({AuthService? authService})
    : _authService = authService ?? AuthService();

  // Remove updateAuthService; service is ready on creation
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isMechanic => _user?.userType == 'mechanic';
  bool get isCarOwner => _user?.userType == 'car_owner';
<<<<<<< HEAD
  bool get isLoading => _isLoading;
  int? get currentUserId => _user?.id;

  Future<void> login(String loginId, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      _user = await _authService.login(loginId, password);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
=======
  String? get token => _user?.token;
  bool get isLoading => _isLoading;
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301

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
<<<<<<< HEAD
=======
      _user = user;
      return true;
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
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
<<<<<<< HEAD
  }


  void updateUserLocation(double latitude, double longitude) {
    if (_user != null) {
      _user = _user!.copyWith(
        currentLatitude: latitude,
        currentLongitude: longitude,
      );
      notifyListeners(); // Add missing notify
    }
=======
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
  }

  Future<void> updateProfile(String specialization, String phone) async {
    // Implementation to update profile through API
    _user = _user?.copyWith(specialization: specialization, phone: phone);
    notifyListeners();
  }
}
// This provider handles user authentication, including login, registration, and logout.
// It also manages the current user state and provides methods to check user type and loading status.