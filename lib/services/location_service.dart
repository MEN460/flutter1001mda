import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_discovery_app/services/api_service.dart';
import 'package:mechanic_discovery_app/services/storage_service.dart';

class LocationService {
  final ApiService _api = ApiService();
  final StorageService _storage = StorageService();

  Future<Position> getCurrentLocation() async {
    if (!Platform.isAndroid && !Platform.isIOS) {
      // ⬇️ Desktop fallback
      return Position(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0, altitudeAccuracy: 1.0, headingAccuracy: 1.0,
      );
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled');
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permissions denied');
      }
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> updateUserLocation(double latitude, double longitude) async {
    final token = await _storage.getAccessToken();
    if (token == null) {
      throw Exception('[LocationService] No access token available');
    }

    await _api.post('/update-location', {
      'latitude': latitude,
      'longitude': longitude,
    }, token: token);
  }
}
