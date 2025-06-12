// lib/services/api_endpoints.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';

String baseUrl = dotenv.get('BASE_URL', fallback: 'http://localhost:5000/api');

class ApiEndpoints {
  static const String baseUrl = 'https://your-api-base-url.com';
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String userProfile = '/user/profile';
  static const String updateLocation = '/user/update-location';
  static const String nearbyMechanics = '/mechanics/nearby-mechanics';
  static const String nearbyRequests = '/requests/nearby';
  static const String serviceRequest = '/requests/service';
  // Add more endpoints as needed
}
