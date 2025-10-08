import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../features/Signup/models/signup_data.dart';


class ApiService {
  static const String baseUrl =
      'https://www.outletexpense.xyz/api/user-registration'; // Replace with your actual API endpoint

  Future<void> submitSignupData(SignupData data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to submit signup data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
