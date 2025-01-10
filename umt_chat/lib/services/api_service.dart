import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:umt_chat/models/user.dart';
import 'package:umt_chat/models/personality.dart';

class ApiService {
  final String baseUrl = "http://192.168.1.6:8000/users/";
  // Change to your FastAPI URL

  // Create User
  Future<Map<String, dynamic>> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      body: json.encode(user.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  // Add Personality Entry
  Future<Map<String, dynamic>> addPersonalityEntry(
      PersonalityEntry entry) async {
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
  }

  // Simulate Message Response
  Future<Map<String, dynamic>> simulateResponse(
      int userId, String message) async {
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
  }
}
