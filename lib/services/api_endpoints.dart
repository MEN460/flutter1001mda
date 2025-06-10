// lib/services/api_endpoints.dart

import 'package:flutter_dotenv/flutter_dotenv.dart';
String baseUrl = dotenv.get('BASE_URL', fallback: 'http://localhost:5000/api');

class ApiEndpoints {
  static const String baseUrl = 'http://your-backend-domain.com/api';

  // Auth endpoints
  static const String register = '$baseUrl/auth/register';
  static const String login = '$baseUrl/auth/login';

  // Location endpoints
  static const String updateLocation = '$baseUrl/location/update-location';

  // Mechanics endpoints
  static const String nearbyMechanics = '$baseUrl/mechanics/nearby-mechanics';

  // Service endpoints
  static const String requestService = '$baseUrl/service/request-service';
  static const String acceptRequest = '$baseUrl/service/accept-request';
  static const String nearbyRequests = '$baseUrl/service/nearby-requests';
}
