import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['API_URL'];

  Future<dynamic> post(String endpoint, dynamic body, {String? token}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> get(String endpoint, {String? token}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl$endpoint'),
      headers: {if (token != null) 'Authorization': 'Bearer $token'},
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final decoded = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    } else {
      final message = decoded['message'] ?? decoded['error'] ?? 'Unknown error';
      throw Exception('Error ${response.statusCode}: $message');
    }
  }
}
