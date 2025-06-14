import 'package:flutter_dotenv/flutter_dotenv.dart';
<<<<<<< HEAD

class ApiEndpoints {
  static String baseUrl = dotenv.get(
    'API_URL',
    fallback: 'http://localhost:5000',
  );

  static String get apiBase => '$baseUrl/api';

  static String get login => '$apiBase/auth/login';
  static String get register => '$apiBase/auth/register';
  static String get userProfile => '$apiBase/user/profile';
  static String get updateLocation => '$apiBase/update-location';
  static String get nearbyMechanics => '$apiBase/mechanics/nearby-mechanics';
  static String get nearbyRequests => '$apiBase/service/nearby-requests';
  static String get serviceRequest => '$apiBase/service/request-service';
  static String get acceptRequest => '$apiBase/service/accept-request';
  static String get health => '$apiBase/health';
  static String get updateProfile => '$apiBase/user/update-profile';
=======

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
>>>>>>> d02c06fd42dd76ac6c2a6de1e056817b72f0a301
}
