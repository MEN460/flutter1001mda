import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mechanic_discovery_app/services/location_service.dart';

class LocationProvider with ChangeNotifier {
  final LocationService _locationService;

  Position? _currentPosition;

  LocationProvider(this._locationService);

  Position? get currentPosition => _currentPosition;

  Future<void> getCurrentLocationAndUpdateBackend() async {
    try {
      final position = await _locationService.getCurrentLocation();
      _currentPosition = position;

      // Automatically push update to backend
      await _locationService.updateUserLocation(
        position.latitude,
        position.longitude,
      );

      notifyListeners();
    } catch (e) {
      print('[LocationProvider] Error retrieving or updating location: $e');
    }
  }

  Future<void> updateLocationManually(double latitude, double longitude) async {
    try {
      await _locationService.updateUserLocation(latitude, longitude);
      _currentPosition = Position(
        latitude: latitude,
        longitude: longitude,
        timestamp: DateTime.now(),
        accuracy: 0.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      );
      notifyListeners();
    } catch (e) {
      print('[LocationProvider] Manual location update failed: $e');
    }
  }

  Future<Position?> getCurrentPosition() async {
    try {
      final position = await _locationService.getCurrentLocation();
      _currentPosition = position;
      notifyListeners();
      return position;
    } catch (e) {
      print('[LocationProvider] Error retrieving location: $e');
      return null;
    }
  }
}
