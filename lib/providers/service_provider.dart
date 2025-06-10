import 'package:flutter/material.dart';
import 'package:mechanic_discovery_app/models/service_request_model.dart';
import 'package:mechanic_discovery_app/providers/auth_provider.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';


class ServiceProvider with ChangeNotifier {
  
  late AuthProvider _auth;
  late ApiService _apiService;
  late StorageService _storageService;

  List<ServiceRequest> _requests = [];

  List<ServiceRequest> get requests => _requests;

  void updateDependencies(
    AuthProvider auth,
    ApiService api,
    StorageService storage,
  ) {
    _auth = auth;
    _apiService = api;
    _storageService = storage;
  }

  Future<List<ServiceRequest>> getNearbyRequests() async {
    final token = await _storageService.getAccessToken();
    final response = await _apiService.get(
      '/service/nearby-requests',
      token: token,
    );

    _requests = (response as List)
        .map((item) => ServiceRequest.fromJson(item))
        .toList();

    notifyListeners();
    return _requests;
  }

  Future<void> acceptRequest(int requestId) async {
    final token = await _storageService.getAccessToken();
    await _apiService.post('/service/accept-request', {
      'request_id': requestId,
    }, token: token);

    // Update the local list
    _requests = _requests.map((request) {
      if (request.id == requestId) {
        return ServiceRequest(
          id: request.id,
          carOwnerId: request.carOwnerId,
          mechanicId: request.mechanicId,
          latitude: request.latitude,
          longitude: request.longitude,
          description: request.description,
          status: 'accepted',
          acceptedAt: DateTime.now(),
        );
      }
      return request;
    }).toList();

    notifyListeners();
  }

  Future<void> requestService(
    double latitude,
    double longitude,
    String description,
  ) async {
    final token = await _storageService.getAccessToken();

    // 🔍 DEBUG: Log token and input data
    print('[RequestService] token: $token');
    print('[RequestService] latitude: $latitude, longitude: $longitude');
    print('[RequestService] description: $description');

    await _apiService.post('/service/request-service', {
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
    }, token: token);
  }
}
