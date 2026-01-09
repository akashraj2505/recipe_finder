import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Generic GET request
  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Request failed with status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw ApiException(e.toString());
    }
  }
}

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  @override
  String toString() => message;
}
