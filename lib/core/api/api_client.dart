
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_constants.dart';

class ApiClient {
  final String baseUrl = ApiConstants.baseUrl;

  Future<http.Response> get(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  Future<http.Response> post(String endpoint, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> put(String endpoint, dynamic data) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  Future<http.Response> delete(String endpoint) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    return http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
