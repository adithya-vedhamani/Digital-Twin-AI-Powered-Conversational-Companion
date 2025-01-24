import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umt_chat/models/user.dart';
import 'package:umt_chat/models/personality.dart';

class ApiService {
  final String baseUrl =
      "http://10.123.19.86:8000"; // Update to your FastAPI URL

  // Create User
  Future<Map<String, dynamic>> createUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse(
            '$baseUrl/users/'), // Make sure this endpoint exists in your FastAPI backend
        body: json.encode(user.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Ensure the status code is 201 for a successful user creation
        return json.decode(response
            .body); // This will return the user details, including the user ID
      } else {
        throw Exception(
            'Failed to create user: ${response.body}'); // Include response body for debugging
      }
    } catch (e) {
      throw Exception(
          'Error creating user: $e'); // Catch any network or unexpected errors
    }
  }

  // Add Personality Entry
  Future<Map<String, dynamic>> addPersonalityEntry(
      PersonalityEntry entry) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/personality/'),
        body: json.encode(entry.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add personality entry');
      }
    } catch (e) {
      throw Exception('Error adding personality entry: $e');
    }
  }

  // Simulate Message Response
  Future<Map<String, dynamic>> simulateResponse(
      int userId, String message) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/simulate/'),
        body: json.encode({'user_id': userId, 'message': message}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to simulate response');
      }
    } catch (e) {
      throw Exception('Error simulating response: $e');
    }
  }
}
